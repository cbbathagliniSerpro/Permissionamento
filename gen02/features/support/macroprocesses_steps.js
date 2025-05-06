const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getRoleId, getBoolean } = require('./setup.js');

function getContract(context, contract) {
    switch(contract) {
        case 'Admin': return context.adminMockContract;
        case 'OrganizationImpl': return context.organizationContract;
        case 'AccountRulesV2Impl': return context.accountRulesContract;
        case 'Governance': return context.govenanceContract;
        default: throw new Error('Alvo desconhecido: ' + contract);
    }
}

Given('o smart contract de governança é adicionado como admin master', async function() {
    await this.adminMockContract.addAdmin(this.govenanceContractAddress);
});

function handleCalldataParameters(parameters) {
    for(let i = 0; i < parameters.length; ++i) {
        param = parameters[i];
        if(param.toLowerCase() == 'true') {
            parameters[i] = true;
        }
        else if(param.toLowerCase() == 'false') {
            parameters[i] = false;
        }
        else if(param.startsWith('[') && param.endsWith(']')) {
            const paramArray = param.length == 2 ? [] : param.substring(1, param.length - 1).split(';');
            parameters[i] = paramArray;
        }
    }
}

Given('o alvo {string} para chamada da função {string} com parâmetros {string}', async function(targetName, functionSignature, parameterList) {
    const targetContract = getContract(this, targetName);
    const targetAddress = await targetContract.getAddress();
    const parameters = parameterList.length == 0 ? [] : parameterList.split(',');
    handleCalldataParameters(parameters);
    const calldata = targetContract.interface.encodeFunctionData(functionSignature, parameters);
    this.proposalCalls.push([targetAddress, calldata]);
});

function getTargets(proposalCalls) {
    let targets = [];
    for(const call of proposalCalls) {
        targets.push(call[0]);
    }
    return targets;
}

function getCalldatas(proposalCalls) {
    let calldatas = [];
    for(const call of proposalCalls) {
        calldatas.push(call[1]);
    }
    return calldatas;
}

When('a conta {string} cria proposta com descrição {string}', async function(admin, description) {
    const signer = await hre.ethers.getSigner(admin);
    assert.ok(signer != null);
    this.creationError = null;
    try {
        await this.govenanceContract.connect(signer).createProposal(getTargets(this.proposalCalls), getCalldatas(this.proposalCalls), 30000, description);
    }
    catch(error) {
        this.creationError = error;
    }
    
    this.proposalId = await this.govenanceContract.idSeed();
});

When('se verifico se o smart contract de governança é admin master o resultado é {string}', async function(admin) {
    const isAdmin = await this.adminMockContract.admins(this.govenanceContractAddress);
    assert.equal(isAdmin, getBoolean(admin));
});
