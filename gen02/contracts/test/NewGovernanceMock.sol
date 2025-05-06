// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract NewGovernanceMock {

    function executeAnything(address target, bytes calldata data) public returns (bytes memory) {
        return Address.functionCall(target, data);
    }

}