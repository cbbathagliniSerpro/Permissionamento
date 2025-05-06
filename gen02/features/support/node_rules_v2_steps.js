const assert = require('assert');
const { defineParameterType, Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const {boolean} = require("hardhat/internal/core/params/argumentTypes");
const { getNodeType, getBoolean, getConnectionResult } = require("./setup");

defineParameterType({
    name: "boolean",
    regexp: /true|false/,
    transformer: (s) => s === "true"
});

function checkErrorMessage(error, expectedMessage) {
    assert.ok(error.message.includes(expectedMessage));
}

Given('implanto o smart contract de gestão de nós', async function() {
    this.nodeRulesContractDeployError = null;
    try {
        this.nodeRulesContract = await hre.ethers.deployContract("NodeRulesV2Impl", [this.organizationContractAddress, this.accountRulesContract, this.adminMockContractAddress]);
        assert.ok(this.nodeRulesContract != null);
        this.nodeRulesContractAddress = await this.nodeRulesContract.getAddress();
        assert.ok(this.nodeRulesContractAddress != null);
    }
    catch(error) {
        this.nodeRulesContractDeployError = error;
    }
});

Then('a implantação do smart contract de gestão de nós ocorre com sucesso', function() {
    assert.ok(this.nodeRulesContractDeployError == null);
});

Then('a transação ocorre com sucesso', async function() {
    assert.ok(this.error === undefined);
});

Then('ocorre erro {string} na transação', async function(error){
    assert.ok(this.error);
    checkErrorMessage(this.error, error);
})

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} do nó para cadastrá-lo', async function (admin, enodeHigh, enodeLow, name, type) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRulesContract.connect(signer).addLocalNode(enodeHigh, enodeLow, getNodeType(type), name);
    }
    catch (e) {
        this.error = e;
    }
});

Then('o evento {string} é emitido para o nó {string} {string} da organização {int}', async function (event, enodeHigh, enodeLow, organization) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRulesContract.queryFilter(event, block, block);
    assert.equal(events[0].args[0], enodeHigh);
    assert.equal(events[0].args[1], enodeLow);
    assert.equal(parseInt(events[0].args[2]), organization);
});

Then('o nó {string} {string} é da organização {int}, tem o nome {string}, tipo {string} e situação ativa {boolean}', async function (enodeHigh, enodeLow, organization, name, type, active) {
    const nodeInfo = await this.nodeRulesContract.getNode(enodeHigh, enodeLow);
    assert.equal(parseInt(nodeInfo[2]), getNodeType(type));
    assert.equal(nodeInfo[3], name);
    assert.equal(parseInt(nodeInfo[4]), organization);
    assert.equal(nodeInfo[5], active);
});

Then('se uma consulta é realizada ao nó {string} {string} recebe-se o erro {string}', async function (enodeHigh, enodeLow, expectedErrorMessage) {
    try {
        await this.nodeRulesContract.getNode(enodeHigh, enodeLow);
        assert.fail('Deveria ter ocorrido erro na consulta de nó');
    }
    catch (error) {
        checkErrorMessage(error, expectedErrorMessage);
    }
});

When('a conta {string} informa o endereço {string} {string} para exclusão', async function (admin, enodeHigh, enodeLow) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRulesContract.connect(signer).deleteLocalNode(enodeHigh, enodeLow);
    }
    catch(error) {
        this.error = error;
    }
});

When('a conta {string} informa o endereço {string} {string}, o nome {string} e o tipo {string} para alterá-lo', async function (admin, enodeHigh, enodeLow, name, type) {
    try{
        this.oldInfo = await this.nodeRulesContract.getNode(enodeHigh, enodeLow);
        const signer = await hre.ethers.getSigner(admin);
        await this.nodeRulesContract.connect(signer).updateLocalNode(enodeHigh, enodeLow, getNodeType(type), name);
    }
    catch(error) {
        this.error = error;
    }
});

Then('o nome do nó {string} {string} continua o mesmo', async function (enodeHigh, enodeLow) {
    this.newInfo = await this.nodeRulesContract.getNode(enodeHigh, enodeLow);
    assert.ok(this.newInfo[3] === this.oldInfo[3]);
});

When('a conta {string} informa o endereço {string} {string} para mudar sua situação ativa para {boolean}', async function (admin, enodeHigh, enodeLow, status) {
    const signer = await hre.ethers.getSigner(admin);
    try {
        await this.nodeRulesContract.connect(signer).updateLocalNodeStatus(enodeHigh, enodeLow, status);
    }
    catch(error){
        this.error = error;
    }
});

Then('o evento {string} é emitido para o nó {string} {string} da organização {int} com situação ativa {boolean}', async function (event, enodeHigh, enodeLow, organization, active) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRulesContract.queryFilter(event, block, block);
    assert.equal(events[0].args[0], enodeHigh);
    assert.equal(events[0].args[1], enodeLow);
    assert.equal(events[0].args[2], organization)
    assert.equal(events[0].args[3], active);
});

Then('o evento {string} é emitido para o nó {string} {string} da organização {int} com tipo {string} e nome {string}', async function (event, enodeHigh, enodeLow, organization, type, name) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.nodeRulesContract.queryFilter(event, block, block);
    assert.equal(events[0].args[0], enodeHigh);
    assert.equal(events[0].args[1], enodeLow);
    assert.equal(events[0].args[2], organization)
    assert.equal(events[0].args[3], getNodeType(type));
    assert.equal(events[0].args[4], name);
});


Then('verifico se o nó {string} {string} está ativo o resultado é {boolean}', async function(enodeHigh, enodeLow, status){
   const nodeStatus = await this.nodeRulesContract.isNodeActive(enodeHigh, enodeLow);
   assert.equal(nodeStatus, status);
});

When('a conta de governança {string} informa o endereço {string} {string}, o tipo {string}, o nome {string} e a organização {int} para cadastrá-lo', async function(admin, enodeHigh, enodeLow, type, name, organization) {
    const signer = await hre.ethers.getSigner(admin);
    try{
        await this.nodeRulesContract.connect(signer).addNode(enodeHigh, enodeLow, getNodeType(type), name, organization);
    }
    catch(error){
        this.error = error;
    }
});

When('a conta de governança {string} informa o endereço {string} {string} do nó para removê-lo', async function(admin, enodeHigh, enodeLow) {
   const signer = await hre.ethers.getSigner(admin);
   try{
       await this.nodeRulesContract.connect(signer).deleteNode(enodeHigh, enodeLow);
   }
   catch(error){
       this.error = error;
   }
});

const BYTES_ZERO = '0x00000000000000000000000000000000'

When('o nó {string} {string} tenta se conectar ao nó {string} {string}', async function (sourceHigh, sourceLow, destHigh, destLow) {
   try{
       this.connResult = await this.nodeRulesContract.connectionAllowed(sourceHigh, sourceLow, BYTES_ZERO, 0, destHigh, destLow, BYTES_ZERO, 0);
   }
   catch (error) {
       this.error = error;
   }
});

Then('o resultado da conexão é {string}', async function(result){
   assert.ok(this.error === undefined);
   assert.equal(this.connResult, getConnectionResult(result));
});

When('consulto os nós a partir da página {int} com tamanho de página {int}', async function(page, pageSize) {
    this.queryError = null;
    try {
        this.queryResult = await this.nodeRulesContract.getNodes(page, pageSize);
    }
    catch(error) {
        this.queryError = error;
    }
});

When('consulto os nós da organização {int} a partir da página {int} com tamanho de página {int}', async function(orgId, page, pageSize) {
    this.queryError = null;
    try {
        this.queryResult = await this.nodeRulesContract.getNodesByOrg(orgId, page, pageSize);
    }
    catch(error) {
        this.queryError = error;
    }
});

Then('ocorre erro {string} na consulta de nós', function(error) {
    assert.ok(this.queryError != null);
    assert.ok(this.queryError.message.includes(error));
});

Then('a quantidade total de nós é {int}', async function(expectedNumberOfNodes) {
    const actualNumberOfNodes = await this.nodeRulesContract.getNumberOfNodes();
    assert.equal(actualNumberOfNodes, expectedNumberOfNodes);
});

Then('a quantidade de nós da organização {int} é {int}', async function(orgId, expectedNumberOfNodes) {
    const actualNumberOfNodes = await this.nodeRulesContract.getNumberOfNodesByOrg(orgId);
    assert.equal(actualNumberOfNodes, expectedNumberOfNodes);
});

Then('o resultado da consulta de nós é {string}', async function(nodesList) {
    assert.ok(this.queryError == null);
    const expectedNodes = nodesList.length == 0 ? [] : nodesList.split('|');
    assert.equal(this.queryResult.length, expectedNodes.length);
    for(i = 0; i < expectedNodes.length; ++i) {
        const node = expectedNodes[i].split(',');
        assert.ok(this.queryResult[i].length == 6);
        assert.ok(node.length == 6);
        assert.equal(this.queryResult[i][0], node[0]);
        assert.equal(this.queryResult[i][1], node[1]);
        assert.equal(this.queryResult[i][2], getNodeType(node[2]));
        assert.equal(this.queryResult[i][3], node[3]);
        assert.equal(this.queryResult[i][4], BigInt(node[4]));
        assert.equal(this.queryResult[i][5], getBoolean(node[5]));
    }
});
