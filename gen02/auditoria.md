# Auditoria de *smart contracts*

## Preparação de ambiente

Criando um *virtual environment* do instalador de pacotes do Python (PIP):
```
python3 -m venv .
```


## Slither

Instalando o Slither:
```
python3 -m pip install slither-analyzer
```

Executanto a auditoria:
```
slither .
```


## Mythril

Instalando o Mythril:
```
python3 -m pip install mythril
```

Executanto a auditoria:
```
myth analyze <solidity-file> --solc-json mythril-solc.json
```

Exemplos:
```
# myth analyze contracts/AccountRulesV2Impl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/Governance.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/NodeRulesV2Impl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/OrganizationImpl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.
```


### Referências

- [PIP virtual environments](https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-and-using-virtual-environments)
- [Slither](https://github.com/crytic/slither)
- [Mythril](https://github.com/ConsenSys/mythril)
