# language: pt

Funcionalidade: Gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    # A conta 0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199 é utilizada como admin,
    # conforme conceito da primeira geração do permissionamento, que representará
    # o smart contract de governança/votação.
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin master
    # BNDES será organização 1
    E a organização "33657248000189" "BNDES" do tipo "Patron" com direito de voto "true"
    # TCU será organização 2
    E a organização "00414607000118" "TCU" do tipo "Patron" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    
  Cenário: Consulta de dados cadastrais de organização
    E a organização 1 é "33657248000189" "BNDES" do tipo "Patron" e direito de voto "true"
    E a organização 2 é "00414607000118" "TCU" do tipo "Patron" e direito de voto "true"

  Cenário: Consulta da lista de organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true"

  Cenário: Consulta de organização inexistente
    Quando um observador consulta a organização 10 ocorre erro "OrganizationNotFound"

  Cenário: Verificação de organizações ativas e inativas
    Quando verifico se a organização 1 está ativa o resultado é "true"
    Quando verifico se a organização 2 está ativa o resultado é "true"
    Quando verifico se a organização 3 está ativa o resultado é "false"

  Cenário: Adição de organização
    # Governança adiciona a Dataprev com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "42422253000101" "Dataprev" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "42422253000101" "Dataprev" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    E o evento "OrganizationAdded" foi emitido para a organização 3 "42422253000101" com nome "Dataprev" tipo "Associate" e direito de voto "true"
    # Governança adiciona a PUC-Rio com organização 4
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "33555921000170" "PUC-Rio" do tipo "Partner" e direito de voto "false"
    Então a organização 4 é "33555921000170" "PUC-Rio" do tipo "Partner" e direito de voto "false"
    E o evento "OrganizationAdded" foi emitido para a organização 4 "33555921000170" com nome "PUC-Rio" tipo "Partner" e direito de voto "false"
    E verifico se a organização 4 está ativa o resultado é "true"
    # Verificação da lista de organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,Dataprev,Associate,true|4,33555921000170,PUC-Rio,Partner,false"
  
  Cenário: Tentativa de adição de organização por conta não autorizada ("por fora" da governança)
    # Uma conta que não é a da Governança tenta adicionar organização
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" adiciona a organização "12345678901234" "OrgAd" do tipo "Associate" e direito de voto "true"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de organização

  Cenário: Tentativa de adição de organização com CNPJ vazio
    # Governança tenta adicionar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "" "OrgAd" do tipo "Associate" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de adição de organização

  Cenário: Tentativa de adição de organização com nome vazio
    # Governança tenta adicionar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "12345678901234" "" do tipo "Associate" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de adição de organização

  Cenário: Tentativa de adição de organização parceira com direito a voto
    # Governança tenta adicionar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "12345678901234" "OrgAd" do tipo "Partner" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de adição de organização

  Cenário: Atualização de organização
    # Governança altera organização 1
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" atualiza a organização 1 com CNPJ "33657248000180" nome "Banco Nacional de Desenvolvimento Econômico e Social" tipo "Associate" e direito de voto "false"
    Então a organização 1 é "33657248000180" "Banco Nacional de Desenvolvimento Econômico e Social" do tipo "Associate" e direito de voto "false"
    E o evento "OrganizationUpdated" foi emitido para a organização 1 "33657248000180" com nome "Banco Nacional de Desenvolvimento Econômico e Social" tipo "Associate" e direito de voto "false"

  Cenário: Tentativa de atualização de organização por conta não autorizada ("por fora" da governança)
    # Uma conta que não é a da Governança tenta atualizar organização
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" atualiza a organização 1 com CNPJ "33657248000180" nome "Banco Nacional de Desenvolvimento Econômico e Social" tipo "Associate" e direito de voto "false"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de organização

  Cenário: Tentativa de atualização de organização inexistente
    # Governança tenta atualizar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" atualiza a organização 3 com CNPJ "12345678901234" nome "OrgInex" tipo "Associate" e direito de voto "false"
    Então ocorre erro "OrganizationNotFound" na tentativa de atualização de organização

  Cenário: Tentativa de atualização de organização com CNPJ vazio
    # Governança tenta atualizar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" atualiza a organização 1 com CNPJ "" nome "BNDES" tipo "Patron" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de atualização de organização

  Cenário: Tentativa de atualização de organização com nome vazio
    # Governança tenta atualizar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" atualiza a organização 1 com CNPJ "33657248000189" nome "" tipo "Patron" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de atualização de organização

  Cenário: Tentativa de atualização de organização parceira com direito a voto
    # Governança tenta adicionar organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" atualiza a organização 1 com CNPJ "33657248000189" nome "BNDES" tipo "Partner" e direito de voto "true"
    Então ocorre erro "InvalidArgument" na tentativa de atualização de organização

  Cenário: Exclusão de organização
    # Governança adiciona a OrgExc com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "12345678901234" "OrgExc" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "12345678901234" "OrgExc" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    E o evento "OrganizationAdded" foi emitido para a organização 3 "12345678901234" com nome "OrgExc" tipo "Associate" e direito de voto "true"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,12345678901234,OrgExc,Associate,true"
    # Governança exclui a organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então o evento "OrganizationDeleted" foi emitido para a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true"

  Cenário: Tentativa de exclusão de organização por conta não autorizada ("por fora" da governança)
    # Governança adiciona a OrgExc com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "12345678901234" "OrgExc" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "12345678901234" "OrgExc" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    # Uma conta que não é a da Governança tenta excluir a organização
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" exclui a organização 3
    Então ocorre erro "UnauthorizedAccess" na tentativa de exclusão de organização

  Cenário: Tentativa de exclusão de organização com apenas 2 organizações cadastradas
    # Governança tenta excluir organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 2
    Então ocorre erro "IllegalState" na tentativa de exclusão de organização

  Cenário: Tentativa de exclusão de organização inexistente
    # Governança tenta excluir organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então ocorre erro "OrganizationNotFound" na tentativa de exclusão de organização
  