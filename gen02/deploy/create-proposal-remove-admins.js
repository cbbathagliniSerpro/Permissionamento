const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation } = require('./util.js');
const { REMOVE_ADMIN_FUNC, STATUS_ACTIVE, RESULT_UNDEFINED, ADMIN_ABI } = require('./constants.js');
        
const BLOCKS_DURATION = 30000;
const PROPOSAL_DESCRIPTION = 'Manter apenas a Governança como administrador master (remoção dos demais admins)';

async function createProposal(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Criando proposta de governança para remover administradores master:');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    
    const allAdmins = await adminContract.getAdmins();
    const governanceAdmin = allAdmins.filter(a => a == governanceAddress);
    const adminsToRemove = allAdmins.filter(a => a != governanceAddress);

    assert.ok(governanceAdmin.length > 0, 'Smart contract de Governança não está cadastrado como admin!');
    assert.ok(adminsToRemove.length > 0, 'Não há administradores master para remover.');
    
    for(const admin of adminsToRemove) {
        console.log(` - ${admin}`);
    }
    console.log();
    
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);
    
    console.log('Chamadas configuradas para a proposta');
    let targets = [];
    let calldatas = [];
    for(const admin of adminsToRemove) {
        const calldata = adminContract.interface.encodeFunctionData(REMOVE_ADMIN_FUNC, [admin]);
        targets.push(adminAddress);
        calldatas.push(calldata);
        console.log(` - ${adminAddress}: ${calldata}`);
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