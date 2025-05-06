// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import {console} from "forge-std/console.sol";
import "./AdminProxy.sol";

abstract contract Governable {

    AdminProxy immutable public admins;

    error UnauthorizedAccess(address account);

    modifier onlyGovernance() {
        console.log("only governance");
        if(!admins.isAuthorized(msg.sender)) {
            revert UnauthorizedAccess(msg.sender);
        }
        _;
    }

    constructor(AdminProxy adminsProxy) {
        require(address(adminsProxy) != address(0), "Invalid address for Admin management smart contract");
        admins = adminsProxy;
   }

}