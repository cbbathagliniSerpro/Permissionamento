// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MockAdminProxy} from "../src/mock/MockAdminProxy.sol";
import {AdminProxy} from "../src/AdminProxy.sol";

contract AdminProxyTest is Test {
    MockAdminProxy public mockAdminProxy;

    function setUp() public {
        console.log(">>>>> [FUZZY] AdminProxy test");
        mockAdminProxy = new MockAdminProxy();
    }

    function testIsAuthorized(address addr, bool authorized) public {

        vm.assume(addr != address(0)); //end não pode ser 0x0

        mockAdminProxy.setAuthorized(addr, authorized);

        bool isAuthorized = mockAdminProxy.isAuthorized(addr);
        if(authorized){
            assertTrue(isAuthorized);
        }else{
            assertFalse(isAuthorized);
        }
       
    }

    function testIsAValidAddress(address addr) public {

        console.log('%s', addr);
        
        if(addr == address(0)){
            vm.expectRevert(abi.encodeWithSelector(AdminProxy.InvalidSourceAddress.selector, addr));
            mockAdminProxy.isAValidAddress(addr);
        }else{
            bool result = mockAdminProxy.isAValidAddress(addr);
            assertTrue(result, "Expected true for valid address");
        }
        
    }
}