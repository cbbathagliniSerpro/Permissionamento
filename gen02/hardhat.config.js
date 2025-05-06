require("@nomicfoundation/hardhat-toolbox");
const dotenv = require('dotenv');

dotenv.config();

/* The adress used when sending transactions to the node */
var accountAddress = process.env.ACCOUNT_ADDRESS;
/* The private key associated with the address above */
var privateKey = process.env.PRIVATE_KEY;
/* Private keys of alternative accounts */
var altPrivateKeys = process.env.ALT_PRIVATE_KEYS;

if(accountAddress === undefined) {
    accountAddress = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';
}

if(privateKey === undefined) {
    privateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';
}

var privateKeys = [];
privateKeys.push(privateKey);

if(altPrivateKeys != undefined) {
    privateKeys = privateKeys.concat(altPrivateKeys.split(','));
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    local: {
      url: "http://127.0.0.1:8545"
    },
    local_besu: {
      url: "http://127.0.0.1:8545",
      chainId: 648629,
      accounts: privateKeys,
      from: accountAddress
    }
  },
  solidity: "0.8.28"
};
