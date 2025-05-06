# *Smart Contracts* de Permissionamento da RBB - Segunda Geração (gen02)

## Ambiente de desenvolvimento

### Preparação do ambiente

Para baixar as dependências:

```shell
npm install
```


### Construção e testes

Para compilar os *smart contracts* (script configurado no `package.json`):

```shell
npm run compile
```

Para executar os testes automatizados:

```shell
npm test
```

**Observação**: Os testes são baseados em cenários, descritos **em linguagem natural**, utilizando a sintaxe [Gherkin](https://cucumber.io/docs/gherkin/). Os cenários podem ser encontrados na pasta [features](features).


### Debug

#### Cucumber

https://github.com/cucumber/cucumber-js/blob/main/docs/debugging.md

Ajustar variável de ambiente `DEBUG=cucumber`


#### Hardhat

https://hardhat.org/hardhat-runner/docs/troubleshooting/verbose-logging

Ajustar variável de ambiente `HARDHAT_VERBOSE=true`


#### Log nos *smart contracts*

O Hardhat permite utilizar função de log na console, de forma análoga ao Javascript (ver referência abaixo).

Exemplo:
```
import "hardhat/console.sol";

...

console.log("Parametros %s e %s", p1, p2);
```

**ATENÇÃO**: Esse recurso deve ser usado apenas em testes locais, de forma temporária. Tal recurso **não** pode ser usado para utilização efetiva no código final. **Remova quaisquer referências do tipo antes de fazer commit do código**.


### Implantação Local no Hardhat

1. Inicie o Hardhat:

```shell
npx hardhat node
```

2. Abra outro terminal/console.

3. Defina a variável de ambiente `CONFIG_PARAMETERS` contendo o caminho do arquivo com os parâmetros de configuração. Para o caso de implantação local no Hardhat, o arquivo [`deploy/parameters-hardhat.json`](deploy/parameters-hardhat.json) já foi preparado.

O ajuste da variável de ambiente pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal:

```shell
set CONFIG_PARAMETERS=deploy/parameters-hardhat.json
```

4. Implante o contrato *mock* de [`AdminProxy`](contracts/AdminProxy.sol):

```shell
npm run hardhat-deploy-admin-mock
```

Ao final da implantação, guarde o endereço onde foi implantado o contrato `AdminMock`:

```
Implantando AdminMock
 AdminMock implantado no endereço 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

**Observação**: Para efeitos de teste local da gen02 no Hardhat, não é necessário implantar a gen01. Mas é necessário ter um contrato de `AdminProxy`. Por isso esse mock se faz necessário.

5. Copie o endereço do contrato `AdminMock` no arquivo [`deploy/parameters-hardhat.json`](deploy/parameters-hardhat.json), no parâmetro `adminAddress`:

```
{
    "adminAddress": "0x5FbDB2315678afecb367f032d93F642f64180aa3
    ...
}
```

6. Implante os contratos de permissionamento:

```shell
npm run hardhat-deploy-gen02
```


### Implantação Local no Besu

Este projeto já contém pronta a configuração de um nó Besu validator. Para enter como esse foi preparado e funciona localmente, veja o documento [besu.md](../besu.md).

1. Inicie o Besu:

```shell
besu --config-file besu/config.toml
```

2. Abra outro terminal/console.

3. Defina as seguintes variáveis de ambiente:
   1. `CONFIG_PARAMETERS`: Caminho do arquivo com os parâmetros de configuração. Para o caso de implantação local no Besu, o arquivo [`deploy/parameters-local.json`](deploy/parameters-local.json) já foi preparado.
   2. `ACCOUNT_ADDRESS`: Endereço da conta a ser usada para envio de transações.
   3. `PRIVATE_KEY`: Chave privada da conta a ser usada para envio de transações.
   4. `ALT_PRIVATE_KEYS`: **Opcional**. Lista com chaves privadas alternativas, separadas por vírgulas, que podem ser usadas em scripts para simular o envio de transações por outras contas.

O ajuste das variáveis de ambiente pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal. Exemplo:

```shell
set CONFIG_PARAMETERS=deploy/parameters-local.json
set ACCOUNT_ADDRESS=0x71bE63f3384f5fb98995898A86B02Fb2426c5788
set PRIVATE_KEY=0x701b615bbdfb9de65240bc28bd21bbc0d996645a3dd57e7b12bc2bdf6f192c82
```

4. A gen02 foi feita para trabalhar com base em contratos da gen01. Portanto, algumas dependências são necessárias para que funcione corretamente. Nesse ponto, deve-se optar por:
   1. Implantar e utilizar a gen01 por completo (sendo que os contratos de [`NodeIngress`](../gen01/contracts/NodeIngress.sol) e [`AccountIngress`](../gen01/contracts/AccountIngress.sol) da gen01 já são implantados automaticamente via arquivo [genesis](../besu/genesis.json)). Nesse caso, vá para o passo 5.
   2. Implantar e utilizar o contrato *mock* de `AdminProxy`. Nesse caso, vá para o passo 6.


5. **Caso vá utilizar a gen01**, veja o procedimento de implantação no documento [README.md](../gen01/README.md) do projeto da gen01.

Ao final da implantação, guarde o endereço onde foi implantado o contrato `Admin`:

```
Validation step finished
   > Admin contract deployed with address = 0x72bb9c7ffbE2Ed234e53bc64862DdA6d9fFF333b
```
   
6. **Caso NÃO vá utilizar a gen01**, implante o contrato *mock* de [`AdminProxy`](contracts/AdminProxy.sol):

```shell
npm run local-deploy-admin-mock
```

Ao final da implantação, guarde o endereço onde foi implantado o contrato `AdminMock`:

```
Implantando AdminMock
 AdminMock implantado no endereço 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

7. Copie o endereço do contrato de `Admin` ou `AdminMock` no arquivo [`deploy/parameters-local.json`](deploy/parameters-local.json), no parâmetro `adminAddress`:

```
{
    "adminAddress": "0x5FbDB2315678afecb367f032d93F642f64180aa3
    ...
}
```

8. Implante os contratos da gen02:

```shell
npm run local-deploy-gen02
```

Ao final da implantação, copie os endereços dos contratos de `OrganizationImpl`, `AccountRulesV2Impl`, `NodeRulesV2Impl` e `Governance`:

```
Implantando smart contract de gestão de organizações
 OrganizationImpl implantado no endereço 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
Implantando smart contract de gestão de contas
 AccountRulesV2Impl implantado no endereço 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
Implantando smart contract de gestão de nós
 NodeRulesV2Impl implantado no endereço 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
Implantando smart contract de governança
 Governance implantado no endereço 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
```

9. Copie os endereços dos contratos da gen02 no arquivo [`deploy/parameters-local.json`](deploy/parameters-local.json), nos parâmetros `adminAddress`:

```
{
    ...
    "organizationAddress": "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    "accountRulesV2Address": "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9",
    "nodeRulesV2Address": "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
    "governanceAddress": "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
    ...
}
```

#### Migração da gen01 para a gen02:

O procedimento recomendado de migração da gen01 para a gen02 está descrito no documento de [macroprocessos](doc/macroprocessos.md).


### Implantação na Rede Lab


### Implantação na Rede Piloto


## Referências

- [HardHat](https://hardhat.org/hardhat-runner/docs/getting-started)
- [Creating Ingnition Modules](https://hardhat.org/ignition/docs/guides/creating-modules)
- [Deploying your contracts](https://hardhat.org/hardhat-runner/docs/guides/deploying)
- [Deploying a module](https://hardhat.org/ignition/docs/guides/deploy)
- [Hardhat Network](https://hardhat.org/hardhat-network/docs/overview)
- [hardhat-ethers helpers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers#helpers)
- [Testing contracts](https://hardhat.org/hardhat-runner/docs/guides/test-contracts)
- [Debugging with Hardhat Network](https://hardhat.org/tutorial/debugging-with-hardhat-network)
  - console.log [overview](https://hardhat.org/hardhat-network/docs/overview#console.log)
  - console.log [reference](https://hardhat.org/hardhat-network/docs/reference#console.log)
- [Cucumber JS](https://github.com/cucumber/cucumber-js)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/)
- [Hardhat-Ethers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers)
- [Ethers API](https://docs.ethers.org/v6/single-page/#api)
- Mocha - [Assertions](https://mochajs.org/#assertions)
- Node.js - [Assert](https://nodejs.org/api/assert.html)
- [Role-Based Access Control](https://docs.openzeppelin.com/contracts/2.x/access-control#role-based-access-control)
