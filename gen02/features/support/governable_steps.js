const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");

Given('implanto o smart contract governável', async function () {
    this.governableContract = await hre.ethers.deployContract("GovernableTest", [this.adminMockContractAddress]);
    assert.ok(this.governableContract != null);
});

When('tento executar funcionalidade de acesso restrito à governança com a conta {string}', async function (account) {
    const signer = await hre.ethers.getSigner(account);
    assert.ok(signer != null);
    this.governableExecutionError = null;
    try {
        await this.governableContract.connect(signer).governanceAllowedFunction();
    }
    catch(error) {
        this.governableExecutionError = error;
    }
});

Then('a funcionalidade de acesso restrito é executada com sucesso', function () {
    assert.ok(this.governableExecutionError == null);
});

Then('ocorre erro {string} na funcionalidade de acesso restrito', function (error) {
    assert.ok(this.governableExecutionError != null);
    assert.ok(this.governableExecutionError.message.includes(error));
});

When('tento executar funcionalidade sem restrição de acesso com a conta {string}', async function (account) {
    const signer = await hre.ethers.getSigner(account);
    assert.ok(signer != null);
    this.publicExecutionError = null;
    try {
        await this.governableContract.connect(signer).publiclyAllowedFunction();
    }
    catch(error) {
        this.publicExecutionError = error;
    }
});

Then('a funcionalidade sem restrição de acesso é executada com sucesso', function () {
    assert.ok(this.publicExecutionError == null);
});
