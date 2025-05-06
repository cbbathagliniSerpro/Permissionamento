const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getVote, getProposalStatus, getProposalResult } = require('./util.js');
const { STATUS_ACTIVE } = require('./constants.js');

function getVotes(votes) {
    return votes.map(v => getVote(v));
}

async function castVote(parameters) {
    await diagnostics();

    const proposal = getParameter(parameters, 'proposal');
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    const proposalBefore = await governanceContract.getProposal(proposal.id);
    const votesBefore = getVotes(proposalBefore[10]);

    assert.equal(proposalBefore.status, STATUS_ACTIVE, `Proposta ${proposal.id} não está ativa! Status: ${proposalBefore.status}`);

    console.log('--------------------------------------------------');
    console.log(`Enviando voto "${proposal.vote}" para proposta ${proposalBefore.id} - ${proposalBefore.description} (Situação: ${getProposalStatus(proposalBefore.status)})(Resultado: ${getProposalResult(proposalBefore.result)})`);

    const confirmed = await askConfirmation('Confirma envio do voto (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }
    
    const resp = await governanceContract.castVote(proposal.id, proposal.vote);
    await resp.wait();
    const proposalAfter = await governanceContract.getProposal(proposal.id);
    const votesAfter = getVotes(proposalAfter[10]);
    console.log('Voto eviado.');
    console.log(`Votação antes do envio: ${votesBefore}`);
    console.log(`Votação depois do envio: ${votesAfter}`);
    console.log(`Situação da proposta depois do envio: ${getProposalStatus(proposalAfter.status)}`);
    console.log(`Resultado da proposta depois do envio: ${getProposalResult(proposalAfter.result)}`);
    // Verificações
    assert.notDeepEqual(votesAfter, votesBefore, 'Algo errado: registro dos votos se manteve igual');
}

const parameters = getParameters();
castVote(parameters);