// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {AccountRulesProxy} from "../AccountRulesProxy.sol";

contract MockAccountRulesProxy is AccountRulesProxy {
    bool public mockTransactionAllowedResult;
    mapping(address => bool) public allowedSenders;
    mapping(address => bool) public allowedTargets;
    bytes public allowedPayload;


    function setTransactionAllowedResultMock(bool result) public {
        mockTransactionAllowedResult = result;
    }

    function allowSender(address sender) public {
        allowedSenders[sender] = true;
    }

    function allowTarget(address target) public {
        allowedTargets[target] = true;
    }

    function isSenderAddressValid(address sender) external returns (bool){
        if(sender == address(0)){
            revert InvalidSenderAddress(sender);
        }
        return true;
    }

    function isTargetAddressValid(address target) external returns (bool){
        if(target == address(0)){
            revert InvalidTargetAddress(target);
        }
        return true;
    }

    function setAllowedPayload(bytes calldata payload) public {
        allowedPayload = payload;
    }

    function transactionAllowed(
        address sender,
        address target,
        uint256 value,
        uint256 gasPrice,
        uint256 gasLimit,
        bytes calldata payload
    ) external view override returns (bool) {
        //transação é permitida se o sender, target e payload estiverem na lista de permitidos
        return allowedSenders[sender] && allowedTargets[target] && keccak256(payload) == keccak256(allowedPayload);
    }
}
