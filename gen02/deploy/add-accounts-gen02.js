const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getDefaultSigner, getRoleId } = require('./util.js');
const { STATUS_ACTIVE } = require('./constants.js');

async function addAccounts(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Adicionando contas locais');

    const organizationAddress = getParameter(parameters, 'organizationAddress');
    const organizationContract = await hre.ethers.getContractAt('OrganizationImpl', organizationAddress);
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);

    const signer = await getDefaultSigner();
    const sender = await accountsContract.getAccount(signer.address);
    const org = await organizationContract.getOrganization(sender.orgId);
    
    console.log(`As contas serão adicionadas à organização "${org.name}"`);

    const confirmed = await askConfirmation('Confirma permissionamento de contas (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }

    const accounts = getParameter(parameters, 'accounts');
    for(acc of accounts) {
        try {
            const resp = await accountsContract.addLocalAccount(acc.account, getRoleId(acc.role), acc.dataHash);
            await resp.wait();
            // Verificações
            const newAcc = await accountsContract.getAccount(acc.account);
            assert.equal(newAcc[0], org.id);
            assert.equal(newAcc[2], getRoleId(acc.role));
            assert.equal(newAcc[3], acc.dataHash);
            assert.equal(newAcc[4], true);
            console.log(` - Conta adicionada: ${acc.account} - ${acc.role} [${acc.dataHash}]`);
        }
        catch(error) {
            console.log(` - Erro na adição da conta ${acc.account}: ${error.message}`);
        }
    }
}

const parameters = getParameters();
addAccounts(parameters);