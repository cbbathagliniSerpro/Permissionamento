// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

contract ExecutionMock {

    uint public code = 0;
    string public message = "No message";

    function setCode(uint newCode) public {
        code = newCode;
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    function revertTransaction() public pure {
        revert();
    }

}