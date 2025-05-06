const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation } = require('./util.js');
const { INGRESS_ABI, RULES_CONTRACT, NODE_INGRESS_ADDRESS, ACCOUNT_INGRESS_ADDRESS, STATUS_ACTIVE, RESULT_UNDEFINED } = require('./constants.js');
        
const BLOCKS_DURATION = 30000;
const PROPOSAL_DESCRIPTION = 'Reponteirar AccountIngress e NodeIngress e migrar para Gen02';

async function verifyGen02(nodeRulesV2Address, accountRulesV2Address) {
    console.log('--------------------------------------------------');
    console.log('Verificando Gen02');

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

    console.log();
}

async function createProposal(governanceAddress, nodeRulesV2Address, accountRulesV2Address) {
    console.log('--------------------------------------------------');
    console.log('Criando proposta de governança para migrar permissionamento para a Gen02:');
    console.log(` - Reponteirar AccountIngress para ${accountRulesV2Address}`);
    console.log(` - Reponteirar NodeIngress para ${nodeRulesV2Address}`);
    
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    const accountIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    const nodeIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, NODE_INGRESS_ADDRESS);
    console.log('Chamadas configuradas para a proposta');
    let targets = [
        ACCOUNT_INGRESS_ADDRESS,
        NODE_INGRESS_ADDRESS
    ];
    let calldatas = [
        accountIngressContract.interface.encodeFunctionData(accountIngressContract.setContractAddress.fragment, [RULES_CONTRACT, accountRulesV2Address]),
        nodeIngressContract.interface.encodeFunctionData(nodeIngressContract.setContractAddress.fragment, [RULES_CONTRACT, nodeRulesV2Address]),
    ];
    for(const i in targets) {
        console.log(` - ${targets[i]}: ${calldatas[i]}`);
    }
    console.log();

    const confirmed = await askConfirmation('Confirma criação de proposta (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }
    
    const resp = await governanceContract.createProposal(targets, calldatas, BLOCKS_DURATION, PROPOSAL_DESCRIPTION);
    await resp.wait();
    const idProposal = await governanceContract.idSeed();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.description, PROPOSAL_DESCRIPTION);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_UNDEFINED);
    console.log(`Proposta ${idProposal} criada.`);
}

async function migrateToGen02(parameters) {
    await diagnostics();
    
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');

    await verifyGen02(nodeRulesV2Address, accountRulesV2Address);

    await createProposal(governanceAddress, nodeRulesV2Address, accountRulesV2Address);
}

const parameters = getParameters();
migrateToGen02(parameters);