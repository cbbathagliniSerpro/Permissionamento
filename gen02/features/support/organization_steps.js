const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { createOrganization, getBoolean, getOrgType } = require('./setup.js');

Given('a organização {string} {string} do tipo {string} com direito de voto {string}', function(cnpj, name, orgType, canVote) {
    this.organizations.push(createOrganization(cnpj, name, getOrgType(orgType), getBoolean(canVote)));
});

When('implanto o smart contract de gestão de organizações', async function () {
    this.organizationContractDeployError = null;
    try {
        this.organizationContract = await hre.ethers.deployContract("OrganizationImpl", [this.organizations, this.adminMockContractAddress]);
        assert.ok(this.organizationContract != null);
        this.organizationContractAddress = await this.organizationContract.getAddress();
        assert.ok(this.organizationContractAddress != null);
    }
    catch(error) {
        this.organizationContractDeployError = error;
    }
});

Then('a implantação do smart contract de gestão de organizações ocorre com sucesso', function() {
    assert.ok(this.organizationContractDeployError == null);
});

Given('que não há organizações definidas', function () {
    // Nada a fazer, apenas deixar o array organizations vazio
});

Then('ocorre erro na implantação do smart contract de gestão de organizações', function() {
    assert.ok(this.organizationContractDeployError != null);
});

Then('a organização {int} é {string} {string} do tipo {string} e direito de voto {string}', async function(id, cnpj, name, orgType, canVote) {
    let org = await this.organizationContract.getOrganization(id);
    assert.equal(org.cnpj, cnpj);
    assert.equal(org.name, name);
    assert.equal(org.orgType, getOrgType(orgType));
    assert.equal(org.canVote, getBoolean(canVote));
});

When('um observador consulta a organização {int} ocorre erro {string}', async function(orgId, errorMessage) {
    try {
        await this.organizationContract.getOrganization(orgId);
        assert.fail('Deveria ter ocorrido erro na consulta de organização');
    }
    catch(error) {
        assert.ok(error.message.includes(errorMessage));
    }
});

Then('a lista de organizações é {string}', async function(orgsList) {
    const actualOrgs = await this.organizationContract.getOrganizations();
    const expectedOrgs = orgsList.split('|');
    assert.equal(actualOrgs.length, expectedOrgs.length);
    for(i = 0; i < expectedOrgs.length; ++i) {
        const org = expectedOrgs[i].split(',');
        assert.ok(actualOrgs[i].length == 5);
        assert.ok(org.length == 5);
        assert.equal(actualOrgs[i][0], BigInt(org[0]));
        assert.equal(actualOrgs[i][1], org[1]);
        assert.equal(actualOrgs[i][2], org[2]);
        assert.equal(actualOrgs[i][3], getOrgType(org[3]));
        assert.equal(actualOrgs[i][4], getBoolean(org[4]));
    }
});

When('a conta {string} adiciona a organização {string} {string} do tipo {string} e direito de voto {string}', async function(account, cnpj, name, orgType, canVote) {
    this.addError = null;
    try {
        const signer = await hre.ethers.getSigner(account);
        assert.ok(signer != null);
        await this.organizationContract.connect(signer).addOrganization(cnpj, name, getOrgType(orgType), getBoolean(canVote));
    }
    catch(error) {
        this.addError = error;
    }
});

Then('o evento {string} foi emitido para a organização {int}', async function(event, orgId) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.organizationContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == orgId;
    }
    assert.ok(found);
});

Then('o evento {string} foi emitido para a organização {int} {string} com nome {string} tipo {string} e direito de voto {string}', async function(event, orgId, cnpj, name, orgType, canVote) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.organizationContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == orgId &&
            events[i].args[1] == cnpj &&
            events[i].args[2] == name &&
            events[i].args[3] == getOrgType(orgType) &&
            events[i].args[4] == getBoolean(canVote);
    }
    assert.ok(found);
});

Then('ocorre erro {string} na tentativa de adição de organização', function(error) {
    assert.ok(this.addError != null);
    assert.ok(this.addError.message.includes(error));
});

When('a conta {string} atualiza a organização {int} com CNPJ {string} nome {string} tipo {string} e direito de voto {string}', async function(account, orgId, cnpj, name, orgType, canVote) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(account);
        assert.ok(signer != null);
        await this.organizationContract.connect(signer).updateOrganization(orgId, cnpj, name, getOrgType(orgType), getBoolean(canVote));
    }
    catch(error) {
        this.updateError = error;
    }
});

Then('ocorre erro {string} na tentativa de atualização de organização', function(error) {
    assert.ok(this.updateError != null);
    assert.ok(this.updateError.message.includes(error));
});

Then('verifico se a organização {int} está ativa o resultado é {string}', async function(orgId, active) {
    const orgActive = await this.organizationContract.isOrganizationActive(orgId);
    assert.equal(orgActive, getBoolean(active));
});

When('a conta {string} exclui a organização {int}', async function(account, orgId) {
    this.deleteError = null;
    try {
        const signer = await hre.ethers.getSigner(account);
        assert.ok(signer != null);
        await this.organizationContract.connect(signer).deleteOrganization(orgId);
    }
    catch(error) {
        this.deleteError = error;
    }
});

Then('ocorre erro {string} na tentativa de exclusão de organização', function(error) {
    assert.ok(this.deleteError != null);
    assert.ok(this.deleteError.message.includes(error));
});

