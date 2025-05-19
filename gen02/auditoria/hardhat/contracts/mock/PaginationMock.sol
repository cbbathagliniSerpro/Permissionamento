// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../Pagination.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract PaginationMock {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.UintSet private uintSet;
    EnumerableSet.AddressSet private addressSet;

    function addUint(uint256 value) external {
        uintSet.add(value);
    }

    function addAddress(address value) external {
        addressSet.add(value);
    }

    function getUintPage(uint256 pageNumber, uint256 pageSize) external view returns (uint256[] memory) {
        return Pagination.getUintPage(uintSet, pageNumber, pageSize);
    }

    function getAddressPage(uint256 pageNumber, uint256 pageSize) external view returns (address[] memory) {
        return Pagination.getAddressPage(addressSet, pageNumber, pageSize);
    }

    function getPageBounds(uint256 totalItems, uint256 pageNumber, uint256 pageSize) external pure returns (uint256, uint256) {
        return Pagination.getPageBounds(totalItems, pageNumber, pageSize);
    }
}