//require("@nomiclabs/hardhat-waffle");
//require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-ethers");
require("@nomiclabs/hardhat-web3");
require("@nomicfoundation/hardhat-chai-matchers");

module.exports = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      viaIR: true
    }
  },
  networks: {
    hardhat: {
      chainId: 1337 // chainId padrão do Hardhat para desenvolvimento local
    }
  },
  mocha: {
    timeout: 20000 // Aumenta o tempo limite dos testes para evitar falhas em testes demorados
  }
};