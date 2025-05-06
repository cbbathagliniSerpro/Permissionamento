# Organizações

## USORG01 - Governança cadastra nova organização participante para que possa ser vinculada a nós, contas e rotação de validadores<a id="usorg01"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar o cadastro.
2. São informados o CNPJ, nome e tipo de participação da organização e indicação se a mesma pode participar de votações.
   1. O CNPJ não pode estar vazio.
   2. O nome não pode estar vazio.
   3. Caso a participação seja como Partícipe Parceiro, a organização **não** poderá participar de votações.
3. Um identificador é gerado automaticamente de forma incremental para a organização.
4. A organização é criada.
5. A ocorrência do cadastro da organização deve emitir um evento, registrando:
   1. O identificador da organização
   2. O CNPJ da organização
   3. O nome da organização
   4. O tipo de participação da organização
   5. A indicação se a mesma pode participar de votações
6. O identificador criado para a organização é retornado.


## USORG02 - Governança altera informações de organização participante para manter cadastro atualizado<a id="usorg02"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar alterações.
2. São informados o identificador da organização, novo CNPJ, novo nome, novo tipo de participação e nova indicação se a mesma pode participar de votações.
   1. O CNPJ não pode estar vazio.
   2. O nome não pode estar vazio.
   3. Caso a participação seja como Partícipe Parceiro, a organização **não** poderá participar de votações.
3. O identificador da organização não poderá ser alterado.
4. As informações de novo nome e nova indicação de participação em votação são atualizadas.
5. A alteração do cadastro da organização deve emitir um evento, registrando:
   1. O identificador da organização
   2. O novo CNPJ
   3. O novo nome
   4. O novo tipo de participação
   5. A nova indicação se a mesma pode participar de votações


## USORG03 - Governança exclui organização participante para desabilitar nós, contas e rotação de validadores vinculadas<a id="usorg03"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a exclusão.
2. É informado o identificador da organização a ser excluída.
3. A exclusão só pode ocorrer se ao menos duas organizações permanecerem ativas.
4. A organização é excluída.
5. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O identificador da organização


## USORG04 - Observador verifica se organização está ativa para saber se nós e contas vinculadas podem ser usadas<a id="usorg04"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o identificador da organização a ser verificada.
3. Caso a organização exista, retorna-se que a organização se encontra ativa.
   1. Em qualquer outra situação, indica-se que a organização se encontra inativa.
   2. Caso o identificador não corresponda a uma organização, também se indica resposta de organização inativa.


## USORG05 - Observador consulta organização para obter seus dados cadastrais<a id="usorg05"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o identificador da organização a ser consultada.
3. São retornados os dados cadastrais da organização correspondente ao identificador informado.


## USORG06 - Observador consulta lista de organizações para obter seus dados cadastrais<a id="usorg06"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador solicita lista de organizações cadastradas.
3. São retornados os dados cadastrais de todas as organizações.
