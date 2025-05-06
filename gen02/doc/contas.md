# Contas

## USACC01 - Administrador cadastra nova conta de sua organização para que possa enviar transações à rede ou executar funcionalidades de permissionamento no âmbito de sua própria organização<a id="usacc01"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar o cadastro.
2. O administrador informa o endereço, papel desejado e um hash dos dados cadastrais da conta mantidos *off chain* pela organização.
3. A conta não pode já estar cadastrada.
4. O papel informado deve ser válido e não pode ser de Administrador Global.
5. O hash dos dados cadastrais da conta não pode estar vazio/zerado.
6. A conta é criada e vinculada à organização do administrador solicitante.
7. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O papel
   4. O hash dos dados cadastrais


## USACC02 - Administrador exclui conta de sua organização para que não possa mais enviar transações à rede ou executar funcionalidades de permissionamento no âmbito de sua própria organização<a id="usacc02"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem excluir contas.
2. O administrador informa o endereço da conta a ser excluída.
3. O administrador somente pode excluir contas vinculadas à sua organização.
4. O papel da conta a ser excluída não pode ser de Administrador Global.
5. A conta é excluída.
6. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização


## USACC03 – Administrador altera uma conta de sua organização para modificar privilégios de acesso e/ou manter informação de auditoria atualizada<a id="usacc03"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço da conta, o novo papel e o novo hash cadastral a serem atribuídos.
3. O administrador somente pode alterar contas vinculadas à sua organização.
4. O papel informado deve ser válido.
5. A alteração não pode envolver o papel de Administrador Global, seja no estado original ou no estado final da alteração.
6. O hash dos dados cadastrais não pode estar vazio/zerado, caso o novo papel da conta seja diferente de Administrador Local.
7. O novo papel e o novo hash são atribuídos à conta.
8. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O novo papel informado para a conta
   4. O novo hash informado para a conta


## ~~USACC04~~


## USACC05 – Administrador altera situação de conta da sua organização para que perca temporariamente ou para que readquira privilégios de acesso<a id="usacc05"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço da conta a ser alterada e a situação desejada (ativa ou inativa).
3. O administrador somente pode alterar contas vinculadas à sua organização.
4. A alteração não pode ser para uma conta com papel de Administrador Global.
5. A situação da conta é alterada.
6. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. A nova situação informada para a conta


## USACC06 - Governança cadastra nova conta para que possa ser usada no envio de transações à RBB ou executar funcionalidades de permissionamento<a id="usacc06"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar o cadastro.
2. São informados o identificador da organização responsável pela conta, o endereço, o papel desejado e um hash dos dados cadastrais da conta mantidos *off chain* pela organização.
3. A organização responsável e o papel desejado devem ser válidos.
4. O hash dos dados cadastrais da conta não pode estar vazio/zerado, caso o papel da conta seja diferente de Administrador Global e Administrador Local.
5. A conta não pode já estar cadastrada.
6. A conta é criada e vinculada à organização informada.
7. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O papel
   4. O hash dos dados cadastrais


## USACC07 - Governança exclui conta para que não tenha mais acesso à RBB<a id="usacc07"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a exclusão.
2. É informado o endereço da conta a ser excluída.
3. A conta informada deve ser válida.
4. A exclusão só pode ocorrer se ao menos uma conta com papel Administrador Global permanecer ativa para a organização da conta a ser excluída.
5. A conta é excluída.
6. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização


## USACC08 - Governança configura o acesso a *smart contract* para que sua execução possa ser desativada, restrita a um conjunto determinado de endereços ou liberada para qualquer endereço<a id="usacc08"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a configuração.
2. São informados:
   1. O endereço do *smart contract* a ter seu acesso configurado.
   2. Se o acesso deve ser restringido ou não.
   3. No caso de haver restrição, a lista de endereços com permissão de acesso.
      1. A lista de endereços é opcional.
      2. Caso seja indicada restrição de acesso e a lista não seja informada, o *smart contract* ficará completamente inacessível (desativado).
3. Caso seja indicada limitação de acesso, o endereço do *smart contract* é adicionado à lista de *smart contracts* com restrição de acesso, juntamente com os endereços permitidos (se houver), para restringir a execução do *smart contract*.
4. Caso **não** seja indicada limitação de acesso, o endereço do *smart contract* é removido da lista de *smart contracts* com restrição de acesso, liberando completamente, para qualquer chamador, a execução do *smart contract*.
5. A ocorrência da configuração deve emitir um evento, registrando:
   1. O endereço do *smart contract*
   2. Se foi configurada restrição de acesso
   3. Lista de endereços com acesso permitido


## USACC09 - Observador verifica se conta está ativa para saber se a mesma pode ter acesso à RBB<a id="usacc09"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o endereço da conta a ser verificada.
3. Caso a organização a qual a conta está vinculada esteja ativa e a conta esteja ativa, retorna-se que a conta se encontra ativa.
   1. Em qualquer outra situação, indica-se que a conta se encontra inativa.
   2. Caso o endereço não corresponda a uma conta existente, também se indica resposta de conta inativa.


## USACC10 - Observador consulta conta para obter seus dados cadastrais<a id="usacc10"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço da conta a ser consultada.
3. São retornados o endereço, a organização responsável, o papel, o hash de dados cadastrais e a situação da conta correspondente.


## USACC11 - Besu verifica permissão de uma conta para decidir se uma transação pode ser realizada<a id="usacc11"></a>

Critérios de aceitação:
1. Besu informa endereço de origem e endereço de destino da transação.
2. Somente contas ativas e vinculadas a organizações ativas são consideradas endereços de origem válidos.
3. Caso o endereço de origem conste na lista de contas com restrição de acesso, então o endereço de destino deve constar como permitido. Caso contrário, o acesso é negado.
4. Caso o endereço de destino conste na lista de *smart contracts* com restrições de acesso, então o endereço de origem deve constar como permitido. Caso contrário, o acesso é negado.
5. Transações de implantação de *smart contract* (endereço destino igual a `0x0`) somente podem ser enviadas por contas com papel Administrador Global, Administador Local ou Implantador de Aplicações.


## USACC12 - Administrador configura restrições de acesso de uma conta de sua organização para que esta só possa realizar transações para um conjunto determinado de endereços ou seja liberada para realizar transações para quaisquer endereços<a id="usacc12"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a configuração.
2. São informados:
   1. A conta a ter seu acesso configurado.
   2. Se o acesso deve ser restringido ou não.
   3. No caso de haver restrição, a lista de endereços que a conta terá permissão para enviar transações.
      1. A lista deve conter ao menos um endereço.
3. O administrador somente pode configurar contas vinculadas à sua organização.
4. O papel da conta a ser configurada não pode ser de Administrador Global.
5. Caso seja indicada limitação de acesso, a conta é adicionada à lista de contas com restrição de acesso, juntamente com o conjunto de endereços permitidos.
6. Caso **não** seja indicada limitação de acesso, a conta é removida da lista de restrição de acesso, liberando-a para enviar transações para qualquer endereço.
7. A ocorrência da configuração deve emitir um evento, registrando:
   1. A conta configurada
   2. Se foi configurada restrição de acesso
   3. Lista de endereços permitidos


## USACC11 - Observador consulta o número total de contas existentes para poder preparar paginação de dados<a id="usacc11"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador solicita o número total de contas existentes.
3. A quantidade total de contas é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USACC12 - Observador consulta contas para obter seus dados cadastrais<a id="usacc12"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros de paginação para consultar todas as contas cadastradas:
   1. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   2. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os dados cadastrais de contas correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.


## USACC13 - Observador consulta o número de contas de uma organização para poder preparar paginação de dados<a id="usacc13"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa identificador de uma organização.
3. A quantidade de contas da organização informada é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USACC14 - Observador consulta contas de uma organização para obter seus dados cadastrais<a id="usacc12"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros para realização da consulta:
   1. Identificador da organização desejada.
   2. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   3. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os dados cadastrais de contas da organização informada, correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.


## USACC15 - Observador consulta conta para verificar restrições de acesso configuradas<a id="usacc15"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço da conta a ser consultada.
3. São retornados:
   1. Indicação se a conta tem restrição de acesso configurada.
   2. Lista de endereços de destino para os quais a conta pode enviar transações.


## USACC16 - Observador consulta o número de contas com restrições de acesso configuradas para poder preparar paginação de dados<a id="usacc16"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador solicita o número total de contas com restrições de acesso configuradas.
3. A quantidade total de contas com restrições de acesso configuradas é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USACC17 - Observador consulta contas com restrições de acesso configuradas para que possa consultar as retrições configuradas<a id="usacc17"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros de paginação para consultar todas as contas com restrições de acesso configuradas:
   1. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   2. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os endereços das contas, correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.


## USACC18 - Observador consulta endereço de *smart contract* para verificar restrições de acesso configuradas<a id="usacc18"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço do *smart contract* a ser consultado.
3. São retornados:
   1. Indicação se o *smart contract* tem restrição de acesso configurada.
   2. Lista de endereços de origem a partir dos quais o *smart contract* pode receber transações. Essa lista pode ser vazia, indicando que o *smart contract* está impedido de receber transações.


## USACC19 - Observador consulta o número de *smart contracts* com restrições de acesso configuradas para poder preparar paginação de dados<a id="usacc19"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador solicita o número total de *smart contracts* com restrições de acesso configuradas.
3. A quantidade total de *smart contracts* com restrições de acesso configuradas é retornada.

**Observação**: Esta informação é importante para dimensionar consultas que podem retornar muitos resultados, evitando problemas de desempenho.


## USACC20 - Observador consulta *smart contracts* com restrições de acesso configuradas para que possa consultar as retrições configuradas<a id="usacc20"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa parâmetros de paginação para consultar todas os *smart contracts* com restrições de acesso configuradas:
   1. Página de resultado a ser retornada: Deve ser maior ou igual a 1.
   2. Tamanho da página de resultados a ser retornada: Deve ser maior ou igual a 1.
3. É retornada uma lista com os endereços dos *smart contracts*, correspondente à página de dados solicitada.

**Observação**: Não há quaisquer critérios de filtragem ou parâmetros de ordenação para o resultado. Tampouco há garantia de consistência da ordem dos elementos entre consultas.
