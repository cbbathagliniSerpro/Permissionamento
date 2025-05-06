// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.26;

import "../AdminProxy.sol";

contract AdminProxyMock is AdminProxy {
    mapping(address => bool) private authorizedAddress;
    address[] private addresses;

    function isAuthorized(address source) external view override returns (bool) {
        return authorizedAddress[source];
    }

    function setAuthorized(address source, bool status) external {
        authorizedAddress[source] = status;
        addresses.push(source);
    }

    function isAValidAddress(address source) external returns (bool){
        if(source == address(0)){
            revert InvalidSourceAddress(source);
        }
        return true;
    }

    function getAllAuthorizedAddresses() public view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < addresses.length; i++) {
            if (authorizedAddress[addresses[i]]) {
                count++;
            }
        }

        address[] memory authorizedList = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < addresses.length; i++) {
            if (authorizedAddress[addresses[i]]) {
                authorizedList[index] = addresses[i];
                index++;
            }
        }
        return authorizedList;
    }
}