const hre = require('hardhat');
const assert = require('assert');
const { getParameters, getParameter, diagnostics, approveProposal, executeProposal } = require('./util.js');
const { SET_CONTRACT_ADDRESS_FUNCTION, INGRESS_ABI, NODE_INGRESS_ABI, ACCOUNT_INGRESS_ABI, STATUS_ACTIVE,
        RESULT_UNDEFINED, RULES_CONTRACT, NODE_INGRESS_ADDRESS, ACCOUNT_INGRESS_ADDRESS, GLOBAL_ADMIN_ROLE,
        MOCK_ACCOUNT } = require('./constants.js');

async function getContractAddress(ingressAddress) {
    const ingressContract = await hre.ethers.getContractAt(INGRESS_ABI, ingressAddress);
    return await ingressContract.getContractAddress(RULES_CONTRACT);
}

async function verifyIngresses(addressGen03) {
    console.log('--------------------------------------------------');
    console.log('Verificando ponteiros dos contratos Ingress');
    const nodeIngressRuleAddress = await getContractAddress(NODE_INGRESS_ADDRESS);
    assert.equal(nodeIngressRuleAddress, addressGen03, `NodeIngress está configurado para endereço errado: ${nodeIngressRuleAddress}`);
    console.log(' - NodeIngress configurado corretamente');
    const accountIngressRuleAddress = await getContractAddress(ACCOUNT_INGRESS_ADDRESS);
    assert.equal(accountIngressRuleAddress, addressGen03, `AccountIngress está configurado para endereço errado: ${accountIngressRuleAddress}`);
    console.log(' - AccountIngress configurado corretamente');
    console.log();
}

async function createProposalGen03Migration(gen03Address, governanceContract) {
    console.log('--------------------------------------------------');
    console.log('Criando proposta para reponteiramento para a Gen03');
    
    const nodeIngressContract = await hre.ethers.getContractAt(NODE_INGRESS_ABI, NODE_INGRESS_ADDRESS);
    const accountIngressContract = await hre.ethers.getContractAt(ACCOUNT_INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    
    console.log(' Chamadas configuradas para a proposta');
    let targets = [];
    let calldatas = []
    targets.push(NODE_INGRESS_ADDRESS);
    calldatas.push(nodeIngressContract.interface.encodeFunctionData(SET_CONTRACT_ADDRESS_FUNCTION, [RULES_CONTRACT, gen03Address]));
    targets.push(ACCOUNT_INGRESS_ADDRESS);
    calldatas.push(accountIngressContract.interface.encodeFunctionData(SET_CONTRACT_ADDRESS_FUNCTION, [RULES_CONTRACT, gen03Address]));
    
    const resp = await governanceContract.createProposal(targets, calldatas, 1000, 'Migração para Mock de Gen03');
    await resp.wait();
    const idProposal = await governanceContract.idSeed();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_UNDEFINED);
    console.log(` Proposta ${idProposal} criada.`);

    console.log();
    return idProposal;
}

async function deployGen03Mock(account) {
    console.log('--------------------------------------------------');
    console.log('Implantando Mock da Gen03');

    const rulesGen03MockContract = await hre.ethers.deployContract("RulesGen03Mock", []);
    await rulesGen03MockContract.waitForDeployment();
    const address = rulesGen03MockContract.target;
    console.log(` RulesGen03Mock implantado no endereço ${address}`);
    
    const resp = await rulesGen03MockContract.addSender(account);
    await resp.wait();
    console.log(` Conta ${account} permissionada na Gen03`);

    console.log();
    return address;
}

async function verifyAllowedTransaction(verifications) {
    console.log('--------------------------------------------------');
    console.log('Verificando possibilidade de envio de transações');
    
    const accountIngressContract = await hre.ethers.getContractAt(ACCOUNT_INGRESS_ABI, ACCOUNT_INGRESS_ADDRESS);
    
    for(const verification of verifications) {
        const sender = verification[0];
        const excpectedAllowed = verification[1];
        const allowed = await accountIngressContract.transactionAllowed(sender, '0x0000000000000000000000000000000000000000', 0, 0, 0, '0x00');
        assert.equal(allowed, excpectedAllowed, `Permissão da conta ${sender} para enviar transação é ${allowed} mas deveria ser ${excpectedAllowed}`);
        console.log(` - ${sender}: ${allowed} [OK]`);
    }

    console.log();
}

async function getAccounts(accountRulesV2Contract) {
    console.log('--------------------------------------------------');
    console.log('Obtendo contas permissionadas');

    const numOfAccounts = await accountRulesV2Contract.getNumberOfAccounts();
    const allAccounts = await accountRulesV2Contract.getAccounts(1, numOfAccounts);
    const activeAccounts = allAccounts.filter(a => a[4]);
    const activeAdmins = activeAccounts.filter(a => a[2] == GLOBAL_ADMIN_ROLE);
    
    console.log(` - ${numOfAccounts} contas permissionadas`);
    console.log(` - ${activeAccounts.length} contas ativas`);
    console.log(` - ${activeAdmins.length} admins ativos`);

    console.log();
    return [activeAccounts, activeAdmins];
}

async function migrateToGen03Mock(parameters) {
    await diagnostics();
    
    const accountRulesV2Address = getParameter(parameters, 'accountRulesV2Address');
    const accountRulesV2Contract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    const governanceAddress = getParameter(parameters, 'governanceAddress');
    const governanceContract = await hre.ethers.getContractAt('Governance', governanceAddress);

    const accounts = await getAccounts(accountRulesV2Contract);
    const activeAccounts = accounts[0].map(a => a[1]);
    const activeAdmins = accounts[1].map(a => a[1]);

    // Prepara verificações: 1 conta fictícia que não pode transacionar e as contas permissionadas que podem
    let verifications = [[MOCK_ACCOUNT, false]];
    activeAdmins.forEach(a => verifications.push([a, true]));

    await verifyAllowedTransaction(verifications);

    const addressGen03 = await deployGen03Mock(MOCK_ACCOUNT);
    const idProposal = await createProposalGen03Migration(addressGen03, governanceContract);
    await approveProposal(governanceContract, idProposal, activeAdmins);
    await executeProposal(governanceContract, idProposal);

    await verifyIngresses(addressGen03);
    // Inverte verificações
    verifications.forEach(v => v[1] = !v[1]);
    await verifyAllowedTransaction(verifications);
}

const parameters = getParameters();
migrateToGen03Mock(parameters);