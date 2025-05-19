// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";

import {AccountRulesV2} from "../src/AccountRulesV2.sol";
import {AccountRulesV2Impl} from "../src/AccountRulesV2Impl.sol";

import {NodeRulesV2} from "../src/NodeRulesV2.sol";
import {NodeRulesV2Impl} from "../src/NodeRulesV2Impl.sol";

import {Organization} from "../src/Organization.sol";
import {OrganizationImpl} from "../src/OrganizationImpl.sol";

import {Governance} from "../src/Governance.sol";
import {Governable} from "../src/Governable.sol";
import {Pagination} from "../src/Pagination.sol";

contract NodeRulesV2ImplFuzzTest is Test {

    NodeRulesV2Impl internal nodeRules;
    OrganizationImpl internal organization;
    AccountRulesV2Impl internal accounts;
    MockAdminProxy internal adminProxy;

    address internal globalAdmin1;
    address internal globalAdmin2;


    bytes32 constant GLOBAL_ADMIN_ROLE = keccak256("GLOBAL_ADMIN_ROLE");
    bytes32 constant LOCAL_ADMIN_ROLE = keccak256("LOCAL_ADMIN_ROLE");
    bytes32 constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
    bytes32 constant USER_ROLE = keccak256("USER_ROLE");

    bytes32 constant CONNECTION_ALLOWED = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    bytes32 constant CONNECTION_DENIED = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    function setUp() public {
        
        adminProxy = new MockAdminProxy();

        Organization.OrganizationData[] memory orgs = new Organization.OrganizationData[](2);
        orgs[0] = Organization.OrganizationData({id: 1, name: "OrgOne", cnpj: "73418139000123", orgType: Organization.OrganizationType.Associate, canVote: true});
        orgs[1] = Organization.OrganizationData({id: 2, name: "OrgTwo",  cnpj: "28451127000146", orgType: Organization.OrganizationType.Partner, canVote: false});
        
        organization = new OrganizationImpl(orgs, adminProxy);

        globalAdmin1 = makeAddr("GlobalAdmin1"); // orgId=1
        globalAdmin2 = makeAddr("GlobalAdmin2"); // orgId=2

        address[] memory adminAccounts = new address[](2);
        adminAccounts[0] = globalAdmin1;
        adminAccounts[1] = globalAdmin2;

        accounts = new AccountRulesV2Impl(organization,adminAccounts,adminProxy);

        nodeRules = new NodeRulesV2Impl(organization,accounts,adminProxy);

        adminProxy.setAuthorized(address(this), true);
    }

   
    function _makeCallerLocalAdmin(address caller, uint orgId) internal {
        address globalAdmin = (orgId == 1) ? globalAdmin1 : globalAdmin2;
        vm.prank(globalAdmin);
        accounts.addLocalAccount(caller, LOCAL_ADMIN_ROLE, 0); // dataHash=0 p/ admin
    }

    function _randomNodeType() internal view returns (NodeRulesV2.NodeType) {
        uint r = uint(keccak256(abi.encodePacked(block.timestamp, block.number, gasleft()))) % 3;
        if (r == 0) return NodeRulesV2.NodeType.Boot;
        if (r == 1) return NodeRulesV2.NodeType.Validator;
        return NodeRulesV2.NodeType.Other; 
    }

    
    function testFuzz_AddLocalNode(address caller, bytes32 enodeHigh, bytes32 enodeLow, string calldata name) public {
      
        NodeRulesV2.NodeType nodeType = _randomNodeType();

        vm.prank(caller);
        try nodeRules.addLocalNode(enodeHigh, enodeLow, nodeType, name) {
            uint key = uint(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
            NodeRulesV2.NodeData memory nd = nodeRules.getNode(enodeHigh, enodeLow);
            assertEq(nd.enodeHigh, enodeHigh);
            assertEq(nd.enodeLow, enodeLow);
            assertEq(uint(nd.nodeType), uint(nodeType));
            assertEq(nd.name, name);
            assertEq(nd.orgId, accounts.getAccount(caller).orgId);
            assertTrue(nd.active);
        } catch (bytes memory reason) {
            // motivos: UnauthorizedAccess, InactiveAccount, InvalidArgument("Node name cannot be empty."), DuplicateNode, etc.
            console.log("addLocalNode revert reason:", string(reason));
        }
    }

    function testFuzz_DeleteLocalNode(address caller, bytes32 enodeHigh, bytes32 enodeLow) public {
        
        vm.prank(caller);
        try nodeRules.deleteLocalNode(enodeHigh, enodeLow) {
            vm.expectRevert(abi.encodeWithSelector(NodeRulesV2.NodeNotFound.selector, enodeHigh, enodeLow));
            nodeRules.getNode(enodeHigh, enodeLow); // ao tentar pegar não encontra
        } catch (bytes memory reason) {
            // motivos: UnauthorizedAccess, InactiveAccount, NodeNotFound, NotLocalNode etc
            console.log("deleteLocalNode revert reason:", string(reason));
        }
    }
 
    function testFuzz_DeleteNode(
        address caller,
        bytes32 enodeHigh,
        bytes32 enodeLow
    ) public {
      
        nodeRules.addNode(enodeHigh, enodeLow, NodeRulesV2.NodeType.Other, "fuzzNode", 1);

        bool isAuth = (uint256(keccak256(abi.encode(caller))) % 2 == 0);
        adminProxy.setAuthorized(caller, isAuth);

        vm.prank(caller);
        try nodeRules.deleteNode(enodeHigh, enodeLow) {
            vm.expectRevert(abi.encodeWithSelector(NodeRulesV2.NodeNotFound.selector, enodeHigh, enodeLow));
            nodeRules.getNode(enodeHigh, enodeLow);
        } catch {}
    }

    //revisar
    // function testFuzz_UpdateLocalNode(
    //     address caller,
    //     bytes32 enodeHigh,
    //     bytes32 enodeLow,
    //     NodeRulesV2.NodeType newType,
    //     string calldata newName
    // ) public {
    //     console.log("UPDATE LOCAL NODE");
    //     if(bytes(newName).length == 0){
    //         console.log("Node name cannot be empty.");
    //         vm.expectRevert(abi.encodeWithSelector(NodeRulesV2.InvalidArgument.selector, "Node name cannot be empty."));
    //         nodeRules.updateLocalNode(enodeHigh, enodeLow, newType, newName);
    //     }else{
    //         if(nodeRules.getNode(enodeHigh, enodeLow).orgId == 0){
    //             console.log("Node nao existe");
    //             vm.expectRevert(abi.encodeWithSelector(NodeRulesV2.NodeNotFound.selector, enodeHigh, enodeLow));
    //             nodeRules.updateLocalNode(enodeHigh, enodeLow, newType, newName);
    //         }else{
    //             console.log("Atualizar o node");
    //             vm.prank(caller);
    //             try nodeRules.updateLocalNode(enodeHigh, enodeLow, newType, newName) {
    //                 // Se sucesso, confere se atualizou
    //                 NodeRulesV2.NodeData memory nd = nodeRules.getNode(enodeHigh, enodeLow);
    //                 assertEq(uint(nd.nodeType), uint(newType));
    //                 assertEq(nd.name, newName);
    //             } catch (bytes memory reason) {
    //                 console.log("updateLocalNode revert reason:", string(reason));
    //             }
    //         }
    //     }
    // }

    function testFuzz_UpdateLocalNodeStatus(address caller, bytes32 enodeHigh, bytes32 enodeLow, bool newActive) public {
       
        vm.prank(caller);
        try nodeRules.updateLocalNodeStatus(enodeHigh, enodeLow, newActive) {
            NodeRulesV2.NodeData memory nd = nodeRules.getNode(enodeHigh, enodeLow);
            assertEq(nd.active, newActive);
        } catch (bytes memory reason) {
            console.log("updateLocalNodeStatus revert reason:", string(reason));
        }
    }

    function testFuzz_GetNodeAndPagination(address caller, bytes32 enodeHigh, bytes32 enodeLow, uint page, uint pageSize) public {
       
        vm.prank(globalAdmin1);
        nodeRules.addLocalNode(enodeHigh, enodeLow, NodeRulesV2.NodeType.Other, "someName");

        try nodeRules.getNode(enodeHigh, enodeLow) {
           nodeRules.isNodeActive(enodeHigh, enodeLow);
        } catch {
            console.log("Node nao esta ativo");
        }
        console.log("page: " , page);
        console.log("pagesize: " , pageSize);

        if(page< 1 && pageSize >= 1){
            vm.expectRevert(abi.encodeWithSelector(Pagination.InvalidPaginationParameter.selector));
            nodeRules.getNodes(page, pageSize); 
        }else if(page>= 1 && pageSize < 1){
            vm.expectRevert(abi.encodeWithSelector(Pagination.InvalidPaginationParameter.selector));
            nodeRules.getNodes(page, pageSize); 
        }else{
            try nodeRules.getNodes(page, pageSize) {
                // Se page < 1 ou pageSize < 1 => revert InvalidPaginationParameter
            } catch (bytes memory reason) {
                console.log("getNodes revert reason:", string(reason));
            }
            
        }

        if(page< 1 && pageSize >= 1){
            vm.expectRevert(abi.encodeWithSelector(Pagination.InvalidPaginationParameter.selector));
            nodeRules.getNodesByOrg(1, page, pageSize); 
        }else if(page>= 1 && pageSize < 1){
            vm.expectRevert(abi.encodeWithSelector(Pagination.InvalidPaginationParameter.selector));
            nodeRules.getNodesByOrg(1, page, pageSize); 
        }else{

            try nodeRules.getNodesByOrg(1, page, pageSize) {
            
            } catch (bytes memory reason) {
                console.log("getNodes revert reason:", string(reason));
            }
            
        }
        
    }

    function testFuzz_ConnectionAllowed(bytes32 sourceHigh, bytes32 sourceLow, bytes32 destHigh, bytes32 destLow, bool sourceActive, bool destActive) public {
        
        vm.prank(globalAdmin1);
        nodeRules.addLocalNode(sourceHigh, sourceLow, NodeRulesV2.NodeType.Other, "srcNode");
        vm.prank(globalAdmin1);
        nodeRules.addLocalNode(destHigh, destLow, NodeRulesV2.NodeType.Other, "dstNode");

        if (!sourceActive) {
            vm.prank(globalAdmin1);
            nodeRules.updateLocalNodeStatus(sourceHigh, sourceLow, false);
        }

        if (!destActive) {
            vm.prank(globalAdmin1);
            nodeRules.updateLocalNodeStatus(destHigh, destLow, false);
        }

        bytes32 result = nodeRules.connectionAllowed(sourceHigh, sourceLow, bytes16(0), 0, destHigh, destLow, bytes16(0), 0);
        
        if (sourceActive && destActive) {
            assertEq(result, CONNECTION_ALLOWED);
        } else {
            assertEq(result, CONNECTION_DENIED);
        }
    }
}
