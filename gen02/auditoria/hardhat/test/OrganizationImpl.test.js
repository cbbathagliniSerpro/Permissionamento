const { expect } = require("chai");
const { ethers } = require("hardhat");
const { keccak256, toUtf8Bytes,  Wallet, hexlify, randomBytes, ZeroAddress } = require("ethers");
const { BigNumber } = require("@ethersproject/bignumber");

describe("OrganizationImpl", function () {
    let organizationImpl;
    let organizationMock, adminProxyMock, accountRulesMock;
    let admin;

    const OrganizationType = {
        Partner: 0,
        Associate: 1,
        Patron: 2
      };

    beforeEach(async function () {

        const AdminProxyMockFactory = await ethers.getContractFactory("AdminProxyMock");
    adminProxyMock = await AdminProxyMockFactory.deploy();
    await adminProxyMock.waitForDeployment(); 

    const AccountRulesMockFactory = await ethers.getContractFactory("AccountRulesV2Mock");
    accountRulesMock = await AccountRulesMockFactory.deploy();
    await accountRulesMock.waitForDeployment(); 

    const OrganizationMockFactory = await ethers.getContractFactory("OrganizationMock");
    organizationMock = await OrganizationMockFactory.deploy();
    await organizationMock.waitForDeployment();

        const initialOrganizations = [
            { id: 1, cnpj: "25672842000110", name: "SERPRO", orgType: OrganizationType.Patron, canVote: true },
            { id: 2, cnpj: "15526778000106", name: "BNDES", orgType: OrganizationType.Patron, canVote: true },
            { id: 3, cnpj: "64581313000163", name: "TCU", orgType: OrganizationType.Partner, canVote: false },
            { id: 4, cnpj: "62328772000104", name: "BACEN", orgType: OrganizationType.Associate, canVote: false }
        ];

        const OrganizationFactory = await ethers.getContractFactory("OrganizationImpl");
        organizationImpl = await OrganizationFactory.deploy(
        initialOrganizations,
        adminProxyMock.target
        );
        await organizationImpl.waitForDeployment();

        // console.log("organizationImpl.address: ", organizationImpl.address);
        // console.log("adminProxyMock.address: ", adminProxyMock.address);

        [owner, admin, user] = await ethers.getSigners();

        const roleId = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));
        await accountRulesMock.setRole(admin.address, roleId); // Simula atribuir a role GLOBAL_ADMIN_ROLE
        await accountRulesMock.setAccountActive(admin.address, true); // Simula a conta ativa
    });

    describe("Constructor", function () {

        it("constructor should not deploy because it hasnt more than 1 organizations", async function () {
            const OrganizationImpl = await ethers.getContractFactory("OrganizationImpl");
            const initialOrganizations = [
                { id: 2, cnpj: "15526778000106", name: "BNDES", orgType: OrganizationType.Patron, canVote: true}
            ];
        
            // organizationImpl = await OrganizationFactory.deploy(
            //     initialOrganizations,
            //     adminProxyMock.target
            // );
            // await organizationImpl.waitForDeployment();
            
            await expect(
                OrganizationImpl.deploy(
                    initialOrganizations, 
                    adminProxyMock.target
                )
            ).to.be.revertedWith("At least 2 organizations must exist");

        });

        it("constructor should deploy because it has more than 2 organizations", async function () {
            const OrganizationImpl = await ethers.getContractFactory("OrganizationImpl");
            const initialOrganizations = [
                { id: 1, cnpj: "15526778000106", name: "BNDES", orgType: OrganizationType.Patron, canVote: true},
                { id: 2, cnpj: "80536052000116", name: "TCU", orgType: OrganizationType.Associate, canVote: true},
                { id: 3, cnpj: "48595484000195", name: "TJ", orgType: OrganizationType.Patron, canVote: true}
            ];
        
            
            OrganizationImpl.deploy(
                initialOrganizations, 
                adminProxyMock.target
            );
            
        });
    });

    it("should add an organization associate", async function () {

        const accountAddress = admin.address;
        await adminProxyMock.setAuthorized(accountAddress, true);

        const conn = await organizationImpl.connect(admin);
        //cnpj, string calldata name, OrganizationType orgType, bool canVote
        await expect(
            conn.addOrganization(
                "72129742000122",
                "org 4",
                OrganizationType.Associate,
                true
            )
            ).to.emit(organizationImpl, "OrganizationAdded");

        // Verificar se a organização foi adicionada
        const org = await organizationImpl.getOrganization(5);
        expect(org.name).to.equal("org 4");
        expect(org.canVote).to.be.true;
        expect(org.cnpj).to.equal("72129742000122");
    });

    it("should not add an organization partner because its cant vote", async function () {

        const accountAddress = admin.address;
        await adminProxyMock.setAuthorized(accountAddress, true);

        const conn = await organizationImpl.connect(admin);

        await expect(
            conn.addOrganization(
                "72129742000122",
                "org 4",
                OrganizationType.Partner,
                true
            )
        ).to.be.revertedWithCustomError(organizationImpl, "InvalidArgument");

    });

    it("should update an organization", async function () {

        const accountAddress = admin.address;
        await adminProxyMock.setAuthorized(accountAddress, true);

        const conn = await organizationImpl.connect(admin);
        await expect(
            conn. updateOrganization(
                1,
                "48583481000131",
                "SERPRO",
                OrganizationType.Patron,
                true
            )
            ).to.emit(organizationImpl, "OrganizationUpdated");

        // Verificar se a organização foi atualizada
        const org = await organizationImpl.getOrganization(1);
        expect(org.name).to.equal("SERPRO");
        expect(org.canVote).to.be.true;
        expect(org.cnpj).to.equal("48583481000131");
    });

    it("should delete an organization", async function () {

        const numberOfOrganizationsBeforeDelete = await organizationImpl.getOrganizationsLength();
        expect(numberOfOrganizationsBeforeDelete).to.equal(4);

        const accountAddress = admin.address;
        await adminProxyMock.setAuthorized(accountAddress, true);

        const conn = await organizationImpl.connect(admin);
        await expect(
            conn. deleteOrganization(2)
        ).to.emit(organizationImpl, "OrganizationDeleted");

        // Verificar se a organização foi removida
        await expect(
            organizationImpl.getOrganization(2)
        ).to.be.revertedWithCustomError(organizationImpl, "OrganizationNotFound");

        const numberOfOrganizations = await organizationImpl.getOrganizationsLength();
        expect(numberOfOrganizations).to.equal(3);
        console.log(numberOfOrganizations);
    });

});