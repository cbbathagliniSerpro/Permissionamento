const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { createOrganization, getBoolean, getRoleId } = require('./setup.js');

Given('a conta {string}', function(acc) {
    this.accounts.push(acc);
});

When('implanto o smart contract de gestão de contas', async function () {
    this.accountRulesContractDeployError = null;
    try {
        this.accountRulesContract = await hre.ethers.deployContract("AccountRulesV2Impl", [this.organizationContractAddress, this.accounts, this.adminMockContractAddress]);
        assert.ok(this.accountRulesContract != null);
        this.accountRulesContractAddress = await this.accountRulesContract.getAddress();
        assert.ok(this.accountRulesContractAddress != null);
    }
    catch(error) {
        this.accountRulesContractDeployError = error;
    }
});

Then('a implantação do smart contract de gestão de contas ocorre com sucesso', function() {
    assert.ok(this.accountRulesContractDeployError == null);
});

Then('ocorre erro na implantação do smart contract de gestão de contas', function () {
    assert.ok(this.accountRulesContractDeployError != null);
});

When('a conta {string} adiciona a conta local {string} com papel {string} e data hash {string}', async function (admin, account, role, dataHash) {
    this.addError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).addLocalAccount(account, getRoleId(role), dataHash);
    }
    catch(error) {
        this.addError = error;
    }
});

When('a conta {string} adiciona a conta {string} na organização {int} com papel {string} e data hash {string}', async function (admin, account, orgId, role, dataHash) {
    this.addError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).addAccount(account, orgId, getRoleId(role), dataHash);
    }
    catch(error) {
        this.addError = error;
    }
});

Then('a conta {string} é da organização {int} com papel {string}, data hash {string} e situação ativa {string}', async function (account, orgId, role, dataHash, active) {
    const acc = await this.accountRulesContract.getAccount(account);
    const hasRole = await this.accountRulesContract.hasRole(getRoleId(role), account);
    assert.equal(acc.orgId, orgId);
    assert.equal(acc.roleId, getRoleId(role));
    assert.equal(acc.dataHash, dataHash);
    assert.equal(hasRole, true);
    assert.equal(acc.active, getBoolean(active));
});

Then('a conta {string} não consta na lista de contas do papel {string}', async function(account, role) {
    const hasRole = await this.accountRulesContract.hasRole(getRoleId(role), account);
    assert.equal(hasRole, false);
});

Then('o evento {string} foi emitido para a conta {string}, organização {int}, papel {string} e data hash {string}', async function (event, account, orgId, role, dataHash) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, 0, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getRoleId(role) &&
            events[i].args[3] == dataHash;
    }
    assert.ok(found);
});

Then('a adição é realizada com sucesso', function() {
    assert.ok(this.addError == null);
});

Then('ocorre erro {string} na tentativa de adição de conta', function(error) {
    assert.ok(this.addError != null);
    assert.ok(this.addError.message.includes(error));
});

Then('verifico se a conta {string} está ativa o resultado é {string}', async function(account, active) {
    const accountActive = await this.accountRulesContract.isAccountActive(account);
    assert.equal(accountActive, getBoolean(active));
});

When('a conta {string} exclui a conta local {string}', async function(admin, account) {
    this.deleteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).deleteLocalAccount(account);
    }
    catch(error) {
        this.deleteError = error;
    }
});

When('a conta {string} exclui a conta {string}', async function(admin, account) {
    this.deleteError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).deleteAccount(account);
    }
    catch(error) {
        this.deleteError = error;
    }
});

Then('a exclusão é realizada com sucesso', function() {
    assert.ok(this.deleteError == null);
});

Then('ocorre erro {string} na tentativa de exclusão de conta', function(error) {
    assert.ok(this.deleteError != null);
    assert.ok(this.deleteError.message.includes(error));
});

Then('o evento {string} foi emitido para a conta {string} da organização {int}', async function (event, account, orgId) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId;
    }
    assert.ok(found);
});

Then('se tento obter os dados da conta {string} ocorre erro {string}', async function(account, error) {
    try {
        let acc = await this.accountRulesContract.getAccount(account);
        console.log(acc);
        assert.fail('Conta não deveria ter sido encontrada');
    }
    catch(getError) {
        assert.ok(getError.message.includes(error));
    }
});

When('a conta {string} atualiza a conta local {string} com papel {string} e data hash {string}', async function(admin, account, role, dataHash) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).updateLocalAccount(account, getRoleId(role), dataHash);
    }
    catch(error) {
        this.updateError = error;
    }
});

When('a conta {string} atualiza a situação ativa da conta local {string} para {string}', async function(admin, account, active) {
    this.updateError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).updateLocalAccountStatus(account, getBoolean(active));
    }
    catch(error) {
        this.updateError = error;
    }
});

Then('a atualização é realizada com sucesso', function() {
    assert.ok(this.updateError == null);
});

Then('ocorre erro {string} na tentativa de atualização de conta', function(error) {
    assert.ok(this.updateError != null);
    assert.ok(this.updateError.message.includes(error));
});

Then('o evento {string} foi emitido para a conta {string} da organização {int} com situação ativa {string}', async function(event, account, orgId, active) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == orgId &&
            events[i].args[2] == getBoolean(active);
    }
    assert.ok(found);
});

Then('a conta {string} chamar o endereço {string} tem verificação de permissionamento {string}', async function(sender, target, allowed) {
    const wasAllowed = await this.accountRulesContract.transactionAllowed(sender, target, 0, 0, 0, '0x');
    assert.equal(wasAllowed, getBoolean(allowed));
});

When('a conta {string} configura restrição de acesso ao endereço {string} permitindo acesso somente pelas contas {string}', async function(admin, target, addresses) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setSmartContractSenderAccess(target, true, getAdresses(addresses));
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

function getAdresses(addresses) {
    let addressArray = [];
    if(addresses.length > 0) {
        addressArray = addresses.split(",");
    }
    return addressArray;
}

When('a conta {string} remove restrição de acesso ao endereço {string}', async function(admin, target) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setSmartContractSenderAccess(target, false, []);
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

Then('a configuração de acesso ocorre com sucesso', function() {
    assert.ok(this.accessConfigurationError == null);
});

Then('ocorre erro {string} na tentativa de configuração de acesso', function(error) {
    assert.ok(this.accessConfigurationError != null);
    assert.ok(this.accessConfigurationError.message.includes(error));
});

Then('o evento {string} foi emitido para o smart contract {string} com restrição {string} permitindo as contas {string}', async function(event, target, restricted, addresses) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == target &&
            events[i].args[1] == getBoolean(restricted) &&
            events[i].args[2].toString() == addresses;
    }
    assert.ok(found);
});

When('a conta {string} configura restrição de acesso para a conta {string} permitindo acesso somente aos endereços {string}', async function(admin, account, targets) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setAccountTargetAccess(account, true, getAdresses(targets));
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

When('a conta {string} remove restrição de acesso para a conta {string}', async function(admin, account) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setAccountTargetAccess(account, false, []);
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

When('a conta {string} remove restrição de acesso para a conta {string} indicando permissão de acesso somente aos endereços {string}', async function(admin, account, targets) {
    this.accessConfigurationError = null;
    try {
        const signer = await hre.ethers.getSigner(admin);
        assert.ok(signer != null);
        await this.accountRulesContract.connect(signer).setAccountTargetAccess(account, false, getAdresses(targets));
    }
    catch(error) {
        this.accessConfigurationError = error;
    }
});

Then('o evento {string} foi emitido para a conta {string} com restrição {string} permitindo acesso aos endereços {string}', async function(event, account, restricted, addresses) {
    const block = await hre.ethers.provider.getBlockNumber();
    const events = await this.accountRulesContract.queryFilter(event, block, block);
    let found = false;
    for (let i = 0; i < events.length && !found; i++) {
        found =
            events[i].fragment.name == event &&
            events[i].args[0] == account &&
            events[i].args[1] == getBoolean(restricted) &&
            events[i].args[2].toString() == addresses;
    }
    assert.ok(found);
});

When('um observador consulta a conta {string}', async function(account) {
    this.getAccountError = null;
    try {
        await this.accountRulesContract.getAccount(account);
    }
    catch(error) {
        this.getAccountError = error;
    }
});

Then('a consulta de conta ocorre com sucesso', function() {
    assert.ok(this.getAccountError == null);
});

Then('ocorre erro {string} na consulta de conta', function(error) {
    assert.ok(this.getAccountError != null);
    assert.ok(this.getAccountError.message.includes(error));
});

Then('a quantidade total de contas é {int}', async function(expectedNumberOfAccounts) {
    const actualNumberOfAccounts = await this.accountRulesContract.getNumberOfAccounts();
    assert.equal(actualNumberOfAccounts, expectedNumberOfAccounts);
});

Then('a quantidade de contas da organização {int} é {int}', async function(orgId, expectedNumberOfAccounts) {
    const actualNumberOfAccounts = await this.accountRulesContract.getNumberOfAccountsByOrg(orgId);
    assert.equal(actualNumberOfAccounts, expectedNumberOfAccounts);
});

When('consulto as contas a partir da página {int} com tamanho de página {int}', async function(page, pageSize) {
    this.getAccountError = null;
    try {
        this.queryResult = await this.accountRulesContract.getAccounts(page, pageSize);
    }
    catch(error) {
        this.getAccountError = error;
    }
});

When('consulto as contas da organização {int} a partir da página {int} com tamanho de página {int}', async function(orgId, page, pageSize) {
    this.getAccountError = null;
    try {
        this.queryResult = await this.accountRulesContract.getAccountsByOrg(orgId, page, pageSize);
    }
    catch(error) {
        this.getAccountError = error;
    }
});

Then('o resultado da consulta de contas é {string}', async function(accsList) {
    assert.ok(this.getAccountError == null);
    const expectedAccs = accsList.length == 0 ? [] : accsList.split('|');
    assert.equal(this.queryResult.length, expectedAccs.length);
    for(i = 0; i < expectedAccs.length; ++i) {
        const acc = expectedAccs[i].split(',');
        assert.ok(this.queryResult[i].length == 5);
        assert.ok(acc.length == 5);
        assert.equal(this.queryResult[i][0], BigInt(acc[0]));
        assert.equal(this.queryResult[i][1], acc[1]);
        assert.equal(this.queryResult[i][2], getRoleId(acc[2]));
        assert.equal(this.queryResult[i][3], acc[3]);
        assert.equal(this.queryResult[i][4], getBoolean(acc[4]));
    }
});

When('consulto as restrições de acesso da conta {string} recebo indicação de restrição configurada {string} com acesso aos endereços {string}', async function(account, restricted, targetList) {
    const expectedTargets = targetList.length == 0 ? [] : targetList.split(',');
    const result = await this.accountRulesContract.getAccountTargetAccess(account);
    assert.equal(result[0], getBoolean(restricted));
    const targets = result[1];
    assert.equal(targets.length, expectedTargets.length);
    for(i = 0; i < expectedTargets.length; ++i) {
        assert.equal(targets[i], expectedTargets[i]);
    }
});

Then('a quantidade total de contas com restrições de acesso configuradas é {int}', async function(expectedNumberOfAccounts) {
    const actualNumberOfAccounts = await this.accountRulesContract.getNumberOfRestrictedAccounts();
    assert.equal(actualNumberOfAccounts, expectedNumberOfAccounts);
});

When('consulto as contas com restrições de acesso configuradas a partir da página {int} com tamanho de página {int}', async function(page, pageSize) {
    this.getAccountError = null;
    try {
        this.queryResult = await this.accountRulesContract.getRestrictedAccounts(page, pageSize);
    }
    catch(error) {
        this.getAccountError = error;
    }
});

Then('o resultado da consulta de contas com restrições de acesso configuradas é {string}', function(accsList) {
    assert.ok(this.getAccountError == null);
    const expectedAccs = accsList.length == 0 ? [] : accsList.split(',');
    assert.equal(this.queryResult.length, expectedAccs.length);
    for(i = 0; i < expectedAccs.length; ++i) {
        assert.equal(this.queryResult[i], expectedAccs[i]);
    }
});

Then('a quantidade total de smart contracts com restrições de acesso configuradas é {int}', async function(expectedNumberOfContracts) {
    const actualNumberOfContracts = await this.accountRulesContract.getNumberOfRestrictedSmartContracts();
    assert.equal(actualNumberOfContracts, expectedNumberOfContracts);
});

When('consulto as restrições de acesso do smart contract {string} recebo indicação de restrição configurada {string} com acesso pelos endereços {string}', async function(smartContract, restricted, senderList) {
    const expectedSenders = senderList.length == 0 ? [] : senderList.split(',');
    const result = await this.accountRulesContract.getSmartContractSenderAccess(smartContract);
    assert.equal(result[0], getBoolean(restricted));
    const senders = result[1];
    assert.equal(senders.length, expectedSenders.length);
    for(i = 0; i < expectedSenders.length; ++i) {
        assert.equal(senders[i], expectedSenders[i]);
    }
});

When('consulto os smart contracts com restrições de acesso configuradas a partir da página {int} com tamanho de página {int}', async function(page, pageSize) {
    this.getAccountError = null;
    try {
        this.queryResult = await this.accountRulesContract.getRestrictedSmartContracts(page, pageSize);
    }
    catch(error) {
        this.getAccountError = error;
    }
});

Then('o resultado da consulta de smart contracts com restrições de acesso configuradas é {string}', function(accsList) {
    assert.ok(this.getAccountError == null);
    const expectedAccs = accsList.length == 0 ? [] : accsList.split(',');
    assert.equal(this.queryResult.length, expectedAccs.length);
    for(i = 0; i < expectedAccs.length; ++i) {
        assert.equal(this.queryResult[i], expectedAccs[i]);
    }
});

