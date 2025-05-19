
# 🔍 Auditoria com Foundry

Foundry é uma ferramenta que ajuda a criar fuzzy test (ou teste de fuzz), uma abordagem de testes na qual geramos uma grande variedade de inputs pseudo-aleatórios para assegurar que o contrato lida corretamente com casos extremos, entradas inesperadas e condições de erro. A ideia é tentar “quebrar” o contrato simulando cenários caóticos e inputs absurdos que testes unitários comuns muitas vezes não cobrem. 

## 🛠️ Instalação e Uso do Foundry

### 📥 Instalar Foundry

No terminal, execute:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 🧱 Inicializar Projeto com Forge

Para inicializar o projeto de testes (sem git e forçando a criação):
```bash
forge init --no-git --force
```


## 🧪 Executar Testes com Forge

Você pode rodar os testes com diferentes opções:

### ✅ Executar todos os testes
```bash
forge test
```

### 🔄 Testes com fuzzing (ex: 1000 execuções aleatórias)
```bash
forge test --fuzz-runs 1000
```

### 🎯 Rodar teste específico (modo verboso)
```bash
forge test <nome_do_teste> -vvv
```

### 🧬 Rodar uma função específica dentro de um contrato de teste
```bash
forge test <contrato_de_teste> --match-test <nome_da_funcao> -vvv
```

### 📌 Exemplo prático:
```bash
forge test TAccountRulesProxyTest.t.sol --fuzz-runs 2000 -vvv
```

🧠 Dica: Use -vvv para exibir logs detalhados dos testes e facilitar a depuração!



## Ao rodar

Ran 15 tests for test/PaginationTest.t.sol:PaginationTest<br>
[PASS] testGetAddressPageAdjustEndIndex() (gas: 25042)<br>
[PASS] testGetAddressPageEmptyWhenOutOfRange() (gas: 11557)<br>
[PASS] testGetAddressPageInvalidPageNumber() (gas: 10617)<br>
[PASS] testGetAddressPageInvalidPageSize() (gas: 10591)<br>
[PASS] testGetAddressPageReturnsCorrectPage() (gas: 25014)<br>
[PASS] testGetPageBoundsAdjustStop() (gas: 9378)<br>
[PASS] testGetPageBoundsInvalidPageNumber() (gas: 8577)<br>
[PASS] testGetPageBoundsInvalidPageSize() (gas: 8598)<br>
[PASS] testGetPageBoundsNormal() (gas: 9360)<br>
[PASS] testGetPageBoundsOutOfBounds() (gas: 9256)<br>
[PASS] testGetUintPageAdjustEndIndex() (gas: 15028)<br>
[PASS] testGetUintPageEmptyWhenOutOfRange() (gas: 11546)<br>
[PASS] testGetUintPageInvalidPageNumber() (gas: 10615)<br>
[PASS] testGetUintPageInvalidPageSize() (gas: 10569)<br>
[PASS] testGetUintPageReturnsCorrectPage() (gas: 21319)<br>
Suite result: ok. 15 passed; 0 failed; 0 skipped; finished in 8.21ms (2.17ms CPU time)<br><br>

Ran 1 test for test/NodeRulesProxyTest.t.sol:NodeRulesProxyTest
[PASS] testConnectionAllowed(bytes32,bytes32,bytes16,uint16,bytes32,bytes32,bytes16,uint16,bytes32) (runs: 1001, μ: 34420, ~: 34420)<br>
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 100.23ms (94.32ms CPU time)<br><br>

Ran 2 tests for test/AdminProxyTest.t.sol:AdminProxyTest
[PASS] testIsAValidAddress(address) (runs: 1001, μ: 12143, ~: 12143)<br>
[PASS] testIsAuthorized(address,bool) (runs: 1001, μ: 67110, ~: 76707)<br>
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 118.55ms (112.52ms CPU time)
<br><br>
Ran 2 tests for test/AccountRulesProxyTest.t.sol:AccountRulesProxyTest
[PASS] testAreValidsSenderAndTargetAddress(address,address) (runs: 1001, μ: 14038, ~: 14037)<br>
[PASS] testTransactionAllowed(address,address,uint256,uint256,uint256,bytes) (runs: 1001, μ: 15018, ~: 15018)<br>
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 221.86ms (215.83ms CPU time)
<br><br>
Ran 5 tests for test/AccountRulesV2ImplTest.t.sol:AccountRulesV2FuzzTest<br>
[PASS] testFuzz_addAccount(address,address,uint256,bytes32,bytes32) (runs: 1001, μ: 62874, ~: 48923)<br>
[PASS] testFuzz_addLocalAccount(address,address,bytes32,bytes32) (runs: 1001, μ: 73396, ~: 73396)<br>
[PASS] testFuzz_deleteLocalAccount(address,address) (runs: 1001, μ: 16968, ~: 16968)<br>
[PASS] testFuzz_updateLocalAccount(address,address,bytes32,bytes32) (runs: 1001, μ: 17079, ~: 17079)<br>
[PASS] testFuzz_updateLocalAccountStatus(address,address,bool) (runs: 1001, μ: 17098, ~: 17089)<br>
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 845.35ms (711.89ms CPU time)<br>

Ran 6 tests for test/NodeRulesV2ImplTest.t.sol:NodeRulesV2ImplFuzzTest<br>
[PASS] testFuzz_AddLocalNode(address,bytes32,bytes32,string) (runs: 1001, μ: 22123, ~: 22131)<br>
[PASS] testFuzz_ConnectionAllowed(bytes32,bytes32,bytes32,bytes32,bool,bool) (runs: 1001, μ: 536848, ~: 537518)<br>
[PASS] testFuzz_DeleteLocalNode(address,bytes32,bytes32) (runs: 1001, μ: 21092, ~: 21092)<br>
[PASS] testFuzz_DeleteNode(address,bytes32,bytes32) (runs: 1001, μ: 307004, ~: 329069)<br>
[PASS] testFuzz_GetNodeAndPagination(address,bytes32,bytes32,uint256,uint256) (runs: 1001, μ: 322046, ~: 322067)<br>
[PASS] testFuzz_UpdateLocalNodeStatus(address,bytes32,bytes32,bool) (runs: 1001, μ: 21344, ~: 21344)<br>
Suite result: ok. 6 passed; 0 failed; 0 skipped; finished in 909.54ms (2.19s CPU time)<br><br>

Ran 9 tests for test/OrganizationImplTest.t.sol:OrganizationImplTest <br>
[PASS] testDeleteWithTwoOrganizations() (gas: 39574)<br>
[PASS] testFuzz_AddOrganization(address,string,string,bool) (runs: 1001, μ: 170446, ~: 228686)<br>
[PASS] testFuzz_AddOrganization_partnercantvote(address,string,string) (runs: 1001, μ: 62951, ~: 73463)<br>
[PASS] testFuzz_DeleteOrganization(uint256,address) (runs: 1001, μ: 360051, ~: 371145)<br>
[PASS] testFuzz_GetOrganization(uint256) (runs: 1001, μ: 17357, ~: 17264)
[PASS] testFuzz_UpdateOrganization_forAssoociate(address,uint256,string,string,bool) (runs: 1001, μ: 66107, ~: 76429)<br>
[PASS] testFuzz_UpdateOrganization_forPartner(address,uint256,string,string) (runs: 1001, μ: 65372, ~: 53740)<br>
[PASS] testFuzz_UpdateOrganization_forPatron(address,uint256,string,string,bool) (runs: 1001, μ: 65817, ~: 53859)<br>
[PASS] testTryingToDeleteOrganizationWithUnauthorizedAddr() (gas: 20002)
Suite result: ok. 9 passed; 0 failed; 0 skipped; finished in 909.70ms (2.59s CPU time)<br>