// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FunctionCallMock {
    event FunctionCallMock(uint256 value);

    function mockFunction(uint256 value) external returns (uint256) {
        emit FunctionCallMock(value);
        return value;
    }
}