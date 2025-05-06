# Nós

## USNOD01 - Administrador cadastra novo nó de sua organização para que receba permissão para se conectar à RBB<a id="usnod01"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar o cadastro.
2. O administrador informa o endereço do nó, seu nome e seu tipo.
3. O nó não pode já estar cadastrado.
4. O nome e o tipo informados devem ser válidos.
5. O nó é criado e vinculado à organização do administrador solicitante.
6. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização
   3. O tipo do nó
   4. O nome do nó


## USNOD02 - Administrador exclui nó de sua organização para que não possa mais se conectar à RBB<a id="usnod02"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem excluir nós.
2. O administrador informa o endereço do nó a ser excluído.
3. O nó informado deve ser válido.
4. O administrador somente pode excluir nós vinculados à sua organização.
5. O nó é excluído.
6. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização

  
## USNOD03 - Administrador altera cadastro de nó de sua organização para manter informações atualizadas<a id="usnod03"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem alterar o cadastro de nós.
2. O administrador informa o endereço, nome e tipo do nó a ser alterado.
3. O nó informado deve ser válido.
4. O administrador somente pode alterar nós vinculados à sua organização.
5. O nome e o tipo informados devem ser válidos.
6. O novo nome e tipo são alterados no cadastro do nó.
7. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização
   3. O novo tipo do nó
   4. O novo nome do nó


## USNOD04 - Administrador altera situação de nó da sua organização para que perca temporariamente ou para que readquira possibilidade de conexão à rede<a id="usnod04"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço do nó a ser alterado e a situação desejada (ativo ou inativo).
3. O nó informado deve ser válido.
4. O administrador somente pode alterar nós vinculados à sua organização.
5. A situação do nó é alterada.
6. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização
   3. A nova situação do nó


## USNOD05 - Governança cadastra novo nó para que receba permissão para se conectar à RBB<a id="usnod05"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar o cadastro.
2. São informados o identificador da organização responsável pelo nó, seu endereço, seu nome e seu tipo.
3. A organização responsável, o nome e o tipo informados devem ser válidos.
4. O nó não pode já estar cadastrado.
5. O nó é criado, associado à organização indicada e com o nome e tipo indicados.
6. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização
   3. O tipo do nó
   4. O nome do nó


## USNOD06 - Governança exclui nó para que não possa mais se conectar à RBB<a id="usnod06"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a exclusão.
2. É informado o endereço do nó a ser excluído.
3. O nó informado deve ser válido.
4. O nó é excluído.
5. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço do nó
   2. O identificador da organização


## USNOD07 - Observador verifica se nó está ativo para saber se pode se conectar à RBB<a id="usnod07"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o endereço do nó a ser verificado.
3. Caso a organização a qual o nó está vinculado esteja ativa e o nó esteja ativo, retorna-se que o nó se encontra ativo.
   1. Em qualquer outra situação, indica-se que o nó se encontra inativo.
   2. Caso o endereço não corresponda a um nó existente, também se indica resposta de nó inativo.


## USNOD08 - Observador consulta nó para obter seus dados cadastrais<a id="usnod08"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço do nó a ser consultado.
3. São retornados o endereço, o nome, o tipo, a organização responsável e a situação do nó correspondente.


## USNOD09 - Besu verifica permissão de acesso de nós para decidir se uma conexão pode ser realizada<a id="usnod09"></a>

Critérios de aceitação:
1. Besu informa endereços dos nós a se conectarem.
2. Somente nós cadastrados, ativos e vinculados a organizações ativas podem realizar conexões entre si.
3. A conexão só é permitida caso ambos os nós tenham permissão. Caso contrário, a conexão é negada.


## USNOD10 - Observador consulta o número total de nós para poder preparar paginação de dados<a id="usnod10"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador solicita o número total de nós existentes.
3. A quantidade total de nós é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USNOD11 - Observador consulta nós para obter seus dados cadastrais<a id="usnod11"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros de paginação para consultar todos os nós cadastrados:
   1. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   2. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os dados cadastrais de nós correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.


## USNOD12 - Observador consulta o número de nós de uma organização para poder preparar paginação de dados<a id="usnod12"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa identificador de uma organização.
3. A quantidade de nós da organização informada é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USNOD13 - Observador consulta nós de uma organização para obter seus dados cadastrais<a id="usnod13"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros para realização da consulta:
   1. Identificador da organização desejada.
   2. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   3. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os dados cadastrais de nós da organização informada, correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.
