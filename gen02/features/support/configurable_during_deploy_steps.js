const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getBoolean } = require('./setup.js');

Given('que inicio a implantação do smart contract configurável', async function () {
    this.configurableContract = await hre.ethers.deployContract("ConfigurableDuringDeployTest", []);
    assert.ok(this.configurableContract != null);
});

When('tento realizar a configuração com a conta {string}', async function (account) {
    const signer = await hre.ethers.getSigner(account);
    assert.ok(signer != null);
    this.configError = null;
    try {
        await this.configurableContract.connect(signer).configureDuringDeploy();
    }
    catch(error) {
        this.configError = error;
    }
});

Then('a configuração é feita com sucesso', function () {
    assert.ok(this.configError == null);
});

Then('ocorre erro {string} na configuração', function (error) {
    assert.ok(this.configError != null);
    assert.ok(this.configError.message.includes(error));
});

When('tento finalizar a implantação com a conta {string}', async function (account) {
    const signer = await hre.ethers.getSigner(account);
    assert.ok(signer != null);
    this.finishError = null;
    try {
        await this.configurableContract.connect(signer).finishConfiguration();
    }
    catch(error) {
        this.finishError = error;
    }
});

Then('a implantação é finalizada com sucesso', function () {
    assert.ok(this.finishError == null);
});

Then('ocorre erro {string} na finalização da implantação', function (error) {
    assert.ok(this.finishError != null);
    assert.ok(this.finishError.message.includes(error));
});

When('tento executar suas funcionalidades', async function () {
    this.execError = null;
    try {
        await this.configurableContract.doSomethingAfterConfiguration();
    }
    catch(error) {
        this.execError = error;
    }
});

Then('as funcionalidades são executadas com sucesso', function () {
    assert.ok(this.execError == null);
});

Then('ocorre erro {string} na execução das funcionalidades', function (error) {
    assert.ok(this.execError != null);
    assert.ok(this.execError.message.includes(error));
});