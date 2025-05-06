# language: pt

Funcionalidade: Paginação de dados
  Para permitir consultas eficientes de grandes conjuntos de dados
  Como desenvolvedor
  Eu quero usar uma biblioteca de paginação que suporte diferentes tipos de dados

  Contexto:
    Dado que o contrato PaginationMock está implantado

  Esquema do Cenário: Paginação de números com diferentes configurações
    Dado que existem <total> números sequenciais no conjunto de teste
    Quando solicito a página <pagina> com tamanho <tamanho>
    Então devo receber <qtdResultados> números
    E o primeiro número retornado deve ser <primeiroNumero>
    E o último número retornado deve ser <ultimoNumero>

    Exemplos:
      | total | pagina | tamanho | qtdResultados | primeiroNumero | ultimoNumero |
      | 10    | 1      | 3       | 3             | 1              | 3            |
      | 10    | 2      | 3       | 3             | 4              | 6            |
      | 10    | 3      | 3       | 3             | 7              | 9            |
      | 10    | 4      | 3       | 1             | 10             | 10           |
      | 10    | 5      | 3       | 0             | -              | -            |
      | 5     | 1      | 10      | 5             | 1              | 5            |
      | 5     | 2      | 10      | 0             | -              | -            |

  Cenário: Paginação de endereços
    Dado que existem 5 endereços aleatórios no conjunto de teste
    Quando solicito a página 1 de endereços com tamanho 3
    Então devo receber 3 endereços
    Quando solicito a página 2 de endereços com tamanho 3
    Então devo receber 2 endereços

  Cenário: Paginação com parâmetros inválidos
    Dado que existem 5 números sequenciais no conjunto de teste
    Quando tento solicitar a página 0 com tamanho 3
    Então deve ocorrer erro "InvalidPaginationParameter"
    Quando tento solicitar a página 1 com tamanho 0
    Então deve ocorrer erro "InvalidPaginationParameter"

  Cenário: Conjunto vazio de dados
    Dado que o conjunto de números está vazio
    Quando solicito a página 1 com tamanho 5
    Então devo receber 0 números

  Cenário: Cálculo dos limites de página para arrays
    Dado que o contrato PaginationMock está implantado
    Quando calculo os limites da página 2 com tamanho 5 para um total de 13 itens
    Então o início deve ser 5 e o fim deve ser 10
    Quando calculo os limites da página 3 com tamanho 5 para um total de 13 itens
    Então o início deve ser 10 e o fim deve ser 13
    Quando calculo os limites da página 4 com tamanho 5 para um total de 13 itens
    Então o início deve ser 0 e o fim deve ser 0