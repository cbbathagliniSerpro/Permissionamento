const { expect } = require("chai");
const { ethers } = require("hardhat");
const { keccak256, toUtf8Bytes,  Wallet, hexlify, randomBytes, ZeroAddress } = require("ethers");
const { BigNumber } = require("@ethersproject/bignumber");


describe("NodeRulesV2Impl", function () {
  let NodeRulesV2Impl, nodeRules;
  let organizationMock, accountRulesMock, adminProxyMock;
  let admin, user;

  const enodeHighBt32 = ethers.encodeBytes32String("enodeHigh");
  const enodeLowBt32 = ethers.encodeBytes32String("enodeLow");
  const roleId = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));

  const CONNECTION_ALLOWED = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  const CONNECTION_DENIED = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

  const orgId = 1;

  beforeEach(async function () {
    // Mock dos contratos Organization, AccountRulesV2 e AdminProxy
    const AdminProxyMockFactory = await ethers.getContractFactory("AdminProxyMock");
    adminProxyMock = await AdminProxyMockFactory.deploy();
    await adminProxyMock.waitForDeployment(); 

    const AccountRulesMockFactory = await ethers.getContractFactory("AccountRulesV2Mock");
    accountRulesMock = await AccountRulesMockFactory.deploy();
    await accountRulesMock.waitForDeployment(); 

    const OrganizationMockFactory = await ethers.getContractFactory("OrganizationMock");
    organizationMock = await OrganizationMockFactory.deploy();
    await organizationMock.waitForDeployment();

    const NodeRulesFactory = await ethers.getContractFactory("NodeRulesV2Impl");
    nodeRules = await NodeRulesFactory.deploy(
    organizationMock.target, 
    accountRulesMock.target,
    adminProxyMock.target
    );
    await nodeRules.waitForDeployment(); 

    // console.log("organizationMock.address: ", organizationMock.address);
    // console.log("accountRulesMock.address: ", accountRulesMock.address);
    // console.log("adminProxyMock.address: ", adminProxyMock.address);

    [owner, admin, user] = await ethers.getSigners();

    const roleId = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));
    await accountRulesMock.setRole(admin.address, roleId); // Simula atribuir a role GLOBAL_ADMIN_ROLE
    await accountRulesMock.setAccountActive(admin.address, true); // Simula a conta ativa

  });

  it("should revert if organization contract address is zero", async function () {
    const NodeRulesV2Impl = await ethers.getContractFactory("NodeRulesV2Impl");
    await expect(
      NodeRulesV2Impl.deploy(
        ethers.ZeroAddress, // Address zero para forçar o erro
        accountRulesMock.target,
        adminProxyMock.target
      )
    ).to.be.reverted;
  });

  describe("Constructor", function () {
    it("Should deploy the contract with valid addresses", async function () {
      expect(await nodeRules.accountsContract()).to.equal(accountRulesMock.target);
      expect(await nodeRules.organizationsContract()).to.equal(organizationMock.target);
    });

    it("Should revert with invalid Account address", async function () {
      const NodeRulesV2ImplFactory = await ethers.getContractFactory("NodeRulesV2Impl");
      await expect(
        NodeRulesV2ImplFactory.deploy(organizationMock.target, ethers.ZeroAddress, adminProxyMock.target)
      ).to.be.reverted;
    });
  });

  describe("addLocalNode", function () {
    it("Should allow an active admin to add a local node", async function () {
        
      const accountAddress = admin.address;
      const active = true;
      console.log("Keccak256 Hash:", roleId);

      const tx = await accountRulesMock.createAccount(accountAddress, roleId, active, orgId)

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

      const accountCreatedEvent = parsedLogs.find(e => e.name === "AccountCreated");

      const conn = await nodeRules.connect(admin);
      await expect(
        conn.addLocalNode(
            enodeHighBt32,
            enodeLowBt32,
            1,
            "Test Node"
        )
     ).to.emit(nodeRules, "NodeAdded");

    
        const nodeData = await nodeRules.getNode(enodeHighBt32, enodeLowBt32);
        expect(nodeData.name).to.equal("Test Node");
        expect(nodeData.active).to.equal(true);
       
    });

    it("Should revert if called by a non-admin", async function () {
      await expect(
        nodeRules.connect(user).addLocalNode(enodeHighBt32, enodeLowBt32, 1, "Test Node")
      ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
    });

    it("Should revert if the account is inactive", async function () {
      await accountRulesMock.setRole(admin.address, true);
      await accountRulesMock.setAccountActive(admin.address, false);
      console.log("admin addr: " + admin.address);
      await expect(
        nodeRules.connect(admin).addLocalNode(enodeHighBt32, enodeLowBt32, 1, "Test Node")
      ).to.be.revertedWithCustomError(nodeRules,"InactiveAccount");
    });
   });


    describe("nodes and organization active/inactive", function () {
        it("should return true if node and organization exists and are actives", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            await organizationMock.setOrganizationActive(orgId, true);

            const conn = nodeRules.connect(admin);
            const enodeHighBt32 = ethers.encodeBytes32String("enodeHigh");
            const enodeLowBt32 = ethers.encodeBytes32String("enodeLow");
            const nodeType = 1;
            const nodeName = "Test Node";

            await expect(
                conn.addLocalNode(
                    enodeHighBt32,
                    enodeLowBt32,
                    nodeType,
                    nodeName
                )
            ).to.emit(nodeRules, "NodeAdded");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.true;
        });

        it("should return false if organization is inactive", async function () {

            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            await organizationMock.setOrganizationActive(orgId, false);

            const nodeType = 1;
            const nodeName = "Test Node";
        
            const conn = nodeRules.connect(admin);
            await expect(
                conn.addLocalNode(
                    enodeHighBt32,
                    enodeLowBt32,
                    nodeType,
                    nodeName
                )
            ).to.emit(nodeRules, "NodeAdded");
        
            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;
          });

          it("should return false if node doenst exists", async function () {

            const conn = nodeRules.connect(admin);
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            await organizationMock.setOrganizationActive(orgId, true);
            

            const enodeHighBt32 = ethers.encodeBytes32String("nonexistentHigh");
            const enodeLowBt32 = ethers.encodeBytes32String("nonexistentLow");
        
            const isActive = await conn.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;
          });
    });


    describe("delete nodes", function () {
        it("should delete a local node", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            console.log("add node");
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await expect(
              conn.addLocalNode(
                  enodeHighBt32,
                  enodeLowBt32,
                  1,
                  "Test Node"
            )
            ).to.emit(nodeRules, "NodeAdded");
            console.log("node added");
           
            //deletar o nó recem criado
            await expect(
                conn.deleteLocalNode(
                    enodeHighBt32,
                    enodeLowBt32
                )
            ).to.emit(nodeRules, "NodeDeleted");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;
        });


        it("should delete a node", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await expect(
            conn.addLocalNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node"
            )
            ).to.emit(nodeRules, "NodeAdded");

            
            //deletar o nó recem criado
            await expect(
                conn.deleteLocalNode(
                    enodeHighBt32,
                    enodeLowBt32
                )
            ).to.emit(nodeRules, "NodeDeleted");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;
        });

        it("Should revert if called by a non-admin", async function () {
          await expect(
            nodeRules.connect(user).deleteLocalNode(enodeHighBt32, enodeLowBt32)
          ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
        });
    });


    describe("add/delete node governance", function () {
        it("should add a node", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await adminProxyMock.setAuthorized(accountAddress, true);
            await organizationMock.setOrganizationActive(orgId, true);

            //enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint orgId
            await expect(
            conn.addNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node",
                orgId
            )
            ).to.emit(nodeRules, "NodeAdded");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.true;
        });

        it("Should revert add node if called by a non-admin", async function () {
          await expect(
            nodeRules.connect(user).addNode(enodeHighBt32, enodeLowBt32, 1, "Test Node", orgId)
          ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
        });

        it("should delete a node", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await adminProxyMock.setAuthorized(accountAddress, true);
            await organizationMock.setOrganizationActive(orgId, true);

            //enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name, uint orgId
            await expect(
            conn.addNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node",
                orgId
            )
            ).to.emit(nodeRules, "NodeAdded");


            await expect(
                conn.deleteNode(
                    enodeHighBt32,
                    enodeLowBt32
                )
                ).to.emit(nodeRules, "NodeDeleted");


            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;
        });

        it("Should revert delete node if called by a non-admin", async function () {
          await expect(
            nodeRules.connect(user).deleteNode(enodeHighBt32, enodeLowBt32)
          ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
        });
    });


    describe("update node", function () {
        it("should update a local node", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await adminProxyMock.setAuthorized(accountAddress, true);
            await organizationMock.setOrganizationActive(orgId, true);

            await expect(
            conn.addLocalNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node add"
            )
            ).to.emit(nodeRules, "NodeAdded");

            //enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name
            await expect(
            conn.updateLocalNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node updated"
            )
            ).to.emit(nodeRules, "NodeUpdated");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.true;

            const nodeData = await nodeRules.getNode(enodeHighBt32, enodeLowBt32);
            expect(nodeData.name).to.equal("Test Node updated");

            
        });

        it("Should revert update local node if called by a non-admin", async function () {
          await expect(
            nodeRules.connect(user).updateLocalNode(enodeHighBt32, enodeLowBt32, 1, "Test Node updated")
          ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
        });


        it("should update a local node status", async function () {
            
            const accountAddress = admin.address;
            const active = true;
            
            await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
            const conn = await nodeRules.connect(admin);
            await adminProxyMock.setAuthorized(accountAddress, true);
            await organizationMock.setOrganizationActive(orgId, true);

            await expect(
            conn.addLocalNode(
                enodeHighBt32,
                enodeLowBt32,
                1,
                "Test Node add"
            )
            ).to.emit(nodeRules, "NodeAdded");

            //enodeHigh, bytes32 enodeLow, NodeType nodeType, string calldata name
            await expect(
            conn.updateLocalNodeStatus(
                enodeHighBt32,
                enodeLowBt32,
                false
            )
            ).to.emit(nodeRules, "NodeStatusUpdated");

            const isActive = await nodeRules.isNodeActive(enodeHighBt32, enodeLowBt32);
            expect(isActive).to.be.false;        
        });

        it("Should revert update local node status if called by a non-admin", async function () {
          await expect(
            nodeRules.connect(user).updateLocalNodeStatus(enodeHighBt32, enodeLowBt32, false)
          ).to.be.revertedWithCustomError(nodeRules,"UnauthorizedAccess");
        });

    });


  //   describe("connection allowed", function () {
  //     it("should return connection_allowed", async function () {
          
  //         const accountAddress = admin.address;
  //         const active = true;
          
  //         await accountRulesMock.createAccount(accountAddress, roleId, active, orgId);
  //         const conn = await nodeRules.connect(admin);
  //         await adminProxyMock.setAuthorized(accountAddress, true);
  //         await organizationMock.setOrganizationActive(orgId, true);

  //         const sourceEnodeHighBt32 = ethers.encodeBytes32String("sourceEnodeHigh");
  //         const sourceEnodeLowBt32 = ethers.encodeBytes32String("sourceEnodeLow");
  //         await expect(
  //         conn.addLocalNode(
  //             enodeHighBt32,
  //             enodeLowBt32,
  //             1,
  //             "Test Node source"
  //         )
  //         ).to.emit(nodeRules, "NodeAdded");


  //         const destinationEnodeHighBt32 = ethers.encodeBytes32String("destinationEnodeHigh");
  //         const destinationEnodeLowBt32 = ethers.encodeBytes32String("destinationEnodeLow");
  //         await expect(
  //           conn.addLocalNode(
  //               destinationEnodeHighBt32,
  //               destinationEnodeLowBt32,
  //               1,
  //               "Test Node destination"
  //           )
  //           ).to.emit(nodeRules, "NodeAdded");

  //         const connection = await 
  //         conn.connectionAllowed(
  //             sourceEnodeHighBt32,
  //             sourceEnodeLowBt32,
  //             ethers.utils.hexlify(ethers.utils.randomBytes(16)),
  //             0,                       
  //             destinationEnodeHighBt32,
  //             destinationEnodeLowBt32,
  //             ethers.utils.hexlify(ethers.utils.randomBytes(16)),
  //             0  
  //         );

  //         expect(connection).to.equal(CONNECTION_ALLOWED); 
  //     });

  // });
    

});