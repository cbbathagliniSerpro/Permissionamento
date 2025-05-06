const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation } = require('./util.js');
const { ADD_ACCOUNT_FUNC, GLOBAL_ADMIN_ROLE, ZEROED_BYTES_32, STATUS_ACTIVE, RESULT_UNDEFINED } = require('./constants.js');
        
const BLOCKS_DURATION = 30000;
const PROPOSAL_DESCRIPTION = 'Adicionar novos administradores globais';

async function createProposal(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Criando proposta de governança para adicionar novos administradores globais:');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const newGlobalAdmins = getParameter(parameters, 'newGlobalAdmins');

    for(const admin of newGlobalAdmins) {
        console.log(` - Administrador ${admin.account} será adicionado à organização ${admin.orgId}`);
    }
    
    console.log('Chamadas configuradas para a proposta');
    let targets = [];
    let calldatas = [];
    for(const admin of newGlobalAdmins) {
        const calldata = accountsContract.interface.encodeFunctionData(ADD_ACCOUNT_FUNC, [admin.account, admin.orgId, GLOBAL_ADMIN_ROLE, ZEROED_BYTES_32]);
        targets.push(accountRulesV2Address);
        calldatas.push(calldata);
        console.log(` - ${accountRulesV2Address}: ${calldata}`);
    }
    console.log();

    const confirmed = await askConfirmation('Confirma criação de proposta (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }
    
    const resp = await governanceContract.createProposal(targets, calldatas, BLOCKS_DURATION, PROPOSAL_DESCRIPTION);
    await resp.wait();
    const idProposal = await governanceContract.idSeed();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.description, PROPOSAL_DESCRIPTION);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_UNDEFINED);
    console.log(`Proposta ${idProposal} criada.`);
}

const parameters = getParameters();
createProposal(parameters);