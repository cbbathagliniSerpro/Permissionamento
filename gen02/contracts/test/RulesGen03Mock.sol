// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../AccountRulesProxy.sol";
import "../NodeRulesProxy.sol";

bytes32 constant CONNECTION_ALLOWED = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
bytes32 constant CONNECTION_DENIED = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

contract RulesGen03Mock is AccountRulesProxy, NodeRulesProxy {
    
    mapping (address => bool) public allowedSenders;
    mapping (uint => bool) public allowedNodes;

    function addSender(address sender) public {
        allowedSenders[sender] = true;
    }

    function deleteSender(address sender) public {
        delete allowedSenders[sender];
    }

    function addNode(bytes32 enodeHigh, bytes32 enodeLow) public {
        allowedNodes[calculateKey(enodeHigh, enodeLow)] = true;
    }

    function deleteNode(bytes32 enodeHigh, bytes32 enodeLow) public {
        delete allowedNodes[calculateKey(enodeHigh, enodeLow)];
    }

    function calculateKey(bytes32 enodeHigh, bytes32 enodeLow) public pure returns(uint) {
        return uint(keccak256(abi.encodePacked(enodeHigh, enodeLow)));
    }

    function transactionAllowed(address sender, address, uint256, uint256, uint256, bytes calldata) public view returns (bool) {
        return allowedSenders[sender];
    }

    function connectionAllowed(bytes32 srcHigh, bytes32 srcLow, bytes16, uint16, bytes32 dstHigh, bytes32 dstLow, bytes16, uint16) public view returns (bytes32) {
        if(allowedNodes[calculateKey(srcHigh, srcLow)] && allowedNodes[calculateKey(dstHigh, dstLow)]) {
            return CONNECTION_ALLOWED;
        }
        
        return CONNECTION_DENIED;
    }

}