const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, transactionAllowed } = require('./util.js');

async function testAccounts(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Testando acesso de contas - transactionAllowed()');

    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accounts = getParameter(parameters, 'accounts').map(a => a.account);
    await transactionAllowed(accountRulesV2Address, accounts);
}

const parameters = getParameters();
testAccounts(parameters);