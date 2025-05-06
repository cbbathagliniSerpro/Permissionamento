// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.28;

import "../Governable.sol";

contract GovernableTest is Governable {

    constructor(AdminProxy adminsProxy) Governable (adminsProxy) {}

    function governanceAllowedFunction() public onlyGovernance {}

    function publiclyAllowedFunction() public {}

}