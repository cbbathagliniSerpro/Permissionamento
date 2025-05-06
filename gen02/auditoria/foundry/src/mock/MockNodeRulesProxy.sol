// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../NodeRulesProxy.sol";

contract MockNodeRulesProxy is NodeRulesProxy {
    mapping(bytes32 => bytes32) private connectionResults;

    function setConnectionResult(
        bytes32 sourceEnodeHigh,
        bytes32 sourceEnodeLow,
        bytes16 sourceEnodeIp,
        uint16 sourceEnodePort,
        bytes32 destinationEnodeHigh,
        bytes32 destinationEnodeLow,
        bytes16 destinationEnodeIp,
        uint16 destinationEnodePort,
        bytes32 result
    ) external {
        bytes32 key = keccak256(
            abi.encodePacked(
                sourceEnodeHigh, sourceEnodeLow, sourceEnodeIp, sourceEnodePort,
                destinationEnodeHigh, destinationEnodeLow, destinationEnodeIp, destinationEnodePort
            )
        );
        connectionResults[key] = result;
    }


     function connectionAllowed(
        bytes32 sourceEnodeHigh,
        bytes32 sourceEnodeLow,
        bytes16 sourceEnodeIp,
        uint16 sourceEnodePort,
        bytes32 destinationEnodeHigh,
        bytes32 destinationEnodeLow,
        bytes16 destinationEnodeIp,
        uint16 destinationEnodePort
    ) external view override returns (bytes32) {
        bytes32 key = keccak256(
            abi.encodePacked(
                sourceEnodeHigh, sourceEnodeLow, sourceEnodeIp, sourceEnodePort,
                destinationEnodeHigh, destinationEnodeLow, destinationEnodeIp, destinationEnodePort
            )
        );
        return connectionResults[key];
    }

    
}