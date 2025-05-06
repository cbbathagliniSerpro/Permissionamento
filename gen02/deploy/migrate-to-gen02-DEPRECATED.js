const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics } = require('./util.js');
const { INGRESS_ABI, RULES_CONTRACT, NODE_INGRESS_ADDRESS, ACCOUNT_INGRESS_ADDRESS } = require('./constants.js');

async function verifyGen02(nodeRulesV2Address, accountRulesV2Address) {
    console.log('--------------------------------------------------');
    console.log('Verificando gen02');

    console.log(`Verificando NodeRulesV2Impl no endereço ${nodeRulesV2Address}`);
    const nodesContract = await hre.ethers.getContractAt('NodeRulesV2Impl', nodeRulesV2Address);
    const nodeActive = await nodesContract.isNodeActive('0x0000000000000000000000000000000000000000000000000000000000000000', '0x0000000000000000000000000000000000000000000000000000000000000000');
    assert.ok(!nodeActive);
    console.log(' NodeRulesV2Impl OK');

    console.log(`Verificando AccountRulesV2Impl no endereço ${accountRulesV2Address}`);
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const accountActive = await accountsContract.isAccountActive('0x0000000000000000000000000000000000000000');
    assert.ok(!accountActive);
    console.log(' AccountRulesV2Impl OK');
}

async function migrateAccountIngress(accountRulesV2Address) {
    console.log('--------------------------------------------------');
    console.log('Migração do AccountIngress');
    const accountIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    
    const currentAccountRulessAddress = await accountIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` AccountIngress está atualmente configurado para ${currentAccountRulessAddress}`);
    
    const resp = await accountIngressContract.setContractAddress(RULES_CONTRACT, accountRulesV2Address);
    await resp.wait();
    assert.equal(await accountIngressContract.getContractAddress(RULES_CONTRACT), accountRulesV2Address);
    console.log(` AccountIngress migrado para ${accountRulesV2Address}`);
}


async function migrateNodeIngress(nodeRulesV2Address) {
    console.log('--------------------------------------------------');
    console.log('Migração do NodeIngress');
    const nodeIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, NODE_INGRESS_ADDRESS);

    const currentNodeRulessAddress = await nodeIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` NodeIngress está atualmente configurado para ${currentNodeRulessAddress}`);
    
    const resp = await nodeIngressContract.setContractAddress(RULES_CONTRACT, nodeRulesV2Address);
    await resp.wait();
    assert.equal(await nodeIngressContract.getContractAddress(RULES_CONTRACT), nodeRulesV2Address);

    console.log(` NodeIngress migrado para ${nodeRulesV2Address}`);
}

async function migrateToGen02(parameters) {
    await diagnostics();
    
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');

    await verifyGen02(nodeRulesV2Address, accountRulesV2Address);

    await migrateAccountIngress(accountRulesV2Address);
    await migrateNodeIngress(nodeRulesV2Address);
}

const parameters = getParameters();
migrateToGen02(parameters);