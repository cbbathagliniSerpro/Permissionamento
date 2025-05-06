const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation } = require('./util.js');
const { ADMIN_ABI, INGRESS_ABI, RULES_CONTRACT, NODE_INGRESS_ADDRESS, ACCOUNT_INGRESS_ADDRESS } = require('./constants.js');

async function migrate(ingressAddress) {
    const ingressContract = await hre.ethers.getContractAt(INGRESS_ABI, ingressAddress);
    const resp = await ingressContract.setContractAddress(RULES_CONTRACT, '0x0000000000000000000000000000000000000001');
    await resp.wait();
}

async function verifyGovernance(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Verificando se apenas o smart contract de governança é administrador master.');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    const allAdmins = await adminContract.getAdmins();

    assert.equal(allAdmins.length, 1, `Há mais de um administrador master: ${allAdmins}`);
    assert.equal(allAdmins[0], governanceAddress, `Administrador master configurado não é o smart contract de governança: ${allAdmins[0]}`);

    console.log(` Smart contract de governança ${governanceAddress} corretamente configurado como único administrador master.`);
    console.log();
    
    console.log('--------------------------------------------------');
    console.log('Tentando realizar reponteiramentos');
    console.log();
    console.log('>>>>> ATENÇÃO <<<<<');
    console.log();
    console.log('Os testes a seguir tentam enviar transações para a blockchain para realizar o reponteiramento do permissionamento.');
    console.log('O objetivo destes testes é demonstrar que uma conta qualquer, que não seja o smart contract de governança, não consegue realizar o reponteiramento.');
    console.log('É esperado que o reponteiramento seja impedido e não ocorra.');
    console.log();
    console.log('Porém, caso o reponteiramento ocorra, isso causará prejuízos à operação da rede.');
    console.log();
    
    const confirmed = await askConfirmation('Deseja continuar os testes (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }
    
    try {
        await migrate(NODE_INGRESS_ADDRESS);
        assert.fail('Opa! Conseguir reponteirar o NodeIngress!');
    }
    catch(error) {
        console.log(` - NodeIngress não pôde ser reponteirado, corretamente: ${error.message}`);
        console.log('   Tudo certo!');
    }
    try {
        await migrate(ACCOUNT_INGRESS_ADDRESS);
        assert.fail('Opa! Conseguir reponteirar o AccountIngress!');
    }
    catch(error) {
        console.log(` - AccountIngress não pôde ser reponteirado, corretamente: ${error.message}`);
        console.log('   Tudo certo!');
    }
}

const parameters = getParameters();
verifyGovernance(parameters);