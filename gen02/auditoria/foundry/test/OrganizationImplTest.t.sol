// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";
import {OrganizationImpl} from "../src/OrganizationImpl.sol";
import {Organization} from "../src/Organization.sol";
import {Governable} from "../src/Governable.sol";

contract OrganizationImplTest is Test {
    MockAdminProxy internal adminProxy;
    OrganizationImpl internal orgImpl;

    address internal addr1;
    address internal addr2;

    function setUp() public {
    
        addr1 = address(0x1);
        addr2 = address(0x2);

        adminProxy = new MockAdminProxy(); //deploy adminmock
        adminProxy.setAuthorized(addr1, true); //addr 1 autorizado

        Organization.OrganizationData[] memory orgs = new Organization.OrganizationData[](2);
        orgs[0] = Organization.OrganizationData({id: 1, name: "OrgA", cnpj: "73418139000123", orgType: Organization.OrganizationType.Associate, canVote: true});
        orgs[1] = Organization.OrganizationData({id: 2, name: "OrgB", cnpj: "24060931000143", orgType: Organization.OrganizationType.Partner, canVote: false});
        
        orgImpl = new OrganizationImpl(orgs, adminProxy);

        assertTrue(orgImpl.isOrganizationActive(orgs[0].id));
        assertTrue(orgImpl.isOrganizationActive(orgs[1].id));
    }


    /*
        Testar a condição “At least 2 organizations must be active”
        - com um endereço autorizado
        - deve reverter lançando erro: Organization.IllegalState
    */
    function testDeleteWithTwoOrganizations() public {
      
        vm.prank(addr1); 
        vm.expectRevert(abi.encodeWithSelector(Organization.IllegalState.selector, "At least 2 organizations must be active"));
        orgImpl.deleteOrganization(1); //deletando org 1

        
        vm.prank(addr1);
        vm.expectRevert(abi.encodeWithSelector(Organization.IllegalState.selector, "At least 2 organizations must be active"));
        orgImpl.deleteOrganization(2); //deletando org 2
    }


    /*
        Testar a condição “At least 2 organizations must be active”
        - com um endereço não autorizado
        - deve reverter lançando erro: Governable.UnauthorizedAccess
    */
    function testTryingToDeleteOrganizationWithUnauthorizedAddr() public {
        vm.prank(addr2); 
        vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, addr2));
        orgImpl.deleteOrganization(1);     
    }


    /*
        Testar construtor
        - Passar um array com menos de 2 organizações (deve reverter).
        - Passar nomes vazios, repetidos, etc.
     */
    // function testFuzz_Constructor(Organization.OrganizationData[] memory orgs) public {
    //     //console.log("constructor 1: ", orgs.length);
    //     if (orgs.length < 2) {
    //         console.log(" menos de duas");
    //         vm.expectRevert("At least 2 organizations must exist");
    //         new OrganizationImpl(orgs, adminProxy);
    //     } else {
    //         console.log(" mais de duas");
    //         OrganizationImpl tempOrgImpl = new OrganizationImpl(orgs, adminProxy);
            
    //         Organization.OrganizationData[] memory stored = tempOrgImpl.getOrganizations();
    //         assertEq(stored.length, orgs.length); // check num de organizacoes corresponse
    //     }
    // }

    /*
        Testar consulta de organização
        - a organização precisa existir (senão reverte Organization.OrganizationNotFound)
    */
    function testFuzz_GetOrganization(uint orgId) public {
        if (orgId == 1 || orgId == 2) { //já existem
            Organization.OrganizationData memory data = orgImpl.getOrganization(orgId);
            assertEq(data.id, orgId);
        } else { // organização que não existe
            vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
            orgImpl.getOrganization(orgId);
        }
    }


    /*
        Testar a adição de uma de organização
        - apenas quem é da governança (senão reverte Governable.UnauthorizedAccess)
    */
    function testFuzz_AddOrganization(
        address caller, 
        string memory orgName, 
        string memory cnpj,
        bool canVote
    ) public {
        console.log(">>>>> [FUZZY] testFuzz_AddOrganization");

        vm.assume(bytes(cnpj).length > 0);
        vm.assume(bytes(orgName).length > 0);
        vm.assume(caller != address(0));
      
        bool isAuthorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);   // ajustar autorização do caller de forma randômica
        adminProxy.setAuthorized(caller, isAuthorized);

        vm.prank(caller);
        console.log("is authorized: ", isAuthorized);

        Organization.OrganizationType typeOf = Organization.OrganizationType.Partner;
        if(canVote){
            typeOf = Organization.OrganizationType.Associate;
        }

        if (isAuthorized) { //se foi autorizado
            uint newId = orgImpl.addOrganization(cnpj,orgName, Organization.OrganizationType.Associate, canVote);

            Organization.OrganizationData memory newOrg = orgImpl.getOrganization(newId);
            assertEq(newOrg.name, orgName);
            assertEq(newOrg.cnpj, cnpj);
            assertEq(newOrg.canVote, canVote);
            assertEq(newOrg.id, newId);
        } else {

            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.addOrganization(cnpj, orgName, typeOf, canVote);
        }
    }

/*
        Testar a adição de uma de organização
        - organizaçao do tipo partner
        - canvote fixo como true
        - apenas quem é da governança (senão reverte Governable.UnauthorizedAccess)
    */
    function testFuzz_AddOrganization_partnercantvote(
        address caller, 
        string memory orgName, 
        string memory cnpj
    ) public {
        console.log(">>>>> [FUZZY] testFuzz_AddOrganization_partnercantvote");

        vm.assume(bytes(cnpj).length > 0);
        vm.assume(bytes(orgName).length > 0);
        vm.assume(caller != address(0));
      
        bool isAuthorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);   // ajustar autorização do caller de forma randômica
        adminProxy.setAuthorized(caller, isAuthorized);

        bool canVote = true;
        
        vm.prank(caller);
        //console.log("is authorized: ", isAuthorized);

        if (isAuthorized) { //se foi autorizado
            vm.expectRevert(abi.encodeWithSelector(Organization.InvalidArgument.selector, "Partner organizations cannot vote"));
            uint newId = orgImpl.addOrganization(cnpj,orgName, Organization.OrganizationType.Partner, canVote);
        } else {
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.addOrganization(cnpj, orgName, Organization.OrganizationType.Partner, canVote);
        }
    }

    /*
        Testar a atualização de uma de organização
        - apenas quem é da governança (senão reverte Governable.UnauthorizedAccess)
        - apenas se a organização existe (senão reverte  Organization.OrganizationNotFound)
    */
    function testFuzz_UpdateOrganization_forPartner(
    address caller, 
    uint orgId, 
    string memory newName, 
    string memory newCnpj
    ) public {
        console.log(">>>>> [FUZZY] testFuzz_AddOrganization");
        vm.assume(caller != address(0));
        vm.assume(bytes(newName).length > 0);
        vm.assume(bytes(newCnpj).length > 0);
        
        console.log(">>>>> [FUZZY] !isGovernance");
        bool isGovernance = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isGovernance);

        bool orgExists = (orgId == 1 || orgId == 2);
        vm.prank(caller);

        if (!isGovernance) { 
            console.log(">>>>> [FUZZY] !isGovernance");
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Partner, false);
        } else {
            if (!orgExists) { 
                console.log(">>>>> [FUZZY] !orgExists");
                vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Partner, false);
            } else {
                console.log(">>>>> [FUZZY] orgExists");
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Partner, false);
                Organization.OrganizationData memory updated = orgImpl.getOrganization(orgId);
                assertEq(updated.name, newName);
                assertEq(updated.cnpj, newCnpj);
                assertEq(updated.canVote, false);
                console.log(">>>>> [FUZZY] end ok");
            }
        }
    }

    function testFuzz_UpdateOrganization_forPatron(
    address caller, 
    uint orgId, 
    string memory newName, 
    string memory newCnpj,
    bool canVote
    ) public {
        console.log(">>>>> [FUZZY] testFuzz_AddOrganization");
        vm.assume(caller != address(0));
        vm.assume(bytes(newName).length > 0);
        vm.assume(bytes(newCnpj).length > 0);
        
        console.log(">>>>> [FUZZY] !isGovernance");
        bool isGovernance = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isGovernance);

        bool orgExists = (orgId == 1 || orgId == 2);
        vm.prank(caller);

        if (!isGovernance) { 
            console.log(">>>>> [FUZZY] !isGovernance");
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Patron, canVote);
        } else {
            if (!orgExists) { 
                console.log(">>>>> [FUZZY] !orgExists");
                vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Patron, canVote);
            } else {
                console.log(">>>>> [FUZZY] orgExists");
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Patron, canVote);
                Organization.OrganizationData memory updated = orgImpl.getOrganization(orgId);
                assertEq(updated.name, newName);
                assertEq(updated.cnpj, newCnpj);
                assertEq(updated.canVote, canVote);
                //assertEq(updated.orgType, newType);
                console.log(">>>>> [FUZZY] end");
            }
        }
    }

    function testFuzz_UpdateOrganization_forAssoociate(
    address caller, 
    uint orgId, 
    string memory newName, 
    string memory newCnpj,
    bool canVote
    ) public {
        console.log(">>>>> [FUZZY] testFuzz_AddOrganization");
        vm.assume(caller != address(0));
        vm.assume(bytes(newName).length > 0);
        vm.assume(bytes(newCnpj).length > 0);
        
        console.log(">>>>> [FUZZY] !isGovernance");
        bool isGovernance = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isGovernance);

        bool orgExists = (orgId == 1 || orgId == 2);
        vm.prank(caller);

        if (!isGovernance) { 
            console.log(">>>>> [FUZZY] !isGovernance");
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Associate, canVote);
        } else {
            if (!orgExists) { 
                console.log(">>>>> [FUZZY] !orgExists");
                vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Associate, canVote);
            } else {
                console.log(">>>>> [FUZZY] orgExists");
                orgImpl.updateOrganization(orgId, newCnpj, newName, Organization.OrganizationType.Associate, canVote);
                Organization.OrganizationData memory updated = orgImpl.getOrganization(orgId);
                assertEq(updated.name, newName);
                assertEq(updated.cnpj, newCnpj);
                assertEq(updated.canVote, canVote);
                //assertEq(updated.orgType, newType);
                console.log(">>>>> [FUZZY] okokok");
            }
        }
    }

     /*
        Testar a remoção de uma de organização
        - Apenas quem é autorizado
        - Apenas se a organização já existe
    */
    function testFuzz_DeleteOrganization(uint orgId, address caller) public {
        vm.assume(caller != address(0));

        bool authorized = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, authorized);
        
        vm.startPrank(addr1); 
        uint extra1 = orgImpl.addOrganization("53444456000107", "OrganizacaoExtraUm", Organization.OrganizationType.Associate, false);
        uint extra2 = orgImpl.addOrganization("36433427000120", "OrganizacaoExtraDois", Organization.OrganizationType.Associate,true);
        vm.stopPrank();

        
        vm.prank(caller);
        if(!authorized) {
            vm.expectRevert(abi.encodeWithSelector(Governable.UnauthorizedAccess.selector, caller));
            orgImpl.deleteOrganization(orgId);
        } else {
            // Se orgId for inválido
            if(orgId == 0 || (orgId != 1 && orgId != 2 && orgId != extra1 && orgId != extra2)) {
                vm.expectRevert(abi.encodeWithSelector(Organization.OrganizationNotFound.selector, orgId));
                orgImpl.deleteOrganization(orgId);
            } else {
                orgImpl.deleteOrganization(orgId);
                bool active = orgImpl.isOrganizationActive(orgId);
                assertFalse(active, "Org deve ter sido removida");
            }
        }
    }
    
}
