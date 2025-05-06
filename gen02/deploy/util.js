const fs = require('fs');
const assert = require('assert');
const readline = require('readline');
const hre = require('hardhat');
const { STATUS_ACTIVE, STATUS_EXECUTED, RESULT_APPROVED, NON_ZEROED_ADDRESS, ZEROED_BYTES } = require('./constants.js');

function getParameters() {
    const paramsPath = process.env['CONFIG_PARAMETERS'];
    if(paramsPath == undefined) {
        throw new Error('Variável de ambiente CONFIG_PARAMETERS não foi definida');
    }
    return JSON.parse(fs.readFileSync(paramsPath, 'utf8'));
}

function getParameter(parameters, name) {
    const value = parameters[name];
    if(value == undefined) {
        throw new Error(`Parâmetro ${name} indefinido`);
    }
    return value;
}

async function diagnostics() {
    console.log('--------------------------------------------------');

    console.log(`Parâmetros de configuração: ${process.env['CONFIG_PARAMETERS']}`);

    const signer = await getDefaultSigner();
    console.log(`Conta em uso: ${signer.address}`);
    
    console.log();
}

async function getDefaultSigner() {
    const accs = await hre.ethers.getSigners();
    return accs[0];
}

async function askConfirmation(question, confirmationAnswer) {
    const cli = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });
    const answer = await new Promise(resolve => { cli.question(question, resolve); });
    const confirmed = confirmationAnswer.toLowerCase() == answer.toLowerCase();
    cli.close();
    return confirmed;
}

function getRoleId(role) {
    switch(role) {
        case 'GLOBAL_ADMIN_ROLE': return '0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f';
        case 'LOCAL_ADMIN_ROLE': return '0xb7f8beecafe1ad662cec1153812612581a86b9460f21b876f3ee163141203dcb';
        case 'DEPLOYER_ROLE': return '0xfc425f2263d0df187444b70e47283d622c70181c5baebb1306a01edba1ce184c';
        case 'USER_ROLE' : return '0x14823911f2da1b49f045a0929a60b8c1f2a7fc8c06c7284ca3e8ab4e193a08c8';
        default: throw new Error('Role inválida: ' + role);
    }
}

function getRole(roleId) {
    switch(roleId) {
        case '0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f': return 'GLOBAL_ADMIN_ROLE';
        case '0xb7f8beecafe1ad662cec1153812612581a86b9460f21b876f3ee163141203dcb': return 'LOCAL_ADMIN_ROLE';
        case '0xfc425f2263d0df187444b70e47283d622c70181c5baebb1306a01edba1ce184c': return 'DEPLOYER_ROLE';
        case '0x14823911f2da1b49f045a0929a60b8c1f2a7fc8c06c7284ca3e8ab4e193a08c8': return 'USER_ROLE';
        default: throw new Error('Role ID inválido: ' + roleId);
    }
}

function getNodeType(type) {
    switch(type) {
        case 'Boot': return 0;
        case 'Validator': return 1;
        case 'Writer': return 2;
        case 'WriterPartner' : return 3;
        case 'ObserverBoot' : return 4;
        case 'Observer' : return 5;
        case 'Other' : return 6;
        default: throw new Error('Tipo de nó inválido: ' + type);
    }
}

function getNodeTypeName(type) {
    switch(parseInt(type, 10)) {
        case 0: return 'Boot';
        case 1: return 'Validator';
        case 2: return 'Writer';
        case 3: return 'WriterPartner';
        case 4: return 'ObserverBoot';
        case 5: return 'Observer';
        case 6: return 'Other';
        default: throw new Error('Tipo de nó inválido: ' + type);
    }
}

function getOrgType(type) {
    switch(type) {
        case 'Partner': return 0;
        case 'Associate': return 1;
        case 'Patron': return 2;
        default: throw new Error('Tipo de organização inválido: ' + type);
    }
}

function getOrgTypeName(type) {
    switch(parseInt(type, 10)) {
        case 0: return 'Partner';
        case 1: return 'Associate';
        case 2: return 'Patron';
        default: throw new Error('Tipo de organização inválido: ' + type);
    }
}

function getVote(vote) {
    switch(parseInt(vote, 10)) {
        case 0: return 'NotVoted';
        case 1: return 'Approval';
        case 2: return 'Rejection';
        default: throw new Error('Valor de voto inválido: ' + vote);
    }
}

function getProposalStatus(status) {
    switch(parseInt(status, 10)) {
        case 0: return 'Active';
        case 1: return 'Canceled';
        case 2: return 'Finished';
        case 3: return 'Executed';
        default: throw new Error('Valor de status inválido: ' + status);
    }
}

function getProposalResult(result) {
    switch(parseInt(result, 10)) {
        case 0: return 'Undefined';
        case 1: return 'Approved';
        case 2: return 'Rejected';
        default: throw new Error('Valor de resultado inválido: ' + result);
    }
}

async function executeProposal(governanceContract, idProposal) {
    console.log('--------------------------------------------------');
    console.log(`Executando proposta ${idProposal}`);
    const resp = await governanceContract.executeProposal(idProposal);
    await resp.wait();
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_EXECUTED);
    assert.equal(proposal.result, RESULT_APPROVED);
    console.log(` Proposta ${idProposal} executada.`);
    console.log();
}

async function approveProposal(governanceContract, idProposal, globalAdmins) {
    console.log('--------------------------------------------------');
    console.log(`Aprovando proposta ${idProposal}`);
    
    for(const admin of globalAdmins) {
        try {
            const signer = await hre.ethers.getSigner(admin);
            assert.ok(signer != null);
            const resp = await governanceContract.connect(signer).castVote(idProposal, true);
            await resp.wait();
            console.log(` - Admin ${admin} enviou voto de aprovação`);
        }
        catch(error) {
            console.log(` - Erro ao enviar voto do admin ${admin}: ${error.message}`);
        }
    }
    
    // Verificações
    const proposal = await governanceContract.getProposal(idProposal);
    assert.equal(proposal.status, STATUS_ACTIVE);
    assert.equal(proposal.result, RESULT_APPROVED);
    console.log(` Proposta ${idProposal} aprovada.`);
    console.log();
}

async function transactionAllowed(accountRulesV2Address, accounts) {
    const accountsContract = await hre.ethers.getContractAt('AccountRulesV2Impl', accountRulesV2Address);
    for(acc of accounts) {
        try {
            const allowed = await accountsContract.transactionAllowed(acc, NON_ZEROED_ADDRESS, 0, 0, 0, ZEROED_BYTES);
            const result = allowed ? 'OK' : 'ERRO';
            console.log(` - ${result} - ${acc}`);
        }
        catch(error) {
            console.log(` - Erro na verificação de acesso da conta ${acc}: ${error.message}`);
        }
    }
}

module.exports = {
    getParameters: getParameters,
    getParameter: getParameter,
    diagnostics: diagnostics,
    getDefaultSigner: getDefaultSigner,
    askConfirmation: askConfirmation,
    getRoleId: getRoleId,
    getRole: getRole,
    getNodeType: getNodeType,
    getNodeTypeName: getNodeTypeName,
    getOrgType: getOrgType,
    getOrgTypeName: getOrgTypeName,
    getVote: getVote,
    getProposalStatus: getProposalStatus,
    getProposalResult: getProposalResult,
    executeProposal: executeProposal,
    approveProposal: approveProposal,
    transactionAllowed: transactionAllowed
}
