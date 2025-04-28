const { expect } = require("chai");
const { ethers } = require("hardhat");
const { keccak256, toUtf8Bytes,  Wallet, hexlify, randomBytes, ZeroAddress } = require("ethers");
const { BigNumber } = require("@ethersproject/bignumber");


describe("AccountRulesV2Impl", function () {
    let AccountRulesV2Impl, accountRules;
    let organizationMock, adminProxyMock;
    let owner, admin, account1, account2;

    const roleIdGlobal = keccak256(toUtf8Bytes("GLOBAL_ADMIN_ROLE"));
    const roleIdLocal = keccak256(toUtf8Bytes("LOCAL_ADMIN_ROLE"));
    const roleIdUser = keccak256(toUtf8Bytes("USER_ROLE"));
    const roleIdDeployer = keccak256(toUtf8Bytes("DEPLOYER_ROLE"));
    const dataHash = keccak256(toUtf8Bytes("DATAHASH"));

    beforeEach(async function () {
        // Mock dos contratos Organization e AdminProxy
        const OrganizationMockFactory = await ethers.getContractFactory("OrganizationMock");
        organizationMock = await OrganizationMockFactory.deploy();
        await organizationMock.waitForDeployment();

        await organizationMock.setOrganizationActive(1, true);
        await organizationMock.setOrganizationActive(2, true);
        await organizationMock.setOrganizationActive(3, false);

        const AdminProxyMockFactory = await ethers.getContractFactory("AdminProxyMock");
        adminProxyMock = await AdminProxyMockFactory.deploy();
        await adminProxyMock.waitForDeployment(); 

        [admin, owner, account1, account2] = await ethers.getSigners();
        const initialAccounts = [owner.address, admin.address];

        const AccountRulesV2Impl = await ethers.getContractFactory("AccountRulesV2Impl");
        accountRules = await AccountRulesV2Impl.deploy(
        organizationMock.target, 
        initialAccounts,
        adminProxyMock.target
        );
        await accountRules.waitForDeployment(); 

        //console.log("organizationMock.address: ", organizationMock.address);
        //console.log("adminProxyMock.address: ", adminProxyMock.address);

    });

    // it("should revert if Organization address is zero", async function () {
    //     const AccountRulesV2Impl = await ethers.getContractFactory("AccountRulesV2Impl");
    //     await expect(
    //         AccountRulesV2Impl.deploy(ZeroAddress, [], adminProxyMock.address)
    //     ).to.be.revertedWith("Invalid address for Organization management smart contract");
    // });

    describe("add account local/global", function () {
        it("should add a local account successfully", async function () {

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;

            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdLocal, 
                    dataHash
                )
              ).to.emit(accountRules, "AccountAdded");

    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
        });
        
        it("should add a account successfully", async function () {

            console.log("should add a account successfully");
            await adminProxyMock.setAuthorized(admin.address, true); 
            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            await expect(
                conn.addAccount(
                    newAccount, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);
        });

        it("should not add a account because its unauthorized", async function () {

            await adminProxyMock.setAuthorized(admin.address, false); 
            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;

            await expect(
                conn.addAccount(
                    newAccount, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.be.revertedWithCustomError(accountRules,"UnauthorizedAccess");

        });

        it("should not add a account because its address is invalid", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 
            const conn = await accountRules.connect(admin);

            await expect(
                conn.addAccount(
                    ZeroAddress, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidAccount");

        });

        it("should not add a account because roleIdIsInvalid", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 
            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
            const roleIdIsInvalid = keccak256(toUtf8Bytes("INVALID_ROLE"));

            await expect(
                conn.addAccount(
                    newAccount, 
                    1,
                    roleIdIsInvalid, 
                    dataHash
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidRole");

        });

        it("should not add a account because hash is invalid", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 
            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;

            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdUser, 
                    ethers.ZeroHash
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidHash");

        });
    });

    describe("remove account local/global", function () {
        it("should remove a local account successfully", async function () {

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro adiciona a conta
            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdUser, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdUser);
            expect(accountData.dataHash).to.equal(dataHash);
    
            //remove a conta
            await expect(
                conn.deleteLocalAccount(
                    newAccount 
                )
            ).to.emit(accountRules, "AccountDeleted");
    
            //verifica se removeu msmo, pq se removeu então acontece um revert
            await expect(
                accountRules.getAccount(newAccount)
            ).to.be.revertedWithCustomError(accountRules,"AccountNotFound");
           
        });


        it("should delete a account successfully", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
            const newAccount2 = account2.address;
    
            //primeiro add uma conta
            await expect(
                conn.addAccount(
                    newAccount, 
                    1,
                    roleIdGlobal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdGlobal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);


            //depois add outra conta
            await expect(
                conn.addAccount(
                    newAccount2, 
                    1,
                    roleIdGlobal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");

            const accountData2 = await accountRules.getAccount(newAccount2);
            expect(accountData2.account).to.equal(newAccount2);
            expect(accountData2.roleId).to.equal(roleIdGlobal);
            expect(accountData2.dataHash).to.equal(dataHash);
            expect(accountData2.orgId).to.equal(1);


            // remover uma das contas, visto que as duas não é possível, precisa haver ao menos 1 adm global
            await expect(
                conn.deleteAccount(
                    newAccount, 
                )
            ).to.emit(accountRules, "AccountDeleted");
 
            //verifica se removeu msmo, pq se removeu então acontece um revert
            await expect(
                accountRules.getAccount(newAccount)
            ).to.be.revertedWithCustomError(accountRules,"AccountNotFound");
           
        });

        it("should delete a account and decrement a global admin", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
            const newAccount2 = account2.address;
    
            //primeiro add uma conta
            await expect(
                conn.addAccount(
                    newAccount, 
                    1,
                    roleIdGlobal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdGlobal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);


            //depois add outra conta
            await expect(
                conn.addAccount(
                    newAccount2, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");

            const accountData2 = await accountRules.getAccount(newAccount2);
            expect(accountData2.account).to.equal(newAccount2);
            expect(accountData2.roleId).to.equal(roleIdLocal);
            expect(accountData2.dataHash).to.equal(dataHash);
            expect(accountData2.orgId).to.equal(1);


            // remover uma das contas, visto que as duas não é possível, precisa haver ao menos 1 adm global
            await expect(
                conn.deleteAccount(
                    newAccount, 
                )
            ).to.emit(accountRules, "AccountDeleted");
 
            //verifica se removeu msmo, pq se removeu então acontece um revert
            await expect(accountRules.getAccount(newAccount))
            .to.be.revertedWithCustomError(accountRules,"AccountNotFound");
           
        });


        it("should not delete a account because its doenst exists", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account2.address;
    
            //primeiro add uma conta
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);

            await expect(
                conn.deleteAccount(
                newAccount, 
            )).to.be.revertedWithCustomError(accountRules,"IllegalState");
           
        });

        it("should not delete a account because its doesnt exists", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;

            await expect(
                conn.deleteAccount(
                newAccount, 
            )).to.be.revertedWithCustomError(accountRules,"AccountNotFound");
           
        });

    });


    describe("update account", function () {
       it("should update a local account successfully", async function () {

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro adiciona a conta
            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdUser, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdUser);
            expect(accountData.dataHash).to.equal(dataHash);
    
            //atualiza a conta
            await expect(
                conn.updateLocalAccount(
                    newAccount, 
                    roleIdLocal,
                    dataHash
                )
            ).to.emit(accountRules, "AccountUpdated");
    
            const accountDataUpdated = await accountRules.getAccount(newAccount);
            expect(accountDataUpdated.account).to.equal(newAccount);
            expect(accountDataUpdated.roleId).to.equal(roleIdLocal);
            expect(accountDataUpdated.dataHash).to.equal(dataHash);
           
        });

        it("should not update a local account because datahash is invalid", async function () {

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
                
            //primeiro adiciona a conta
            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdUser, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdUser);
            expect(accountData.dataHash).to.equal(dataHash);
            
            //atualiza a conta
            await expect(
                conn.updateLocalAccount(
                    newAccount, 
                    roleIdUser,
                    ethers.ZeroHash
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidHash");
    
        });
    
        it("should update a local account status", async function () {
    
            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro adiciona a conta
            await expect(
                conn.addLocalAccount(
                    newAccount, 
                    roleIdUser, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.active).to.be.true;
    
            //atualiza a conta para inativa
            await expect(
                conn.updateLocalAccountStatus(
                    newAccount, 
                    false
                )
            ).to.emit(accountRules, "AccountStatusUpdated");
    
            const accountDataUpdated = await accountRules.getAccount(newAccount);
            expect(accountDataUpdated.active).to.be.false;
           
        });
    });

    describe("set access", function () {
        it("should not set account target access because allowedtarget is empty", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 1
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            
            const restricted = true;
            const allowedTargets = [];
        
            await expect(
                conn.setAccountTargetAccess(
                    newAccount, 
                    restricted, 
                    allowedTargets
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidArgument");
    
           
        });

        it("should set account target access successfully", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 2
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            const restricted = true;

            const allowedTargets = [
                account2.address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address
            ];
        
            await expect(
                conn.setAccountTargetAccess(
                    newAccount, 
                    restricted, 
                    allowedTargets
                )
            ).to.emit(accountRules, "AccountTargetAccessUpdated");
    
        });
    
        it("should set account target access successfully without restriction", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 2
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            // adiciona restrição
            console.log("com restrição");
            let restricted = true;

            const allowedTargets = [
                account2.address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address
            ];
        
            await expect(
                conn.setAccountTargetAccess(
                    newAccount, 
                    restricted, 
                    allowedTargets
                )
            ).to.emit(accountRules, "AccountTargetAccessUpdated");

            // sem restrição
            console.log("sem restrição");
            restricted = false;

            await expect(
                conn.setAccountTargetAccess(
                    newAccount, 
                    restricted, 
                    []
                )
            ).to.emit(accountRules, "AccountTargetAccessUpdated");
    
        });


        it("should set smart contract access successfully", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 2
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            const restricted = true;

            const smartContractAddr = ethers.Wallet.createRandom().address;

            const allowedSenders = [
                account2.address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address
            ];
        
            await expect(
                conn.setSmartContractSenderAccess(
                    smartContractAddr, 
                    restricted, 
                    allowedSenders
                )
            ).to.emit(accountRules, "SmartContractSenderAccessUpdated");
    
        });

        it("should not set smart contract access because the address of smart contract is invalid", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 2
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            const restricted = true;

            const smartContractAddr = ZeroAddress;

            const allowedSenders = [
                account2.address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address
            ];
        
            await expect(
                conn.setSmartContractSenderAccess(
                    smartContractAddr, 
                    restricted, 
                    allowedSenders
                )
            ).to.be.revertedWithCustomError(accountRules,"InvalidAccount");
    
        });


        it("should set smart contract access successufuly without restriction", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const newAccount = account1.address;
    
            //primeiro add uma conta na organização 2
            await expect(
                conn.addAccount(
                    newAccount, 
                    2,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
            
            const accountData = await accountRules.getAccount(newAccount);
            expect(accountData.account).to.equal(newAccount);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(2);

            //com restrição
            let restricted = true;

            const smartContractAddr = ethers.Wallet.createRandom().address;

            const allowedSenders = [
                account2.address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address,
                ethers.Wallet.createRandom().address
            ];
        
            await expect(
                conn.setSmartContractSenderAccess(
                    smartContractAddr, 
                    restricted, 
                    allowedSenders
                )
            ).to.emit(accountRules, "SmartContractSenderAccessUpdated");

            //sem restrição
            restricted = false;
        
            await expect(
                conn.setSmartContractSenderAccess(
                    smartContractAddr, 
                    restricted, 
                    allowedSenders
                )
            ).to.emit(accountRules, "SmartContractSenderAccessUpdated");
    
        });
    });

    describe("transaction", function () {
        it("should not transact because account inst active", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;
            const account2Addr = account2.address;

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                account2Addr,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.false;
        });


        it("should transact", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;
            const account2Addr = account2.address;

            //primeiro cadastrar a conta (ativar ela)
            await expect(
                conn.addAccount(
                    account1Addr, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(account1Addr);
            expect(accountData.account).to.equal(account1Addr);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                account2Addr,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.true;
        });



        it("should not transact because target address is zero and the role of sender isnt deployer, local or global", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;

            //primeiro cadastrar a conta (ativar ela)
            await expect(
                conn.addAccount(
                    account1Addr, 
                    1,
                    roleIdUser, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(account1Addr);
            expect(accountData.account).to.equal(account1Addr);
            expect(accountData.roleId).to.equal(roleIdUser);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                ZeroAddress,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.false;
        });

        it("should transact because target address is zero but the role of sender is local", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;

            //primeiro cadastrar a conta (ativar ela)
            await expect(
                conn.addAccount(
                    account1Addr, 
                    1,
                    roleIdLocal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(account1Addr);
            expect(accountData.account).to.equal(account1Addr);
            expect(accountData.roleId).to.equal(roleIdLocal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                ZeroAddress,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.true;
        });

        it("should transact because target address is zero but the role of sender is global", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;

            //primeiro cadastrar a conta (ativar ela)
            await expect(
                conn.addAccount(
                    account1Addr, 
                    1,
                    roleIdGlobal, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(account1Addr);
            expect(accountData.account).to.equal(account1Addr);
            expect(accountData.roleId).to.equal(roleIdGlobal);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                ZeroAddress,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.true;
        });

        it("should transact because target address is zero but the role of sender is deployer", async function () {

            await adminProxyMock.setAuthorized(admin.address, true); 

            const conn = await accountRules.connect(admin);
            const account1Addr = account1.address;

            //primeiro cadastrar a conta (ativar ela)
            await expect(
                conn.addAccount(
                    account1Addr, 
                    1,
                    roleIdDeployer, 
                    dataHash
                )
            ).to.emit(accountRules, "AccountAdded");
    
            const accountData = await accountRules.getAccount(account1Addr);
            expect(accountData.account).to.equal(account1Addr);
            expect(accountData.roleId).to.equal(roleIdDeployer);
            expect(accountData.dataHash).to.equal(dataHash);
            expect(accountData.orgId).to.equal(1);

            const resultOfTransaction = await conn.transactionAllowed(
                account1Addr, 
                ZeroAddress,
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`), 
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                BigInt(`0x${Buffer.from(randomBytes(32)).toString("hex")}`),
                randomBytes(32)
            );
            
            expect(resultOfTransaction).to.true;
        });
    });
  
});