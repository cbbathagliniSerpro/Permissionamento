// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../AdminProxy.sol";

contract AdminMock is AdminProxy {

    mapping (address => bool) public admins;

    function addAdmin(address source) public {
        admins[source] = true;
    }

    function removeAdmin(address source) public {
        admins[source] = false;
    }

    function isAuthorized(address source) public view returns (bool) {
        return admins[source];
    }

}
