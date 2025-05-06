const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getDefaultSigner, getNodeType } = require('./util.js');
const { ZEROED_BYTES_16, CONNECTION_ALLOWED } = require('./constants.js');

async function testNodes(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Testando conectividade de nós - connectionAllowed()');

    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');
    const nodesContract = await hre.ethers.getContractAt('NodeRulesV2Impl', nodeRulesV2Address);
    const nodes = getParameter(parameters, 'nodes');
    for(node of nodes) {
        try {
            // Testa conectividade do nó com ele mesmo, apenas para verificar se o nó está ativo
            const resp = await nodesContract.connectionAllowed(node.enodeHigh, node.enodeLow, ZEROED_BYTES_16, 0, node.enodeHigh, node.enodeLow, ZEROED_BYTES_16, 0);
            const result = resp == CONNECTION_ALLOWED ? 'OK' : 'ERRO';
            console.log(` - ${result} - ${node.name} [${node.nodeType}] ${node.enodeHigh} ${node.enodeLow}`);
        }
        catch(error) {
            console.log(` - Erro na verificação de conectividade do nó ${node.name} [${node.nodeType}] ${node.enodeHigh} ${node.enodeLow}: ${error.message}`);
        }
    }
}

const parameters = getParameters();
testNodes(parameters);