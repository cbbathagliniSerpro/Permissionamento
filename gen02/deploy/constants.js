const SET_CONTRACT_ADDRESS_FUNCTION = 'setContractAddress(bytes32,address)';
const ADD_ADMIN_FUNC = 'addAdmin(address)';
const REMOVE_ADMIN_FUNC = 'removeAdmin(address)';
const ADD_ACCOUNT_FUNC = 'addAccount(address,uint,bytes32,bytes32)';
const ADMIN_ABI = [
    'function addAdmin(address) public returns (bool)',
    'function removeAdmin(address) public returns (bool)',
    'function isAuthorized(address) public view returns (bool)',
    'function getAdmins() public view returns (address[])'
];
const INGRESS_ABI = [
    'function getContractAddress(bytes32) public view returns(address)',
    'function setContractAddress(bytes32, address) public returns (bool)'
];
const NODE_INGRESS_ABI = INGRESS_ABI.concat('function connectionAllowed(bytes32, bytes32, bytes16, uint16, bytes32, bytes32, bytes16, uint16) public view returns (bytes32)');
const ACCOUNT_INGRESS_ABI = INGRESS_ABI.concat('function transactionAllowed(address, address, uint256, uint256, uint256, bytes) public view returns (bool)');
const STATUS_ACTIVE = 0;
const STATUS_EXECUTED = 3;
const RESULT_UNDEFINED = 0;
const RESULT_APPROVED = 1;
const ZEROED_BYTES = '0x00';
const ZEROED_BYTES_16 = '0x00000000000000000000000000000000';
const ZEROED_BYTES_32 = '0x0000000000000000000000000000000000000000000000000000000000000000';
const RULES_CONTRACT = '0x72756c6573000000000000000000000000000000000000000000000000000000';
const NON_ZEROED_ADDRESS = '0x0000000000000000000000000000000000000001';
const NODE_INGRESS_ADDRESS = '0x0000000000000000000000000000000000009999';
const ACCOUNT_INGRESS_ADDRESS = '0x0000000000000000000000000000000000008888';
const GLOBAL_ADMIN_ROLE = '0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f';
const CONNECTION_ALLOWED = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
// Conta bem conhecida do Hardhat
// Chave privada: 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6
const MOCK_ACCOUNT = '0xa0Ee7A142d267C1f36714E4a8F75612F20a79720';
const REVERTED = 'reverted';
const BOOT_TYPE = 0;

module.exports = {
    SET_CONTRACT_ADDRESS_FUNCTION: SET_CONTRACT_ADDRESS_FUNCTION,
    ADD_ADMIN_FUNC: ADD_ADMIN_FUNC,
    REMOVE_ADMIN_FUNC: REMOVE_ADMIN_FUNC,
    ADD_ACCOUNT_FUNC,
    ADMIN_ABI: ADMIN_ABI,
    INGRESS_ABI: INGRESS_ABI,
    NODE_INGRESS_ABI: NODE_INGRESS_ABI,
    ACCOUNT_INGRESS_ABI: ACCOUNT_INGRESS_ABI,
    STATUS_ACTIVE: STATUS_ACTIVE,
    STATUS_EXECUTED: STATUS_EXECUTED,
    RESULT_UNDEFINED: RESULT_UNDEFINED,
    RESULT_APPROVED: RESULT_APPROVED,
    ZEROED_BYTES: ZEROED_BYTES,
    ZEROED_BYTES_16: ZEROED_BYTES_16,
    ZEROED_BYTES_32: ZEROED_BYTES_32,
    RULES_CONTRACT: RULES_CONTRACT,
    NON_ZEROED_ADDRESS: NON_ZEROED_ADDRESS,
    NODE_INGRESS_ADDRESS: NODE_INGRESS_ADDRESS,
    ACCOUNT_INGRESS_ADDRESS: ACCOUNT_INGRESS_ADDRESS,
    GLOBAL_ADMIN_ROLE: GLOBAL_ADMIN_ROLE,
    CONNECTION_ALLOWED: CONNECTION_ALLOWED,
    MOCK_ACCOUNT: MOCK_ACCOUNT,
    REVERTED: REVERTED,
    BOOT_TYPE: BOOT_TYPE
}
