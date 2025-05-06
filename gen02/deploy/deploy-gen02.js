const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, getOrgType } = require('./util.js');
const { GLOBAL_ADMIN_ROLE, ADMIN_ABI, ZEROED_BYTES_32 } = require('./constants.js');

async function deployGen02(parameters) {
    await diagnostics();
    
    console.log('--------------------------------------------------');
    console.log('Implantando gen02');
    
    const adminAddress = getParameter(parameters, 'adminAddress');
    const organizations = getParameter(parameters, 'organizations');
    const globalAdmins = getParameter(parameters, 'globalAdmins');

    assert.equal(organizations.length, globalAdmins.length, `Listas de organizações e contas de administradores globais não têm o mesmo tamanho: ${organizations.length} != ${globalAdmins.length}`);

    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);

    console.log('Implantando smart contract de gestão de organizações');
    organizations.forEach(o => o.orgType = getOrgType(o.orgType));
    const organizationsContract = await hre.ethers.deployContract('OrganizationImpl', [organizations, adminContract]);
    await organizationsContract.waitForDeployment();
    // Verificações
    assert.equal(await organizationsContract.idSeed(), organizations.length);
    for(let i = 0; i < organizations.length; ++i) {
        const org = await organizationsContract.getOrganization(i+1);
        assert.equal(org.cnpj, organizations[i].cnpj);
        assert.equal(org.name, organizations[i].name);
        assert.equal(org.orgType, organizations[i].orgType);
        assert.equal(org.canVote, organizations[i].canVote);
        assert.ok(await organizationsContract.isOrganizationActive(i+1));
    }
    console.log(` OrganizationImpl implantado no endereço ${organizationsContract.target}`);

    console.log('Implantando smart contract de gestão de contas');
    const accountsContract = await hre.ethers.deployContract('AccountRulesV2Impl', [organizationsContract, globalAdmins, adminContract]);
    await accountsContract.waitForDeployment();
    // Verificações
    for(let i = 0; i < globalAdmins.length; ++i) {
        const acc = await accountsContract.getAccount(globalAdmins[i]);
        assert.equal(acc.orgId, i+1);
        assert.equal(acc.roleId, GLOBAL_ADMIN_ROLE);
        assert.ok(await accountsContract.isAccountActive(globalAdmins[i]));
    }
    console.log(` AccountRulesV2Impl implantado no endereço ${accountsContract.target}`);

    console.log('Implantando smart contract de gestão de nós');
    const nodesContract = await hre.ethers.deployContract('NodeRulesV2Impl', [organizationsContract, accountsContract, adminContract]);
    await nodesContract.waitForDeployment();
    assert.ok(!await nodesContract.isNodeActive(ZEROED_BYTES_32, ZEROED_BYTES_32));
    console.log(` NodeRulesV2Impl implantado no endereço ${nodesContract.target}`);

    console.log('Implantando smart contract de governança');
    const governanceContract = await hre.ethers.deployContract('Governance', [organizationsContract, accountsContract, adminContract]);
    await governanceContract.waitForDeployment();
    // Verificações
    assert.equal(await governanceContract.idSeed(), 0);
    console.log(` Governance implantado no endereço ${governanceContract.target}`);
    
    console.log('Adicionando smart contract de governança como admin master');
    const addAdminResp = await adminContract.addAdmin(governanceContract);
    await addAdminResp.wait();
    // Verificações
    assert.ok(await adminContract.isAuthorized(governanceContract));
    console.log(' Governance adicionado como admin\n');
}

const parameters = getParameters();
deployGen02(parameters);
