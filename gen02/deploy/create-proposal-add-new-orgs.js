const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getOrgType } = require('./util.js');
const { STATUS_ACTIVE, RESULT_UNDEFINED } = require('./constants.js');
        
const BLOCKS_DURATION = 30000;
const PROPOSAL_DESCRIPTION = 'Adicionar novas organizações';

async function createProposal(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Criando proposta de governança para adicionar novas organizações (SEM administrador global e SEM direito a voto):');

    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);
    const organizationAddress = getParameter(parameters, 'organizationAddress');
    const organizationContract = await hre.ethers.getContractAt('OrganizationImpl', organizationAddress);
    const newOrganizations = getParameter(parameters, 'newOrganizations');
    for(const org of newOrganizations) {
        console.log(` - ${org}`);
    }
    
    console.log('Chamadas configuradas para a proposta');
    let targets = [];
    let calldatas = [];
    for(const newOrg of newOrganizations) {
        const calldata = organizationContract.interface.encodeFunctionData(organizationContract.addOrganization.fragment, [newOrg.cnpj, newOrg.name, getOrgType(newOrg.orgType), false]);
        targets.push(organizationAddress);
        calldatas.push(calldata);
        console.log(` - ${organizationAddress}: ${calldata}`);
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