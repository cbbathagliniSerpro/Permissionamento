const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, transactionAllowed } = require('./util.js');

async function testGlobalAdmins(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Testando acesso de contas da Administradores Globais - transactionAllowed()');

    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const globalAdmins = getParameter(parameters, 'globalAdmins');
    await transactionAllowed(accountRulesV2Address, globalAdmins);
}

const parameters = getParameters();
testGlobalAdmins(parameters);