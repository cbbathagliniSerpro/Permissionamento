const hre = require('hardhat');
const assert = require('assert');
const { diagnostics } = require('./util.js');

async function deployAdminMock() {
    await diagnostics();
    
    console.log('--------------------------------------------------');
    console.log('Implantando AdminMock');
    const adminMockContract = await hre.ethers.deployContract('AdminMock');
    await adminMockContract.waitForDeployment();
    console.log(` AdminMock implantado no endereço ${adminMockContract.target}`);

    const accs = await hre.ethers.getSigners();
    const defaultAdminAccount = accs[0].address;
    console.log(`Acrescentando conta ${defaultAdminAccount} como admin`);
    const resp = await adminMockContract.addAdmin(defaultAdminAccount);
    await resp.wait();
    // Verificando
    let isAdmin = await adminMockContract.isAuthorized(defaultAdminAccount);
    assert.ok(isAdmin);
    console.log(' Conta adicionanda como admin\n');
}

deployAdminMock();
