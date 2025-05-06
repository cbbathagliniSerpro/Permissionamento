// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../Pagination.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract PaginationMock {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.UintSet private uintTestSet;
    EnumerableSet.AddressSet private addressTestSet;
    
    function getTestPageBounds(uint256 totalItems, uint256 pageNumber, uint256 pageSize) 
        external 
        pure 
        returns (uint256 start, uint256 stop) 
    {
        return Pagination.getPageBounds(totalItems, pageNumber, pageSize);
    }
    
    function resetUintTestSet() external {
        uint256 length = uintTestSet.length();
        for(uint256 i = 0; i < length; i++) {
            uintTestSet.remove(uintTestSet.at(0));
        }
    }
    
    function addUintToTestSet(uint256 value) external {
        uintTestSet.add(value);
    }
    
    function getUintTestPage(uint256 pageNumber, uint256 pageSize) external view returns (uint256[] memory) {
        return Pagination.getUintPage(uintTestSet, pageNumber, pageSize);
    }
    
    function getUintTestSetLength() external view returns (uint256) {
        return uintTestSet.length();
    }
    
    function resetAddressTestSet() external {
        uint256 length = addressTestSet.length();
        for(uint256 i = 0; i < length; i++) {
            addressTestSet.remove(addressTestSet.at(0));
        }
    }
    
    function addAddressToTestSet(address value) external {
        addressTestSet.add(value);
    }
    
    function getAddressTestPage(uint256 pageNumber, uint256 pageSize) external view returns (address[] memory) {
        return Pagination.getAddressPage(addressTestSet, pageNumber, pageSize);
    }
    
    function getAddressTestSetLength() external view returns (uint256) {
        return addressTestSet.length();
    }
}