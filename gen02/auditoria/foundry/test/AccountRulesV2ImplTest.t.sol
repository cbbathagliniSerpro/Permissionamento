// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";
import {AccountRulesV2Impl} from "../src/AccountRulesV2Impl.sol";
import {AccountRulesV2} from "../src/AccountRulesV2.sol";
import {Organization} from "../src/Organization.sol";
import {OrganizationImpl} from "../src/OrganizationImpl.sol";
import {Governance} from "../src/Governance.sol";
import {Governable} from "../src/Governable.sol";

contract AccountRulesV2FuzzTest is Test {
    AccountRulesV2Impl internal accountRules;
    MockAdminProxy internal adminProxy;
    Governance internal governance;
    Organization internal organization;

    bytes32 constant GLOBAL_ADMIN_ROLE = keccak256("GLOBAL_ADMIN_ROLE");
    bytes32 constant LOCAL_ADMIN_ROLE = keccak256("LOCAL_ADMIN_ROLE");
    bytes32 constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
    bytes32 constant USER_ROLE = keccak256("USER_ROLE");

    address[] public globalAdmins;
    address internal owner;
    address internal globalAdmin1;
    address internal globalAdmin2;

    address internal localAdmin;
    address internal randomUser;
    
    address[] accountsAddrs;

    function setUp() public {

        owner = address(0x10);
        globalAdmin1 = address(0x11);
        globalAdmin2 = address(0x12);
       
        adminProxy = new MockAdminProxy();
        vm.prank(owner); // o deploy é feito pelo "owner"
        adminProxy.setAuthorized(owner, true);
    

        Organization.OrganizationData[] memory orgs = new Organization.OrganizationData[](2);
        orgs[0] = Organization.OrganizationData({id: 1, name: "OrgA", cnpj: "73418139000123", orgType: Organization.OrganizationType.Patron, canVote: true});
        orgs[1] = Organization.OrganizationData({id: 2, name: "OrgB",  cnpj: "28451127000146", orgType: Organization.OrganizationType.Partner, canVote: false});
        
        //deploy do OrganizationImpl
        organization = new OrganizationImpl(orgs, adminProxy); 
       
        globalAdmins.push(globalAdmin1);
        globalAdmins.push(globalAdmin2);

        // deploy do AccountRulesV2Impl
        accountRules = new AccountRulesV2Impl(organization, globalAdmins, adminProxy );
        
        localAdmin = makeAddr("localAdmin");
        randomUser = makeAddr("randomUser");

        adminProxy.setAuthorized(address(this), true);
        
        vm.prank(globalAdmin1);
        accountRules.addLocalAccount(localAdmin, LOCAL_ADMIN_ROLE, keccak256("someData"));
        accountsAddrs.push(localAdmin);

        governance = new Governance(organization, accountRules, adminProxy);
        
    }


    function testFuzz_addAccount(
        address caller,
        address newAccount,
        uint orgId,
        bytes32 roleId,
        bytes32 dataHash
    ) public {
        
        bool isAuthorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isAuthorized);
        
        vm.prank(caller);
        if (!isAuthorized) {
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            accountRules.addAccount(newAccount, orgId, roleId, dataHash);
        } else {
           
            if (newAccount == address(0)) {
                // Reverte com InvalidAccount
                vm.expectRevert(AccountRulesV2.InvalidAccount.selector);
                accountRules.addAccount(newAccount, orgId, roleId, dataHash);
            } else {
                bool orgExists = (orgId == 1 || orgId == 2);
                
                if (!orgExists) {
                
                    vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.InvalidOrganization.selector, orgId, "The informed organization is unknown"));
                    accountRules.addAccount(newAccount, orgId, roleId, dataHash);

                } else {
                    
                    
                    bool roleValida = accountRules.validRoles(roleId);
                    if (!roleValida) {
    
                        vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.InvalidRole.selector,roleId, "The informed role is unknown"));
                        accountRules.addAccount(newAccount, orgId, roleId, dataHash);

                    } else {
                        
                        bool isAdminRole = (roleId == GLOBAL_ADMIN_ROLE || roleId == LOCAL_ADMIN_ROLE); // se roleId != GLOBAL_ADMIN_ROLE && != LOCAL_ADMIN_ROLE, dataHash não pode ser 0
                        if (!isAdminRole && dataHash == 0) {
                            vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.InvalidHash.selector, dataHash, "Hash cannot be 0x0"));
                            accountRules.addAccount(newAccount, orgId, roleId, dataHash);
                        } else {
                            
                            if (accountRules.getAccount(newAccount).account != address(0)) {
                                vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.DuplicateAccount.selector, newAccount)); // conta já existe
                                accountRules.addAccount(newAccount, orgId, roleId, dataHash);
                            } else {

                                accountRules.addAccount(newAccount, orgId, roleId, dataHash);
                                
                                AccountRulesV2.AccountData memory accData = accountRules.getAccount(newAccount);
                                assertEq(accData.account, newAccount);
                                assertEq(accData.orgId, orgId);
                                assertEq(accData.roleId, roleId);
                                assertEq(accData.dataHash, dataHash);
                                assertTrue(accData.active);
                            }
                        }
                    }
                }
            }
        }
    }

    function testFuzz_deleteLocalAccount(address caller, address accountToRemove) public {

        vm.prank(caller); 

        try accountRules.deleteLocalAccount(accountToRemove) {
            vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.AccountNotFound.selector, accountToRemove));
            accountRules.getAccount(accountToRemove);
        } catch (bytes memory reason) {
            console.log("deleteLocalAccount revert reason:", string(reason));
        }
    }

    function testFuzz_updateLocalAccountStatus(
        address caller,
        address target,
        bool newStatus
    ) public {
        
        vm.prank(caller);
        try accountRules.updateLocalAccountStatus(target, newStatus) {
            AccountRulesV2.AccountData memory acct = accountRules.getAccount(target);
            assertEq(acct.active, newStatus);
        } catch (bytes memory reason) {
            console.log("updateLocalAccountStatus revert reason:", string(reason));
        }
    }

    function testFuzz_updateLocalAccount( address caller, address accountToUpdate, bytes32 newRole, bytes32 newDataHash) public {

        vm.prank(caller);

        try accountRules.updateLocalAccount(accountToUpdate, newRole, newDataHash) {
            AccountRulesV2.AccountData memory updated = accountRules.getAccount(accountToUpdate);
            assertEq(updated.roleId, newRole);
            assertEq(updated.dataHash, newDataHash);
        } catch (bytes memory reason) {
            console.log("updateLocalAccount revert reason:", string(reason));
        }
    }

    function testFuzz_addLocalAccount(address caller, address newAccount, bytes32 roleId, bytes32 dataHash) public {
       
        vm.assume(newAccount != address(0));
        vm.assume(roleId != bytes32(0));

        bool isAuthorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, true);
        
        vm.prank(caller);
        if(roleId == GLOBAL_ADMIN_ROLE){
           vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.InvalidRole.selector,roleId, "The role cannot be global admin"));
           accountRules.addLocalAccount(newAccount, roleId, dataHash); 
        }else{
            if(roleId != LOCAL_ADMIN_ROLE && roleId != DEPLOYER_ROLE && roleId != USER_ROLE){
                console.log("the roledid isnt valid");
                vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector,caller));
                accountRules.addLocalAccount(newAccount, roleId, dataHash); 
            }else{
                
                if(roleId != LOCAL_ADMIN_ROLE){
                    vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.InvalidRole.selector,roleId, "The informed role is unknown"));
                    accountRules.addLocalAccount(newAccount, roleId, dataHash); 
                }else{
                    console.log("Role valido");
                    if(accountRules.getAccount(newAccount).account != address(0)){
                        vm.expectRevert(abi.encodeWithSelector(AccountRulesV2.DuplicateAccount.selector,newAccount));
                        accountRules.addLocalAccount(newAccount, roleId, dataHash); 
                    }else{
                        
                        accountRules.addLocalAccount(newAccount, roleId, dataHash);

                        AccountRulesV2.AccountData memory acc = accountRules.getAccount(newAccount);
                        assertEq(acc.account, newAccount);
                        assertEq(acc.roleId, roleId);
                        assertEq(acc.dataHash, dataHash);
                        assertTrue(acc.active);
                    }
                }
            }
        }
    }

}
