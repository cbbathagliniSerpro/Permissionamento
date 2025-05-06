# *Smart Contracts* de Permissionamento da RBB

A RBB é uma rede público-permissionada, sendo necessário que certas restrições de acesso sejam aplicadas à rede. Mais especificamente, a RBB utiliza o padrão ["Permissioned Blockchains Specification" (v1)](https://entethalliance.org/wp-content/uploads/2020/06/EEA_Enterprise_Ethereum_Chain_Specification_V1_2800229.pdf), da Enterprise Ethereum Alliance (EEA) para que as regras de permissionamento sejam feitas *on chain*. Mais informações sobre permissionamento podem ser obtidas no [site do Besu](https://besu.hyperledger.org/private-networks/concepts/permissioning).

Este repositório contém o código utilizado para esse permissionamento, em suas várias gerações de evolução. Mais informações podem ser obtidas nos READMEs das pastas de cada geração.

## Primeira geração

Na pasta [`gen01`](gen01) temos a primeira geração de smart contracts de permissionamento, implantada originalmente no início de operação da RBB, incluindo os *smart contracts* [`AccountIngress`](gen01/contracts/AccountIngress.sol) e [`NodeIngress`](gen01/contracts/NodeIngress.sol), constantes no arquivo [genesis](https://github.com/RBBNet/rbb/blob/master/artefatos/observer/genesis.json) da rede. A primeira geração de *smart contracts* basicamente contém os *proxies* `AccountIngress` e `NodeIngress`, que permitem o "reponteiramento" de regras, as regras de acesso para contas e nós e a gestão de contas de administração.


## Segunda geração

Na pasta [`gen02`](gen02) temos a segunda geração de smart contracts de permissionamento, contemplando mais conceitos e funcionalidades mais elaboradas para a gestão de acesso, como a gestão de organizações, definição de perfis de acesso e procedimentos de governança através de votações.

## Esquema de Permissionamento da RBB

![Esquema de permissionamento da RBB](esquema-permissionamento.png "Esquema de permissionamento da RBB")