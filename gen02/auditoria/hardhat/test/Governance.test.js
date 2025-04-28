const { expect } = require("chai");
const { ethers } = require("hardhat");
const { keccak256, toUtf8Bytes,  Wallet, hexlify, randomBytes } = require("ethers");

describe("Governance", function () {
  let governance, adminProxyMock, accountRulesMock, organizationMock;
  let admin, admin2, admin3, admin4, user;

  const GLOBAL_ADMIN_ROLE = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));
  const roleIdGlobal = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));
  const USER_ROLE = keccak256(toUtf8Bytes("USER_ROLE"));
  const OrganizationType = {
    Partner: 0,
    Associate: 1,
    Patron: 2
  };
  
  beforeEach(async function () {
    [admin, admin2, admin3, admin4, user] = await ethers.getSigners();

    const AdminProxyMockFactory = await ethers.getContractFactory("AdminProxyMock");
    adminProxyMock = await AdminProxyMockFactory.deploy();
    await adminProxyMock.waitForDeployment(); 

    const AccountRulesMockFactory = await ethers.getContractFactory("AccountRulesV2Mock");
    accountRulesMock = await AccountRulesMockFactory.deploy();
    await accountRulesMock.waitForDeployment(); 

    const OrganizationMockFactory = await ethers.getContractFactory("OrganizationMock");
    organizationMock = await OrganizationMockFactory.deploy();
    await organizationMock.waitForDeployment();


    const GovernanceFactory = await ethers.getContractFactory("Governance");
    governance = await GovernanceFactory.deploy(
    organizationMock.target, 
    accountRulesMock.target,
    adminProxyMock.target
    );
    await governance.waitForDeployment(); 

    // Setup admin account
    await adminProxyMock.setAuthorized(admin.address, true);
    await accountRulesMock.createAccount(admin.address, roleIdGlobal, true, 1);
    await accountRulesMock.createAccount(admin2.address, roleIdGlobal, true, 2);
    await accountRulesMock.createAccount(admin3.address, roleIdGlobal, true, 3);
    await accountRulesMock.createAccount(admin4.address, roleIdGlobal, true, 4);
    await accountRulesMock.createAccount(user.address, USER_ROLE, false, 4);
    console.log("Setup admin account");

    // Setup organizations
    await organizationMock.addOrganization(1, "25672842000110", "SERPRO", OrganizationType.Patron , true);
    await organizationMock.addOrganization(2, "15526778000106", "BNDES", OrganizationType.Associate , true);
    await organizationMock.addOrganization(3, "64581313000163", "TCU", OrganizationType.Associate , false);
    await organizationMock.addOrganization(4, "62328772000104", "BACEN", OrganizationType.Associate , false);
    console.log("Setup organizations");

  });

  describe("createProposal", function () {
    it("should create a proposal successfully", async function () {
     
      const targets = [Wallet.createRandom().address];
      const calldatas = [hexlify(randomBytes(32))];
      const blocksDuration = 100;
      const description = "Test proposal";
      const conn = governance.connect(admin);

      await expect(conn.createProposal(
        targets,
        calldatas,
        blocksDuration,
        description
      )).to.emit(governance, "ProposalCreated");

    
    });

    it("should revert with empty description", async function () {
        const targets = [Wallet.createRandom().address];
        const calldatas = [hexlify(randomBytes(32))];
        const conn = governance.connect(admin);
      
      await expect(
        conn.createProposal(targets, calldatas, 100, "")
      ).to.be.revertedWithCustomError(governance,"InvalidArgument");
    });

    it("should revert with zero duration", async function () {
        const targets = [Wallet.createRandom().address];
        const calldatas = [hexlify(randomBytes(32))];
      
        await expect(
            governance.connect(admin).createProposal(targets, calldatas, 0, "Test")
        ).to.be.revertedWithCustomError(governance,"InvalidArgument");
    });

    it("should revert with mismatched arrays", async function () {
      const targets = [Wallet.createRandom().address,Wallet.createRandom().address];
      const calldatas = [hexlify(randomBytes(32))];
      const conn = governance.connect(admin);
      
      await expect(
        conn.createProposal(targets, calldatas, 100, "Test")
      ).to.be.revertedWithCustomError(governance,"InvalidArgument");
    });

    it("should revert when non-admin tries to create", async function () {
      await expect(
        governance.connect(user).createProposal([], [], 100, "Test")
      ).to.be.revertedWithCustomError(governance,"UnauthorizedAccess");
    });
  });

  describe("cancelProposal", function () {
    let proposalId;
    let conn;

    beforeEach(async function () {
        conn = governance.connect(admin)
        const tx = await conn.createProposal(
            [Wallet.createRandom().address],
            [hexlify(randomBytes(32))],
            100,
            "Test proposal"
        );

        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1, "Transaction should succeed");
        
        const parsedLogs = receipt.logs
            .map((log) => {
                try {
                    return conn.interface.parseLog(log);
                } catch (e) {
                    return null;
                }
            })
            .filter((e) => e !== null);

        // parsedLogs.forEach((event, i) => {
        //     console.log(`Event #${i}: ${event.name}`, event.args);
        // });
          
        const proposalCreatedEvent = parsedLogs.find(e => e.name === "ProposalCreated");

        proposalId = proposalCreatedEvent?.args?.[0]; 

        console.log("Proposal ID:", proposalId?.toString());
        expect(proposalId).to.be.gt(0);
    });

    it("should cancel proposal successfully", async function () {
      await expect(
        conn.cancelProposal(proposalId, "Good reason")
      ).to.emit(governance, "ProposalCanceled");

    });

    it("should revert when non-proponent tries to cancel", async function () {
      await expect(
        governance.connect(admin2).cancelProposal(proposalId, "Reason")
      ).to.be.revertedWithCustomError(governance,"UnauthorizedAccess");
    });

    it("should revert with empty reason", async function () {
      await expect(
        governance.connect(admin).cancelProposal(proposalId, "")
      ).to.be.revertedWithCustomError(governance,"InvalidArgument");
    });

    it("should revert when proposal is not active", async function () {
      // First cancel the proposal
      await governance.connect(admin).cancelProposal(proposalId, "Reason");
      
      // Try to cancel again
      await expect(
        governance.connect(admin).cancelProposal(proposalId, "Reason")
      ).to.be.revertedWithCustomError(governance,"IllegalState");
    });
  });

  describe("castVote", function () {
    let proposalId;
    let conn;

    beforeEach(async function () {
        conn = governance.connect(admin)
        const tx = await conn.createProposal(
            [Wallet.createRandom().address],
            [hexlify(randomBytes(32))],
            2,
            "Test proposal"
        );

        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1, "Transaction should succeed");
        
        const parsedLogs = receipt.logs
            .map((log) => {
                try {
                    return conn.interface.parseLog(log);
                } catch (e) {
                    return null;
                }
            })
            .filter((e) => e !== null);

        const proposalCreatedEvent = parsedLogs.find(e => e.name === "ProposalCreated");

        proposalId = proposalCreatedEvent?.args?.[0]; 

        console.log("Proposal ID:", proposalId?.toString());
        expect(proposalId).to.be.gt(0);
    });

    it("should cast approval vote successfully", async function () {
      await expect(
        governance.connect(admin).castVote(proposalId, true)
      ).to.emit(governance, "OrganizationVoted");
    });

    it("should cast rejection vote successfully", async function () {
      await expect(
        governance.connect(admin).castVote(proposalId, false)
      ).to.emit(governance, "OrganizationVoted");
    });

    it("should revert when non-participant tries to vote", async function () {
      // admin3 is in org3 which can't vote (canVote=false)
      await expect(
        governance.connect(admin3).castVote(proposalId, true)
      ).to.be.revertedWithCustomError(governance,"UnauthorizedAccess");
    });

    it("should revert when voting twice", async function () {
      await governance.connect(admin).castVote(proposalId, true);
      await expect(
        governance.connect(admin).castVote(proposalId, true)
      ).to.be.revertedWithCustomError(governance,"IllegalState");
    });

    // it("should return false when proposal is finished", async function () {
    //     // // Cast votes to approve
    //     // await governance.connect(admin3).castVote(proposalId, true);
    //     // await governance.connect(admin4).castVote(proposalId, true);

    //   // Mine blocks to finish the proposal
    //   await ethers.provider.send("evm_mine", []);
    //   await ethers.provider.send("evm_mine", []);
      
    //   const result = await governance.connect(admin).castVote(proposalId, true);
    //   console.log("result: ", result)
    //   expect(result).to.be.false;
    // });
  });

  describe("executeProposal", function () {
    let proposalId;
    let conn;

    beforeEach(async function () {
        conn = governance.connect(admin)
        const tx = await conn.createProposal(
            [Wallet.createRandom().address],
            [hexlify(randomBytes(32))],
            2,
            "Test proposal"
        );

        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1, "Transaction should succeed");
        
        const parsedLogs = receipt.logs
            .map((log) => {
                try {
                    return conn.interface.parseLog(log);
                } catch (e) {
                    return null;
                }
            })
            .filter((e) => e !== null);

        const proposalCreatedEvent = parsedLogs.find(e => e.name === "ProposalCreated");

        proposalId = proposalCreatedEvent?.args?.[0]; 

        console.log("Proposal ID:", proposalId?.toString());
        expect(proposalId).to.be.gt(0);
      
        // Cast votes to approve
        await conn.castVote(proposalId, true);
        await governance.connect(admin2).castVote(proposalId, true);
        
        // Mine blocks to finish the proposal
        await ethers.provider.send("evm_mine", []);
        await ethers.provider.send("evm_mine", []);
    });

    //FIX
    // it("should execute proposal successfully", async function () {
    //   await expect(
    //     conn.executeProposal(proposalId)
    //   ).to.emit(governance, "ProposalExecuted");
    // });

    it("should revert when result is undefined", async function () {
        // Create a new proposal without voting
        const tx = await conn.createProposal(
            [Wallet.createRandom().address],
            [hexlify(randomBytes(32))],
            100,
            "New proposal"
        );
        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1, "Transaction should succeed");

        const parsedLogs = receipt.logs
            .map((log) => {
                try {
                    return conn.interface.parseLog(log);
                } catch (e) {
                    return null;
                }
            })
            .filter((e) => e !== null);

        const proposalCreatedEvent = parsedLogs.find(e => e.name === "ProposalCreated");

        const newProposalId = proposalCreatedEvent?.args?.[0]; 

        console.log("Proposal ID:", proposalId?.toString());
        expect(proposalId).to.be.gt(0);
      
        await expect(
            governance.connect(admin).executeProposal(newProposalId)
        ).to.be.revertedWithCustomError(governance,"IllegalState");
    });

    it("should revert when non-participant tries to execute", async function () {
      await expect(
        governance.connect(admin3).executeProposal(proposalId)
      ).to.be.revertedWithCustomError(governance,"UnauthorizedAccess");
    });
  });

  describe("view functions", function () {
    let proposalId;
    let conn;

    beforeEach(async function () {
        conn = governance.connect(admin)
        const tx = await conn.createProposal(
            [Wallet.createRandom().address],
            [hexlify(randomBytes(32))],
            2,
            "Test proposal"
        );

        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1, "Transaction should succeed");
        
        const parsedLogs = receipt.logs
            .map((log) => {
                try {
                    return conn.interface.parseLog(log);
                } catch (e) {
                    return null;
                }
            })
            .filter((e) => e !== null);

        const proposalCreatedEvent = parsedLogs.find(e => e.name === "ProposalCreated");

        proposalId = proposalCreatedEvent?.args?.[0]; 

        console.log("Proposal ID:", proposalId?.toString());
        expect(proposalId).to.be.gt(0);
    });

    it("should get proposal details", async function () {
      const proposal = await governance.getProposal(proposalId);
      expect(proposal.id).to.equal(proposalId);
      expect(proposal.description).to.equal("Test proposal");
    });

    it("should get number of proposals", async function () {
      const count = await governance.getNumberOfProposals();
      expect(count).to.equal(1);
    });

    it("should get paginated proposals", async function () {
      const proposals = await governance.getProposals(1, 10);
      expect(proposals.length).to.equal(1);
      expect(proposals[0].id).to.equal(proposalId);
    });

    it("should revert when getting non-existent proposal", async function () {
      await expect(governance.getProposal(999)).to.be.revertedWithCustomError(governance,"ProposalNotFound");
    });
  });
});