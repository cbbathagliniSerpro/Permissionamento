const { Before } = require('@cucumber/cucumber')

function createOrganization(cnpj, name, orgType, canVote) {
    return {
        "id": 0,
        "cnpj": cnpj,
        "name": name,
        "orgType": orgType,
        "canVote": canVote
    }
}

function getBoolean(value) {
    switch(value.toLowerCase()) {
        case 'true': return true;
        case 'false': return false;
        default: throw new Error('Valor booleano inválido: ' + value);
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

const typeMap = {
    "Boot": 0,
    "Validator": 1,
    "Writer": 2,
    "WriterPartner": 3,
    "ObserverBoot": 4,
    "Observer": 5,
    "Other": 6
};

function getNodeType(type) {
    if(typeMap[type] == undefined) {
        throw new Error('Tipo de nó inválido: ' + type);
    }
    return typeMap[type];
}

function getConnectionResult(result) {
    switch(result) {
        case 'CONNECTION_ALLOWED': return '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
        case 'CONNECTION_DENIED': return '0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
        default: throw new Error('Resultado inválido: ' + result);
    }
}

function getRoleId(role) {
    switch(role) {
        case 'GLOBAL_ADMIN_ROLE': return '0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f';
        case 'LOCAL_ADMIN_ROLE': return '0xb7f8beecafe1ad662cec1153812612581a86b9460f21b876f3ee163141203dcb';
        case 'DEPLOYER_ROLE': return '0xfc425f2263d0df187444b70e47283d622c70181c5baebb1306a01edba1ce184c';
        case 'USER_ROLE' : return '0x14823911f2da1b49f045a0929a60b8c1f2a7fc8c06c7284ca3e8ab4e193a08c8';
        case 'UNKNOWN_ROLE' : return '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
        default: throw new Error('Role inválida: ' + role);
    }
}

function getProposalStatus(status) {
    switch(status) {
        case 'Active': return 0;
        case 'Canceled': return 1;
        case 'Finished' : return 2;
        case 'Executed' : return 3;
        default: throw new Error('Status inválido: ' + status);
    }
}

function getProposalResult(result) {
    switch(result) {
        case 'Undefined': return 0;
        case 'Approved': return 1;
        case 'Rejected': return 2;
        default: throw new Error('Resultado inválido: ' + result);
    }
}

function getVote(vote) {
    switch(vote) {
        case 'Approval': return true;
        case 'Rejection': return false;
        default: throw new Error('Voto inválido: ' + vote);
    }
}

function getProposalVote(vote) {
    switch(vote) {
        case 'NotVoted': return 0;
        case 'Approval': return 1;
        case 'Rejection': return 2;
        default: throw new Error('Voto inválido: ' + vote);
    }
}

function arraysMatch(actual, expected) {
    let match = actual.length == expected.length;
    for(let i = 0; i < actual.length && match; ++i) {
        match = actual[i] == expected[i];
    }
    return match;
}

Before(function() {
    this.organizations = [];
    this.accounts = [];
    this.proposalCalls = [];
});

module.exports = {
    createOrganization: createOrganization,
    getBoolean: getBoolean,
    getRoleId: getRoleId,
    getOrgType: getOrgType,
    getNodeType: getNodeType,
    getConnectionResult: getConnectionResult,
    getProposalStatus: getProposalStatus,
    getProposalResult: getProposalResult,
    getVote: getVote,
    getProposalVote: getProposalVote,
    arraysMatch: arraysMatch
}
