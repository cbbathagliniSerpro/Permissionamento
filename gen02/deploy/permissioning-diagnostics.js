const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, getRole, getNodeTypeName, getOrgTypeName } = require('./util.js');
const { RULES_CONTRACT, INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS, NODE_INGRESS_ADDRESS, ADMIN_ABI } = require('./constants.js');

async function ingressDiagnostics() {
    console.log('--------------------------------------------------');
    console.log('Configuração do ponteiramento');

    const accountIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    const currentAccountRulessAddress = await accountIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` AccountIngress está atualmente configurado para ${currentAccountRulessAddress}`);
    
    const nodeIngressContract = await hre.ethers.getContractAt(INGRESS_ABI, NODE_INGRESS_ADDRESS);
    const currentNodeRulessAddress = await nodeIngressContract.getContractAddress(RULES_CONTRACT);
    console.log(` NodeIngress está atualmente configurado para ${currentNodeRulessAddress}`);

    console.log();
}

async function adminDiagnostics(parameters) {
    console.log('--------------------------------------------------');
    console.log('Contas de admin master');

    const adminAddress = getParameter(parameters, 'adminAddress');
    const adminContract = await hre.ethers.getContractAt(ADMIN_ABI, adminAddress);
    const admins = await adminContract.getAdmins();
    for(admin of admins) {
        console.log(` - ${admin}`);
    }

    console.log();
}

async function organizationDiagnostics(parameters) {
    console.log('--------------------------------------------------');
    console.log('Organizações');

    const organizationAddress = getParameter(parameters, 'organizationAddress');
    const organizationContract = await hre.ethers.getContractAt('OrganizationImpl', organizationAddress);
    const orgs = await organizationContract.getOrganizations();
    for(org of orgs) {
        console.log(` - ${org[0]} ${org[1]} ${org[2]} ${getOrgTypeName(org[3])} ${org[4] ? 'pode votar' : ''}`);
    }

    console.log();
}

async function accountsV2Diagnostics(parameters) {
    console.log('--------------------------------------------------');
    console.log('Contas');

    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const numAccounts = await accountsContract.getNumberOfAccounts();
    if(numAccounts > 0) {
        const accounts = await accountsContract.getAccounts(1, numAccounts);
        for(acc of accounts) {
            console.log(` - ${acc[1]}: Org ${acc[0]}, Role ${getRole(acc[2])}, Data Hash ${acc[3]}, Active ${acc[4]}`);
        }
    }
    
    console.log();
}

async function nodesV2Diagnostics(parameters) {
    console.log('--------------------------------------------------');
    console.log('Nós');

    const nodeRulesV2Address = getParameter(parameters, 'nodeRulesV2Address');
    const nodesContract = await hre.ethers.getContractAt('NodeRulesV2Impl', nodeRulesV2Address);
    const numNodes = await nodesContract.getNumberOfNodes();
    if(numNodes > 0) {
        const nodes = await nodesContract.getNodes(1, numNodes);
        for(node of nodes) {
            console.log(` - ${node[0]} ${node[1]}: ${node[3]} Org ${node[4]} ${getNodeTypeName(node[2])}, Active ${node[5]}`);
        }
    }

    console.log();
}

async function permissioningDiagnostics(parameters) {
    await diagnostics();

    console.log('==================================================');
    console.log('Gen01');
    console.log('==================================================');
    await ingressDiagnostics();
    await adminDiagnostics(parameters);

    console.log('==================================================');
    console.log('Gen02');
    console.log('==================================================');
    await organizationDiagnostics(parameters);
    await accountsV2Diagnostics(parameters);
    await nodesV2Diagnostics(parameters);
}

const parameters = getParameters();
permissioningDiagnostics(parameters);