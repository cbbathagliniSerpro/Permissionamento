
# 🔍 Auditoria com Hardhat

Hardhat é uma das ferramentas mais populares para o desenvolvimento de smart contracts no Ethereum. Ele oferece um ambiente integrado para escrever, compilar, testar e implantar contratos Solidity. 

## 📥 Instalar Dependências

Antes de rodar os testes, instale as dependências com:

```bash
npm install
```

## 🧪 Testes Unitários

Os testes unitários estão localizados na pasta:
```bash
auditoria/hardhat/test
```

Execute os testes com os seguintes comandos:
```bash
npx hardhat test test/Governance.test.js
npx hardhat test test/OrganizationImpl.test.js
npx hardhat test test/AccountRulesV2Impl.test.js
npx hardhat test test/NodeRulesV2Impl.test.js
npx hardhat test test/Pagination.test.js
```

## 🧬 Testes de Mutação

Para executar testes de mutação, utilize o script:
```bash
python mutation_tester.py path/to/YourContract.sol
```

Execute os testes de mutação com os seguintes comandos:
```bash
python mutation_tester.py contracts/Governance.sol
python mutation_tester.py contracts/OrganizationImpl.sol
python mutation_tester.py contracts/AccountRulesV2Impl.sol
python mutation_tester.py contracts/NodeRulesV2Impl.sol
python mutation_tester.py contracts/Pagination.sol
```

Certifique-se de substituir path/to/YourContract.sol pelo caminho correto do contrato que deseja testar.

✅ Dica: Sempre garanta que todos os testes passem antes de rodar a análise com Slither ou realizar testes de mutação!