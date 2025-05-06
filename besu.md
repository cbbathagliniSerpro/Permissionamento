# Executando uma rede de bancada com o Besu

Caso se queira executar uma rede de bancada, com um único nó validator, pode-se usar a configuração já preparada na pasta [`besu`](besu). Para tanto, basta iniciar o Besu da seguinte maneira:

```shell
besu --config-file besu/config.toml
```

Observações:
- É preciso ter o Besu disponível no *path* da console.
- É preciso ter o Java instalado.
- Ao executar no Windows, pode ser necessário incluir a extensão `.bat` ao executar o comando.

Todos os dados serão gerados na pasta `besu/node-data`. Esta pasta será ignorada pelo git.

Sempre que se queira "zerar" ou reiniciar a blockchain, basta parar o Besu, apagar a pasta `besu/node-data` e reiniciar o Besu.


## Preparação do nó Besu de bancada

Esta seção existe apenas para fins de documentação sobre como o nó de bancada foi preparado e *não precisa ser repetida*.

1. Criada a chave privada e exportada a chave pública: `besu --data-path=besu public-key export --to=besu/key.pub`
2. Exportada a identificação do nó: `besu --data-path=besu public-key export-address --to=besu/node.id`
3. Criado o arquivo `extraData.json`, contendo esse único nó como validator da rede.
4. "Extra data" foi convertido para ser adicionado ao `genesis.json`: `besu rlp encode --from=besu/extraData.json --type=QBFT_EXTRA_DATA`
5. Criado `genesis.json` a partir do arquivo [gênesis da RBB](https://github.com/RBBNet/rbb/blob/master/artefatos/observer/genesis.json)
6. Criado arqruivo `config.toml` com base na [configuração Docker da RBB](https://github.com/RBBNet/start-network/blob/main/docker-compose.yml.hbs)