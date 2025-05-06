const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getProposalStatus, getProposalResult, getVote, getProposalVote, arraysMatch } = require('./setup.js');


Given('implanto o smart contract de governança do permissionamento', async function () {
    this.govenanceContractDeployError = null;
    try {
        this.govenanceContract = await hre.ethers.deployContract("Governance", [this.organizationContractAddress, this.accountRulesContractAddress, this.adminMockContractAddress]);
        assert.ok(this.govenanceContract != null);
        this.govenanceContractAddress = await this.govenanceContract.getAddress();
        assert.ok(this.govenanceContractAddress != null);
    }
    catch(error) {
        this.govenanceContractDeployError = error;
    }
});

Then('a implantação do smart contract de governança do permissionamento ocorre com sucesso', function() {
    assert.ok(this.govenanceContractDeployError == null);
});

Given('implanto um smart contract mock para que sofra ações da governança', async function () {
    this.mockContractDeployError = null;
    try {
        this.mockContract = await hre.ethers.deployContract("ExecutionMock", []);
        assert.ok(this.mockContract != null);
        this.mockContractAddress = await this.mockContract.getAddress();
        assert.ok(this.mockContractAddress != null);
    }
    catch(error) {
        this.mockContractDeployError = error;
    }
});

Then('a implantação do smart contract mock ocorre com sucesso', function() {
    assert.ok(this.mockContractDeployError == null);
});


When('um observador consulta a proposta {int} ocorre erro {string}', async function(proposalId, errorMessage) {
    try {
        await this.govenanceContract.getProposal(proposalId);
        assert.fail('Deveria ter ocorrido erro na consulta de proposta');
    }
    catch(error) {
        assert.ok(error.message.includes(errorMessage));
    }
});

//https://emn178.github.io/online-tools/keccak_256.html
//https://abi.hashex.org/
//https://docs.ethers.org/v6/api/abi/abi-coder/
When('a conta {string} cria uma proposta com alvo o smart contract de teste com dados {string}, limite de {int} blocos e descrição {string}', async function(admin, calldatas, blocksDuration, description) {
    const calldatasArray = calldatas.split(',');
    const targetsArray = [];
    for(i = 0; i < calldatasArray.length; ++i) {
        targetsArray.push(this.mockContractAddress);
    }
    
    this.creationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).createProposal(targetsArray, calldatasArray, blocksDuration, description);
    }
    catch(error) {
        this.creationError = error;
    }
    
    this.proposalId = await this.govenanceContract.idSeed();
});

When('a conta {string} cria uma proposta com alvos {string}, com dados {string}, limite de {int} blocos e descrição {string}', async function(admin, targets, calldatas, blocksDuration, description) {
    const calldatasArray = calldatas.split(',');
    const targetsArray = targets.split(',');
    
    this.creationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).createProposal(targetsArray, calldatasArray, blocksDuration, description);
    }
    catch(error) {
        this.creationError = error;
    }
    
    this.proposalId = await this.govenanceContract.idSeed();
});

Then('a proposta é criada com sucesso', function() {
    assert.ok(this.creationError == null);
});

Then('ocorre erro {string} na criação da proposta', function(error) {
    assert.ok(this.creationError != null);
    assert.ok(this.creationError.message.includes(error));
});

Then('a proposta tem situação {string}, resultado {string}, organizações {string} e votos {string}', async function(status, result, orgs, votes) {
    await proposalAssertions(this.proposalId, status, result, orgs, votes, this);
});

Then('a proposta {int} tem situação {string}, resultado {string}, organizações {string} e votos {string}', async function(proposalId, status, result, orgs, votes) {
    await proposalAssertions(proposalId, status, result, orgs, votes, this);
});

async function proposalAssertions(proposalId, status, result, orgs, votes, ctx) {
    const expectedOrgs = orgs.split(',');
    const expectedVotes = votes.split(',');
    const proposal = await ctx.govenanceContract.getProposal(proposalId);
    assert.equal(proposal.status, getProposalStatus(status));
    assert.equal(proposal.result, getProposalResult(result));
    assert.equal(proposal.organizations.length, expectedOrgs.length);
    for(i = 0; i < expectedOrgs.length; ++i) {
        assert.equal(proposal.organizations[i], expectedOrgs[i]);
    }
    assert.equal(proposal.votes.length, expectedVotes.length);
    for(i = 0; i < expectedVotes.length; ++i) {
        assert.equal(proposal.votes[i], getProposalVote(expectedVotes[i]));
    }
}

When('a conta {string} cancela a proposta {int}', async function(admin, proposalId) {
    this.cancelError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).cancelProposal(proposalId, "");
    }
    catch(error) {
        this.cancelError = error;
    }
});

When('a conta {string} cancela a proposta com motivo {string}', async function(admin, reason) {
    this.cancelError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).cancelProposal(this.proposalId, reason);
    }
    catch(error) {
        this.cancelError = error;
    }
});

Then('a proposta é cancelada com sucesso', function() {
    assert.ok(this.cancelError == null);
});

Then('o motivo de cancelamento da proposta é {string}', async function(reason) {
    const proposal = await this.govenanceContract.getProposal(this.proposalId);
    assert.equal(proposal.cancelationReason, reason);
});

Then('ocorre erro {string} no cancelamento da proposta', function(error) {
    assert.ok(this.cancelError != null);
    assert.ok(this.cancelError.message.includes(error));
});

When('a conta {string} envia um voto de {string}', async function(admin, vote) {
    this.voteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).castVote(this.proposalId, getVote(vote));
    }
    catch(error) {
        this.voteError = error;
    }
});

When('a conta {string} envia um voto de {string} para a proposta {int}', async function(admin, vote, proposalId) {
    this.voteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).castVote(proposalId, getVote(vote));
    }
    catch(error) {
        this.voteError = error;
    }
});

Then('o voto é registrado com sucesso', function() {
    assert.ok(this.voteError == null);
});

Then('ocorre erro {string} no envio do voto', function(error) {
    assert.ok(this.voteError != null);
    assert.ok(this.voteError.message.includes(error));
});

Then('o evento {string} é emitido para a proposta com voto de {string} pela organização {int}', async function(event, vote, orgId) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == this.proposalId &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getVote(vote);
    }
    assert.ok(found);
});

Then('o evento {string} é emitido para a proposta', async function(event) {
    await proposalEventAssertions(event, this.proposalId, this);
});

Then('o evento {string} é emitido para a proposta {int}', async function(event, proposalId) {
    await proposalEventAssertions(event, proposalId, this);
});

async function proposalEventAssertions(event, proposalId, ctx) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await ctx.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == proposalId;
    }
    assert.ok(found);
}

Then('o evento {string} é emitido para a proposta com mensagem {string}', async function(event, message) {
    await proposalEventMessageAssertions(event, this.proposalId, message, this);
});

Then('o evento {string} é emitido para a proposta {int} com mensagem {string}', async function(event, proposalId, message) {
    await proposalEventMessageAssertions(event, proposalId, message, this);
});

async function proposalEventMessageAssertions(event, proposalId, message, ctx) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await ctx.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == proposalId &&
            events[i].args[1] == message;
    }
    assert.ok(found);
}

Then('o evento {string} é emitido para a proposta com alvo do smart contract de teste, dados {string}, limite de {int} blocos e descrição {string}', async function(event, calldatas, blocksDuration, description) {
    const calldatasArray = calldatas.split(',');
    const targetsArray = [];
    for(i = 0; i < calldatasArray.length; ++i) {
        targetsArray.push(this.mockContractAddress);
    }
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.govenanceContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        const targetsMatch = 
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == this.proposalId &&
            arraysMatch(events[i].args[1], targetsArray) &&
            arraysMatch(events[i].args[2], calldatasArray) &&
            events[i].args[3] == blocksDuration &&
            events[i].args[4] == description;
    }
    assert.ok(found);
});

When('consulto o código do smart contract de teste o resultado é {int}', async function(expectedResult) {
    const actualResult = await this.mockContract.code();
    assert.equal(actualResult, expectedResult);
});

When('consulto a mensagem do smart contract de teste o resultado é {string}', async function(expectedResult) {
    const actualResult = await this.mockContract.message();
    assert.equal(actualResult, expectedResult);
});

When('a conta {string} executa a proposta', async function(admin) {
    this.executionError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.govenanceContract.connect(signer).executeProposal(this.proposalId);
    }
    catch(error) {
        this.executionError = error;
    }
});

Then('a proposta é executada com sucesso', function() {
    assert.ok(this.executionError == null);
});

Then('ocorre erro {string} na execução da proposta', function(error) {
    assert.ok(this.executionError != null);
    assert.ok(this.executionError.message.includes(error));
});

Then('a quantidade total de propostas é {int}', async function(expectedNumberOfProposals) {
    const actualNumberOfProposals = await this.govenanceContract.getNumberOfProposals();
    assert.equal(actualNumberOfProposals, expectedNumberOfProposals);
});

When('consulto as propostas a partir da página {int} com tamanho de página {int}', async function(page, pageSize) {
    this.queryError = null;
    try {
        this.queryResult = await this.govenanceContract.getProposals(page, pageSize);
    }
    catch(error) {
        this.queryError = error;
    }
});

Then('ocorre erro {string} na consulta de proposta', function(error) {
    assert.ok(this.queryError != null);
    assert.ok(this.queryError.message.includes(error));
});

Then('o resultado da consulta de propostas é {string}', async function(list) {
    assert.ok(this.queryError == null);
    const expectedResults = list.length == 0 ? [] : list.split('|');
    assert.equal(this.queryResult.length, expectedResults.length);
    for(i = 0; i < expectedResults.length; ++i) {
        const result = expectedResults[i].split(',');
        assert.ok(this.queryResult[i].length == 12);
        assert.ok(result.length == 4);
        assert.equal(this.queryResult[i][0], result[0]);
        assert.equal(this.queryResult[i][3], result[1]);
        assert.equal(this.queryResult[i][4], result[2]);
        assert.equal(this.queryResult[i][5], result[3]);
    }
});
