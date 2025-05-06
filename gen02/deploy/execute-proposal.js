const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getProposalStatus, getProposalResult } = require('./util.js');
const { STATUS_ACTIVE, STATUS_EXECUTED, RESULT_APPROVED } = require('./constants.js');

async function executeProposal(parameters) {
    await diagnostics();

    const proposal = getParameter(parameters, 'proposal');
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    const proposalBefore = await governanceContract.getProposal(proposal.id);

    assert.equal(proposalBefore.status, STATUS_ACTIVE, `Proposta ${proposal.id} não está ativa! Status: ${proposalBefore.status}`);
    assert.equal(proposalBefore.result, RESULT_APPROVED, `Proposta ${proposal.id} não está Aprovada! Result: ${proposalBefore.result}`);

    console.log('--------------------------------------------------');
    console.log(`Executando proposta ${proposalBefore.id} - ${proposalBefore.description} (Status: ${getProposalStatus(proposalBefore.status)})(Resultado: ${getProposalResult(proposalBefore.result)})`);

    const confirmed = await askConfirmation('Confirma execução da proposta (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }
    
    const resp = await governanceContract.executeProposal(proposal.id);
    await resp.wait();
    const proposalAfter = await governanceContract.getProposal(proposal.id);
    console.log('Proposta executada.');
    console.log(`Nova situação da proposta: ${getProposalStatus(proposalAfter.status)}`);
    // Verificações
    assert.equal(proposalAfter.status, STATUS_EXECUTED, 'Algo errado: status da proposta não indica que a execução foi realizada.');
}

const parameters = getParameters();
executeProposal(parameters);