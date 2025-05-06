// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {console} from "hardhat/console.sol";

bytes32 constant GLOBAL_ADMIN_ROLE = keccak256("GLOBAL_ADMIN_ROLE");
bytes32 constant LOCAL_ADMIN_ROLE = keccak256("LOCAL_ADMIN_ROLE");
bytes32 constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
bytes32 constant USER_ROLE = keccak256("USER_ROLE");

contract AccountRulesV2Mock {
    mapping(address => bool) private roles;
    mapping(address => bytes32) private rolesId;
    mapping(address => bool) private activeAccounts;
    mapping(address => uint) private orgIds;
    mapping (address => AccountData) public accounts;

    event AccountCreated(uint, address, bytes32, bool);
    event AccountSearched(uint, address, bytes32, bool);
            
    struct AccountData {
        uint orgId;
        address account;
        bytes32 roleId;
        bool active;
    }

    function createAccount(address account, bytes32 roleId, bool active, uint orgId) external returns (AccountData memory) {
        AccountData memory newAccount = AccountData(orgId , account, roleId, active);
        rolesId[account] = roleId;
        roles[account] = true;
        activeAccounts[account] = active;
        orgIds[account] = orgId;
        accounts[account] = newAccount;
        emit AccountCreated(orgId, account, roleId, active);
        return newAccount;
    }


    function getAccount(address account)  external view returns (AccountData memory) {

        //console.log("getAccount");
        string memory roleIdStr = bytes32ToHexString(rolesId[account]);
        // console.log("- Account roleId (as string):", roleIdStr);
        // console.log("- Account orgId:", accounts[account].orgId);
        // console.log("- Account address:", accounts[account].account);
        // console.log("- Account active:", accounts[account].active);

        require(accounts[account].account != address(0), "Account not found");
        
        return accounts[account];
    }

    function setRole(address account, bool hasRole) external {
        roles[account] = hasRole;
    }

    function setRoleId(address account, bytes32 roleId) external {
        rolesId[account] = roleId;
    }

    function setAccountActive(address account, bool isActive) external {
        activeAccounts[account] = isActive;
    }

    function setOrgId(address account, uint orgId) external {
        orgIds[account] = orgId;
    }

    function getOrgId(address account) external returns (uint){
        return orgIds[account];
    }

    function hasRole(bytes32, address account) external view returns (bool) {
        //console.log("account: ",  account);
        //console.log("roles[account]: ",  roles[account]);
        return roles[account];
    }

    function isAccountActive(address account) external view returns (bool) {
        return activeAccounts[account];
    }
    
    function bytes32ToHexString(bytes32 _bytes32) private pure returns (string memory) {
        bytes memory hexString = new bytes(64);
        bytes memory symbols = "0123456789abcdef";
        for (uint i = 0; i < 32; i++) {
            hexString[i * 2] = symbols[uint8(_bytes32[i] >> 4)];
            hexString[i * 2 + 1] = symbols[uint8(_bytes32[i] & 0x0f)];
        }
        return string(hexString);
    }
}
