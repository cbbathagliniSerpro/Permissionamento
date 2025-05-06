const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, askConfirmation, getDefaultSigner, getNodeType } = require('./util.js');
const { STATUS_ACTIVE } = require('./constants.js');

async function addNodes(parameters) {
    await diagnostics();

    console.log('--------------------------------------------------');
    console.log('Adicionando nós locais');

    const organizationAddress = getParameter(parameters, 'organizationAddress');
    const organizationContract = await hre.ethers.getContractAt('OrganizationImpl', organizationAddress);
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');
    const nodesContract = await hre.ethers.getContractAt('NodeRulesV2Impl', nodeRulesV2Address);

    const signer = await getDefaultSigner();
    const sender = await accountsContract.getAccount(signer.address);
    const org = await organizationContract.getOrganization(sender.orgId);
    
    console.log(`Os nós serão adicionados à organização "${org.name}"`);

    const confirmed = await askConfirmation('Confirma permissionamento de nós (s/n)? ', 's');
    if(!confirmed) {
        console.log('Abortando...');
        return;
    }

    const nodes = getParameter(parameters, 'nodes');
    for(node of nodes) {
        try {
            const resp = await nodesContract.addLocalNode(node.enodeHigh, node.enodeLow, getNodeType(node.nodeType), node.name);
            await resp.wait();
            // Verificações
            const newNode = await nodesContract.getNode(node.enodeHigh, node.enodeLow);
            assert.equal(newNode[0], node.enodeHigh);
            assert.equal(newNode[1], node.enodeLow);
            assert.equal(newNode[2], getNodeType(node.nodeType));
            assert.equal(newNode[3], node.name);
            assert.equal(newNode[4], org.id);
            assert.equal(newNode[5], true);
            console.log(` - Nó adicionado: ${node.name} [${node.nodeType}] ${node.enodeHigh} ${node.enodeLow}`);
        }
        catch(error) {
            console.log(` - Erro na adição do nó ${node.name}: ${error.message}`);
        }
    }
}

const parameters = getParameters();
addNodes(parameters);