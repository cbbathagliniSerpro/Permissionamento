const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, executeProposal, approveProposal } = require('./util.js');
const { BOOT_TYPE, REVERTED, GLOBAL_ADMIN_ROLE, ADMIN_ABI, ADD_ADMIN_FUNC, REMOVE_ADMIN_FUNC,
        STATUS_ACTIVE, RESULT_UNDEFINED } = require('./constants.js');

async function removeGovernanceAsAdmin(newGovernanceMockContract, adminContract, governanceAddress, adminAddress) {
    console.log('--------------------------------------------------');
    console.log('Removendo governança "antiga" como admin master');
    const calldata = adminContract.interface.encodeFunctionData(REMOVE_ADMIN_FUNC, [governanceAddress]);
    const resp = await newGovernanceMockContract.executeAnything(adminAddress, calldata);
    await resp.wait();
    console.log(` - ${governanceAddress} removido como admin master`);
    console.log();
}

async function getGlobalAdminAccounts(accountRulesV2Contract) {
    console.log('--------------------------------------------------');
    console.log('Obtendo contas de administradores globais');

    const numOfAccounts = await accountRulesV2Contract.getNumberOfAccounts();
    const allAccounts = await accountRulesV2Contract.getAccounts(1, numOfAccounts);
    const activeAccounts = allAccounts.filter(a => a[4]);
    const activeAdmins = activeAccounts.filter(a => a[2] == GLOBAL_ADMIN_ROLE);
    const adminsAddresses = activeAdmins.map(a => a[1]);
    
    console.log(` - ${adminsAddresses.length} admins ativos`);
    console.log();
    return adminsAddresses;
}

async function createProposalNewGovernanceMockMigration(governanceContract, adminContract, adminAddress, newGovernanceMockAddress) {
    console.log('--------------------------------------------------');
    console.log('Criando proposta para adicionar NewGovernanceMock como admin master');
    
    let targets = [adminAddress];
    let calldatas = [adminContract.interface.encodeFunctionData(ADD_ADMIN_FUNC, [newGovernanceMockAddress])]
    const resp = await governanceContract.createProposal(targets, calldatas, 1000, 'Adição do NewGovernanceMock como admin master');
    await resp.wait();
    const idProposal = await governanceContract.idSeed();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_UNDEFINED);
    console.log(` Proposta ${idProposal} criada.`);

    console.log();
    return idProposal;
}

async function deployNewGovernanceMock() {
    console.log('--------------------------------------------------');
    console.log('Implantando NewGovernanceMock');
    const newGovernanceMockContract = await hre.ethers.deployContract('NewGovernanceMock');
    await newGovernanceMockContract.waitForDeployment();
    console.log(` NewGovernanceMock implantado no endereço ${newGovernanceMockContract.target}`);
    console.log();
    return newGovernanceMockContract;
}

async function verifyGovernanceAccess(nodeRulesV2Contract, accountRulesV2Contract) {
    console.log('--------------------------------------------------');
    console.log('Verificando se funções restritas à governança estão realmente inacessíveis');
    
    try {
        const resp = await nodeRulesV2Contract.addNode(
            '0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7',
            '0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646',
            BOOT_TYPE,
            'boot01',
            1
        );
        await resp.wait();
        assert.fail('Opa! Conseguir chamar addNode()!');
    }
    catch(error) {
        assert.ok(error.message.includes(REVERTED));
        console.log(' - Acesso ao NodeRulesV2 está controlado. Tudo certo!');
    }
    
    try {
        const resp = await accountRulesV2Contract.addAccount(
            '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199',
            1,
            GLOBAL_ADMIN_ROLE,
            '0x0000000000000000000000000000000000000000000000000000000000000004'
        );
        await resp.wait();
        assert.fail('Opa! Conseguir chamar addAccount()!');
    }
    catch(error) {
        assert.ok(error.message.includes(REVERTED));
        console.log(' - Acesso ao AccountRulesV2 está controlado. Tudo certo!');
    }
    
    console.log();
}

async function verifyAdminMaster(adminContract, verifications) {
    console.log('--------------------------------------------------');
    console.log('Verificando admins master');
    
    for(const verification of verifications) {
        const admin = verification[0];
        const excpectedAuthorized = verification[1];
        const authorized = await adminContract.isAuthorized(admin);
        assert.equal(authorized, excpectedAuthorized, `Conta ${admin} está com autorização ${authorized} mas deveria estar ${excpectedAuthorized}`);
        console.log(` - ${admin}: ${authorized} [OK]`);
    }

    console.log();
}

async function migrateToGovernanceMock(parameters) {
    await diagnostics();
    
    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');
    const nodeRulesV2Contract = await hre.ethers.getContractAt('NodeRulesV2Impl', nodeRulesV2Address);
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountRulesV2Contract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    await verifyAdminMaster(adminContract, [ [governanceAddress, true] ]);
    await verifyGovernanceAccess(nodeRulesV2Contract, accountRulesV2Contract);
    const newGovernanceMockContract = await deployNewGovernanceMock();
    const newGovernanceMockAddress = await newGovernanceMockContract.getAddress();
    const idProposal = await createProposalNewGovernanceMockMigration(governanceContract, adminContract, adminAddress, newGovernanceMockAddress);
    const globalAdmins = await getGlobalAdminAccounts(accountRulesV2Contract);
    await approveProposal(governanceContract, idProposal, globalAdmins);
    await executeProposal(governanceContract, idProposal);
    await verifyAdminMaster(adminContract, [ [governanceAddress, true], [newGovernanceMockAddress, true] ]);
    await removeGovernanceAsAdmin(newGovernanceMockContract, adminContract, governanceAddress, adminAddress);
    await verifyAdminMaster(adminContract, [ [governanceAddress, false], [newGovernanceMockAddress, true] ]);
    await verifyGovernanceAccess(nodeRulesV2Contract, accountRulesV2Contract);
}

const parameters = getParameters();
migrateToGovernanceMock(parameters);