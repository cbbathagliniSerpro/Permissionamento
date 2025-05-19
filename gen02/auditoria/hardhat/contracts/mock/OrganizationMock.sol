// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract OrganizationMock {

    using EnumerableSet for EnumerableSet.UintSet;
    
    mapping(uint => bool) private activeOrganizations;
    mapping(uint => OrganizationData) public organizations;
    EnumerableSet.UintSet private _organizationIds;

    enum OrganizationType {
        Partner,
        Associate,
        Patron
    }

    struct OrganizationData {
        uint id;
        string cnpj;
        string name;
        OrganizationType orgType;
        bool canVote;
    }

    function setOrganizationActive(uint orgId, bool isActive) external {
        activeOrganizations[orgId] = isActive;
    }

    function isOrganizationActive(uint orgId) external view returns (bool) {
        return activeOrganizations[orgId];
    }

    function addOrganization(uint id, string calldata cnpj, string calldata name, OrganizationType orgType, bool canVote) external {
        organizations[id] = OrganizationData(id, cnpj, name, orgType, canVote);
        _organizationIds.add(id);
    }

    function getOrganizations() public view returns (OrganizationData[] memory) {
        uint length = _organizationIds.length();
        OrganizationData[] memory orgs = new OrganizationData[](length);

        for (uint i = 0; i < length; i++) {
            uint orgId = _organizationIds.at(i);
            orgs[i] = organizations[orgId];
        }

        return orgs;
    }
}
