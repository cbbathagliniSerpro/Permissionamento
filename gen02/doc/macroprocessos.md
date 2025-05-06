# Macroprocessos da RBB

# Entrada de uma nova organização

Procedimento:
1. Nova organização cria as chaves para uma nova conta de Administrador Global.
2. Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Inclusão de organização
   2. Inclusão de Administrador Global da nova organização, com o endereço gerado
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza novos cadastros.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Saída de uma organização

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para votação de exclusão da organização.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a exclusão da organização.
4. Todas as contas e nós vinculados tornam-se intrinsecamente inativos.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Cadastro de novo Administrador Global

Procedimento:
1. Organização do novo Administrador Global gera par de chaves.
2. Administrador Global (de qualquer organização) cria proposta para votação do cadastro do novo Administrador Global para a referida organização, informando novo endereço gerado e sua organização.
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza cadastro.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Exclusão de Administrador Global

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para votação da exclusão de um Administrador Global, informando o respectivo endereço.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza exclusão.

**Observação**: **Não** é possível excluir uma conta caso ela seja a única conta de Administrador Global de uma organização. Caso se deseje realmente excluir esse único Administrador Global, antes deve-se cadastrar um novo Administrador Global. Ver o macroprocesso a seguir.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Perda de chave privada de Administrador Global / "Substituição" de Administrador Global

Procedimento:
1. Organização que perdeu a chave privada gera novo par de chaves.
2. Outro Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Cadastro de novo Administrador Global para a referida organização, informando novo endereço gerado
   2. Exclusão do Administrador Global cuja chave foi perdida
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a "substituição" de contas.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Restrição de acesso a *smart contract*

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para restringir acesso de *smart contract*, informando o endereço do contrato e eventuais contas que possam realizar o acesso restrito.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a restrição de acesso.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Remoção de restrição de acesso a *smart contract*

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para remover restrição de acesso a *smart contract*, informando o endereço do contrato.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança remove a restrição de acesso.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Cancelamento de uma proposta

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para cancelar uma outra proposta já existente, informando o identificador dessa outra proposta e o motivo do cancelamento.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança cancela a outra proposta, impedindo-a de receber votos e ser executada.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Implantação da segunda geração de permissionamento

**Observação**: No contexto deste macroprocesso, deve-se entender o termo **Administrador Master** como uma conta cadastrada no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento. E o termo **Administrador Global** deve ser entendido como uma conta cadastrada no *smart contract* [`AccountRulesV2`](../contracts/AccountRulesV2.sol) da **segunda geração** do permissionamento, com o perfil de acesso de gestão global da RBB.

Procedimento:
1. Organizações devem criar chaves para suas contas de Administradores Globais.
   - **As chaves privadas devem ser mantidas com alto rigor de segurança**.
2. Administrador Master permissiona as novas contas de Administradores Globais **na Gen01 como contas transacionais**.
   - Estas contas **não** devem ser permissionadas como Administradores Master.
   - Este permissionamento é necessário para que estes administradores possam enviar votos (para aprovação de propostas) ainda com o permissionamento de Gen01 valendo.
3. Administrador Master implanta Gen02:
   1. Implantação dos *smart contracts* de: organizações; contas; nós; e governança/votação.
      1. São configuradas as referências entre os *smart contracts*.
      2. São pré-cadastradas:
         1. Organizações participantes (necessário para as que têm nó).
         2. Um único Administrador Global para cada organização (outros Administradores Globais podem ser adicionados posteriormente).
      3. ***Smart contract* de governança é cadastrado como Administrador Master.**
         - Apenas um Administrador Master pode adicionar um outro Administrador Master.
   2. Testes automatizados para validar o permissionamento dos Administradores Globais (`transactionAllowed()`).
4. Administradores Globais verificam e complementam cadastros de suas próprias organizações:
   1. Novas contas podem ser cadastradas.
   2. Os nós das organizações **têm** que ser cadastrados.
   3. Testes automatizados para validar o permissionamento de contas (`transactionAllowed()`).
   4. Testes automatizados para validar o permissionamento de nós (`connectionAllowed()`).
   - **Este passo é essencial antes do reponteiramento do permissionamento.**
5. Caso necessário, novos Administradores Globais podem ser cadastrados.
   1. Um administrador Global (de qualquer organização) cria proposta para cadastramento dos novos Administradores Globais.
   2. Organizações participantes votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização participante) executa a proposta aprovada.
6. Cadastramento das organizações que não têm nó implantado.
   1. Um administrador Global (de qualquer organização) cria proposta para cadastramento das organizações que não têm nó implantado.
   2. Organizações participantes votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização participante) executa a proposta aprovada.
   - Este passo pode ser feito paralelamente ao passo anterior, caso necessário, sem prejuízos.
   - A ideia de cadastrar essas organizações é para dar transparência ao público sobre quem faz parte da RBB. Ao mesmo tempo, pode-se já testar e exercitar o mecanismo de governança.
   - As organizações são cadastradas **sem** administrador global e **sem** direito a voto, mesmo que sejam partícipes associados.
   - **Não** é necessário que sejam cadastrados Administradores Globais para estas organizações.
     - Porém, caso algum Administrador Global seja cadastrado, **a chave privada deverá ser mantida com alto rigor de segurança**.
     - Após o cadastramento do primeiro Administrador Global de uma organização, deverá sempre existir ao menos um Administrador Global.
7. Reponteiramento dos *smart contracts* de regras (rules):
   1. Um administrador Global (de qualquer organização) cria proposta com os seguintes passos: 
      1. Reponteiramento das regras de nós (`NodeIngress`) para o novo *smart contract* de gestão nós.
      2. Reponteiramento das regras de contas (`AccountIngress`) para o novo *smart contract* de gestão de contas.
   2. Organizações participantes votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização participante) executa a proposta aprovada.
- **As regras de Administrador Master permanecerão inalteradas**, sendo administradas através de uma lista de endereços no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
  - Só estes Administradores Master podem realizar o reponteiramento.
  - Só estes Administradores Master poderão executar certas funções dos *smart contracts* da segunda geração.
8. Remoção de todas as contas Administrador Master, deixando ativa apenas a conta do *smart contract* de governança/votação:
   1. Um administrador Global (de qualquer organização) cria proposta para remover todas as demais contas de Administrador Master.
      - **Observação**: Um Administrador Master não pode remover a si mesmo, portanto é necessário haver a execução da exclusão via Governança.
   2. Organizações participantes votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização participante) executa a proposta aprovada.
   - Nesse momento, todas as demais contas Administrador Master são removidas.
   - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança/votação será Administrador Master (no conceito da primeira geração do permissionamento) e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).
9. Testes:
   1. Verificações.
   2. Diagnósticos.

Implementação:
- Passo 2 - Por se tratar de ação na gen01, deve-se utilizar as [ferramentas já existentes](https://github.com/RBBNet/scripts-permissionamento/) para essa geração do permissionamento.
- Passo 3:
  - 3.1 - [deploy-gen02.js](../deploy/deploy-gen02.js)
    - Parâmetros:
      - `adminAddress`: Endereço do *smart contract* `Admin` da gen01.
      - `organizations`: Lista de organizações a serem pré-cadastradas.
      - `globalAdmins`: Lista dos endereços a serem pré-cadastrados como Administradores globais das organizações.
      - As listas `organizations` e `globalAdmins` devem estar "sincronizadas". Isto é, o enésimo endereço será o Administrador Global da enésima organização.
  - 3.2 - [test-admins-gen02.js](../deploy/test-admins-gen02.js)
    - Parâmetros: 
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `globalAdmins`: Lista dos endereços a serem pré-cadastrados como Administradores globais das organizações.
- Passo 4:
  - 4.1 - [add-accounts-gen02.js](../deploy/add-accounts-gen02.js)
    - Parâmetros: 
      - `organizationAddress`: Endereço do *smart contract* de `OrganizationImpl`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `accounts`: Lista de contas a serem cadastradas.
  - 4.2 - [add-nodes-gen02.js](../deploy/add-nodes-gen02.js)
    - Parâmetros: 
      - `organizationAddress`: Endereço do *smart contract* de `OrganizationImpl`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
      - `nodes`: Lista de nós a serem cadastrados.
  - 4.3 - [test-accounts-gen02.js](../deploy/test-accounts-gen02.js)
    - Parâmetros: 
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `accounts`: Lista de contas a serem testadas.
  - 4.4 - [test-nodes-gen02.js](../deploy/test-nodes-gen02.js)
    - Parâmetros: 
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
      - `nodes`: Lista de nós a serem testados.
- Passo 5, caso necessário:
  - 5.1 - [create-proposal-add-global-admins.js](../deploy/create-proposal-add-global-admins.js)
    - Parâmetros:
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `newGlobalAdmins`: Lista de endereços a serem cadastrados, com as identificações das respectivas organizações.
  - 5.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 5.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 6:
  - 6.1 - [create-proposal-add-new-orgs.js](../deploy/create-proposal-add-new-orgs.js)
    - Parâmetros:
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
      - `organizationAddress`: Endereço do *smart contract* de `OrganizationImpl`, conforme implantado no passo 2.
      - `newOrganizations`: Lista com os nomes das organizações a serem cadastradas.
  - 6.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 6.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 7:
  - 7.1 - [create-proposal-mig-gen02.js](../deploy/create-proposal-mig-gen02.js)
    - Parâmetros:
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
  - 7.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 7.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 8:
  - 8.1 - [create-proposal-remove-admins.js](../deploy/create-proposal-remove-admins.js)
  - 8.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 8.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 9:
  - 9.1 - [verify-governance.js](../deploy/verify-governance.js)
    - Parâmetros:
      - `adminAddress`: Endereço do *smart contract* `Admin` da gen01.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 9.2 - [permissioning-diagnostics.js](../deploy/permissioning-diagnostics.js).
    - Parâmetros:
      - `adminAddress`: Endereço do *smart contract* `Admin` da gen01.
      - `organizations`: Lista de organizações a serem pré-cadastradas.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
    - **Observação**: A partir da implantação da gen02 (passo 2), é possível realizar estes diagnósticos do permissionamento a qualquer momento.

**Observações**:
- Os scripts devem ser executados via Hardhat, através dos "scripts" cadastrados na propriedade `scripts` no [package.json](../package.json) deste projeto.
- Deve-se usar o "script" correto de acordo com o ambiente e rede desejadas.
  - Por exemplo, para o ambiente local em rede Besu, usar os scripts `local-xxx`.
  - As redes previstas estão definidas na propriedade `networks` do arquivo [hardhat.config.js](../hardhat.config.js).
- Os scripts dependem de parâmetros configurados em arquivos JSON.
  - A localização deste arquivo deve estar configurada na variável de ambiente `CONFIG_PARAMETERS`.
  - Alguns arquivos de parâmetros de exemplo já existem na pasta [deploy](../deploy), como por exemplo o [parameters-local.json](../deploy/parameters-local.json).
- A conta com a qual o script será usado, e sua respectiva chave privada, devem ser configuradas nas variáveis de ambiente `ACCOUNT_ADDRESS` e `PRIVATE_KEY`.
  - Cada organização deverá configurar essas variáveis de forma apropriada, com sua conta de Administrador Global (ou Administrador Master, quando for o caso).
- As variáveis de ambiente, caso desejado, podem ser configuradas em arquivo local `.env`, na pasta da `gen02`.


# Implantação de novo permissionamento (terceira geração em diante)

De acordo com a implantação da segunda geração de permissionamento, somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
1. Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
2. Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. O reponteiramento é realizado.

Este procedimento pode ser testado através do script [migrate-to-gen03-mock.js](../deploy/migrate-to-gen03-mock.js).


# Implantação de novo mecanismo de governança/votação

Procedimento:
1. Novo *smart contract* de governança/votação é implantado.
2. Administrador Global (de qualquer organização) cria proposta para adicionar o novo *smart contract* como Administrador Master
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança configura novo *smart contract* como Administrador Master.
5. Novo *smart contract* deve ser acionado, conforme suas regras de funcionamento, para remover o *smart contract* da segunda geração como Administrador Master.

Este procedimento pode ser testado através do script [migrate-governance-mock.js](../deploy/migrate-governance-mock.js).
**Observação**: Este procedimento foi testado tendo-se a gen02 em vigor. **Não** foi realizado teste de migração da governança com uma geração diferente (Ex.: mock de gen03) de permissionamento.