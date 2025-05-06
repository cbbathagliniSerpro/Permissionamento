// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/mock/PaginationMock.sol"; // Ajuste o path conforme sua estrutura

contract PaginationTest is Test {
    PaginationMock internal pagination;

    address[] internal testAddresses;

    function setUp() public {
        pagination = new PaginationMock();
        
        // adiciona 10 uints para teste
        for (uint i = 1; i <= 10; i++) {
            pagination.addUint(i);
        }

        // adiciona 5 addresses para teste
        for (uint i = 1; i <= 5; i++) {
            address addr = address(uint160(i));
            testAddresses.push(addr);
            pagination.addAddress(addr);
        }
    }

    function testGetPageBoundsInvalidPageNumber() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getPageBounds(10, 0, 5);
    }

    function testGetPageBoundsInvalidPageSize() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getPageBounds(10, 1, 0);
    }

    function testGetPageBoundsOutOfBounds() public {
        (uint start, uint stop) = pagination.getPageBounds(5, 10, 5);
        assertEq(start, 0);
        assertEq(stop, 0);
    }

    function testGetPageBoundsNormal() public {
        (uint start, uint stop) = pagination.getPageBounds(20, 2, 5);
        assertEq(start, 5);
        assertEq(stop, 10);
    }

    function testGetPageBoundsAdjustStop() public {
        (uint start, uint stop) = pagination.getPageBounds(12, 3, 5);
        assertEq(start, 10);
        assertEq(stop, 12);
    }

    function testGetUintPageInvalidPageNumber() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getUintPage(0, 5);
    }

    function testGetUintPageInvalidPageSize() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getUintPage(1, 0);
    }

    function testGetUintPageReturnsCorrectPage() public {
        uint256[] memory page = pagination.getUintPage(2, 3);
        assertEq(page.length, 3);
        assertEq(page[0], 4);
        assertEq(page[1], 5);
        assertEq(page[2], 6);
    }

    function testGetUintPageEmptyWhenOutOfRange() public {
        uint256[] memory page = pagination.getUintPage(5, 10);
        assertEq(page.length, 0);
    }

    function testGetUintPageAdjustEndIndex() public {
        uint256[] memory page = pagination.getUintPage(4, 3);
        assertEq(page.length, 1);
        assertEq(page[0], 10);
    }

    function testGetAddressPageInvalidPageNumber() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getAddressPage(0, 3);
    }

    function testGetAddressPageInvalidPageSize() public {
        vm.expectRevert(Pagination.InvalidPaginationParameter.selector);
        pagination.getAddressPage(1, 0);
    }

    function testGetAddressPageReturnsCorrectPage() public {
        address[] memory page = pagination.getAddressPage(1, 2);
        assertEq(page.length, 2);
        assertEq(page[0], testAddresses[0]);
        assertEq(page[1], testAddresses[1]);
    }

    function testGetAddressPageEmptyWhenOutOfRange() public {
        address[] memory page = pagination.getAddressPage(3, 5);
        assertEq(page.length, 0);
    }

    function testGetAddressPageAdjustEndIndex() public {
        address[] memory page = pagination.getAddressPage(2, 3);
        assertEq(page.length, 2);
        assertEq(page[0], testAddresses[3]);
        assertEq(page[1], testAddresses[4]);
    }
}