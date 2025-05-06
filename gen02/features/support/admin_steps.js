const assert = require('assert');
const { Given, When, Then } = require('@cucumber/cucumber');
const hre = require("hardhat");
const { getBoolean } = require('./setup.js');

Given('que o smart contract de gestão de endereços de admin está implantado', async function () {
    this.adminMockContract = await hre.ethers.deployContract("AdminMock", []);
    assert.ok(this.adminMockContract != null);
    this.adminMockContractAddress = await this.adminMockContract.getAddress();
    assert.ok(this.adminMockContractAddress != null);
});

When('o endereço {string} é admin master', async function(account) {
    await this.adminMockContract.addAdmin(account);
});

Then('a autorização para o endereço {string} é {string}', async function (account, authorized) {
    let auth = await this.adminMockContract.isAuthorized(account);
    assert.equal(auth, getBoolean(authorized));
});

When('se verifico se a conta {string} é admin master o resultado é {string}', async function(account, admin) {
    const isAdmin = await this.adminMockContract.admins(account);
    assert.equal(isAdmin, getBoolean(admin));
});
