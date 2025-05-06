const { Given, When, Then, setDefaultTimeout } = require('@cucumber/cucumber');
const { expect } = require('chai');
const { loadFixture } = require('@nomicfoundation/hardhat-network-helpers');
const { ethers } = require('hardhat');

// Aumentar o timeout para permitir implantação do contrato e execução dos testes
setDefaultTimeout(60*1000);

let paginationMock;
let testNumbers = [];
let testAddresses = [];
let lastResult;
let lastError;
let pageBounds;

async function deployPaginationMockFixture() {
  const PaginationMock = await ethers.getContractFactory('PaginationMock');
  const paginationMock = await PaginationMock.deploy();
  return { paginationMock };
}

Given('que o contrato PaginationMock está implantado', async function() {
  const { paginationMock: mock } = await loadFixture(deployPaginationMockFixture);
  paginationMock = mock;
});

Given('que existem {int} números sequenciais no conjunto de teste', async function(count) {
  await paginationMock.resetUintTestSet();
  testNumbers = [];
  
  for (let i = 1; i <= count; i++) {
    await paginationMock.addUintToTestSet(i);
    testNumbers.push(i);
  }
  
  const length = await paginationMock.getUintTestSetLength();
  expect(length).to.equal(count);
});

Given('que existem {int} endereços aleatórios no conjunto de teste', async function(count) {
  await paginationMock.resetAddressTestSet();
  testAddresses = [];
  
  for (let i = 0; i < count; i++) {
    const wallet = ethers.Wallet.createRandom();
    await paginationMock.addAddressToTestSet(wallet.address);
    testAddresses.push(wallet.address);
  }
  
  // Verificar que os endereços foram adicionados corretamente
  const length = await paginationMock.getAddressTestSetLength();
  expect(length).to.equal(count);
});

Given('que o conjunto de números está vazio', async function() {
  await paginationMock.resetUintTestSet();
  testNumbers = [];
  
  const length = await paginationMock.getUintTestSetLength();
  expect(length).to.equal(0);
});

When('solicito a página {int} com tamanho {int}', async function(pageNumber, pageSize) {
  lastError = null;
  try {
    lastResult = await paginationMock.getUintTestPage(pageNumber, pageSize);
  } catch (error) {
    lastError = error;
  }
});

When('solicito a página {int} de endereços com tamanho {int}', async function(pageNumber, pageSize) {
  lastError = null;
  try {
    lastResult = await paginationMock.getAddressTestPage(pageNumber, pageSize);
  } catch (error) {
    lastError = error;
  }
});

When('tento solicitar a página {int} com tamanho {int}', async function(pageNumber, pageSize) {
  try {
    await paginationMock.getUintTestPage(pageNumber, pageSize);
    lastError = null;
  } catch (error) {
    lastError = error;
  }
});

When('calculo os limites da página {int} com tamanho {int} para um total de {int} itens', async function(pageNumber, pageSize, totalItems) {
  lastError = null;
  try {
    pageBounds = await paginationMock.getTestPageBounds(totalItems, pageNumber, pageSize);
  } catch (error) {
    lastError = error;
  }
});

Then('devo receber {int} números', function(count) {
  expect(lastResult.length).to.equal(count);
});

Then('devo receber {int} endereços', function(count) {
  expect(lastResult.length).to.equal(count);
});

Then('o primeiro número retornado deve ser {int}', function(value) {
  if (value.toString() === "-") {
    return;
  }
  
  expect(lastResult.length).to.be.greaterThan(0);
  expect(Number(lastResult[0])).to.equal(value);
});

Then('o último número retornado deve ser {int}', function(value) {
  if (value.toString() === "-") {
    return;
  }
  
  expect(lastResult.length).to.be.greaterThan(0);
  expect(Number(lastResult[lastResult.length - 1])).to.equal(value);
});

Then('o primeiro número retornado deve ser -', function() {
});

Then('o último número retornado deve ser -', function() {
});

Then('deve ocorrer erro {string}', function(errorName) {
  expect(lastError).to.not.be.null;
  expect(lastError.toString()).to.include(errorName);
});

Then('o início deve ser {int} e o fim deve ser {int}', function(start, stop) {
  expect(pageBounds[0]).to.equal(start);
  expect(pageBounds[1]).to.equal(stop);
});