# language: pt

Funcionalidade: Gestão de nós

  Contexto:
    # 1. implantar contrato de admin (mock)
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin master
    # 2. adicionar 4 organizações à array de orgs
    E a organização "33657248000189" "BNDES" do tipo "Patron" com direito de voto "true"
    E a organização "00414607000118" "TCU" do tipo "Patron" com direito de voto "true"
    E a organização "12345678901234" "OrgExc3" do tipo "Associate" com direito de voto "true"
    E a organização "43210987654321" "Org4" do tipo "Associate" com direito de voto "true"
    # 3. implantar contrato de organizações
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # 4. adicionar 4 administradores globais
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906"
    # 5. implantar o contrato de gestão de contas
    E implanto o smart contract de gestão de contas
    # 6. adicionar administradores locais
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" adiciona a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" adiciona a conta local "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" adiciona a conta local "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000005"
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    # 7. implantar contrato de nós
    E implanto o smart contract de gestão de nós
    E a implantação do smart contract de gestão de nós ocorre com sucesso


  ##############################################################################
  # Adição de nós locais
  ##############################################################################

  Cenário: Cadastro realizado por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    E o evento "NodeAdded" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 1 com tipo "Validator" e nome "validator01"
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 1, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Cadastro realizado por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    E o evento "NodeAdded" é emitido para o nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" da organização 1 com tipo "Validator" e nome "validator01"
    E o nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" é da organização 1, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de cadastro por um Administrador Global inativo
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" informa o endereço "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então ocorre erro "InactiveAccount" na transação
    E se uma consulta é realizada ao nó "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa de cadastro por um Administrador Local inativo
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" informa o endereço "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então ocorre erro "InactiveAccount" na transação
    E se uma consulta é realizada ao nó "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa de cadastro de um nó já existente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então ocorre erro "DuplicateNode" na transação

  Cenário: Tentativa de cadastro por uma conta que não é administradora
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa de cadastro de nó com nome inválido
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33", o nome "" e o tipo "Validator" do nó para cadastrá-lo
    Então ocorre erro "InvalidArgument" na transação
    E se uma consulta é realizada ao nó "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33" recebe-se o erro "NodeNotFound"


  ##############################################################################
  # Exclusão de nós locais
  ##############################################################################

  Cenário: Exclusão de nó realizada por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então a transação ocorre com sucesso
    E o evento "NodeDeleted" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 1
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Exclusão de nó realizada por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então a transação ocorre com sucesso
    E o evento "NodeDeleted" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 1
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa de exclusão por um Administrador Global inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    Então a transação ocorre com sucesso
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então ocorre erro "InactiveAccount" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de exclusão por um Administrador Local inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    Então a transação ocorre com sucesso
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então ocorre erro "InactiveAccount" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de exclusão de nó vinculado a outra organização
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então ocorre erro "NotLocalNode" na transação
    # verifica se o nó ainda existe
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Exclusão de nó que não existe
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então ocorre erro "NodeNotFound" na transação


  ##############################################################################
  # Alteração de nós locais
  ##############################################################################

  Cenário: Alteração de cadastro realizada por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o evento "NodeUpdated" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4 com tipo "Boot" e nome "boot01"
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "boot01", tipo "Boot" e situação ativa true

  Cenário: Alteração de cadastro realizada por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    E o evento "NodeUpdated" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4 com tipo "Boot" e nome "boot01"
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "boot01", tipo "Boot" e situação ativa true

  Cenário: Tentativa de alteração por um Administrador Global inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então ocorre erro "InactiveAccount" na transação

  Cenário: Tentativa de alteração por um Administrador Local inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então ocorre erro "InactiveAccount" na transação

  Cenário: Mudança para nome inválido
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "" e o tipo "Boot" para alterá-lo
    Então ocorre erro "InvalidArgument" na transação
    E o nome do nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" continua o mesmo

  Cenário: Tentativa de alteração de nó vinculado a outra organização
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então ocorre erro "NotLocalNode" na transação

  Cenário: Alteração de nó que não existe
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então ocorre erro "NodeNotFound" na transação

  Cenário: Alteração de situação realizada por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então a transação ocorre com sucesso
    E o evento "NodeStatusUpdated" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4 com situação ativa false
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa false
    E verifico se o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" está ativo o resultado é false

  Cenário: Alteração de situação realizada por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então a transação ocorre com sucesso
    E o evento "NodeStatusUpdated" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4 com situação ativa false
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa false
    E verifico se o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" está ativo o resultado é false

  Cenário: Tentativa de alteração de situação por um Administrador Global inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    E a transação ocorre com sucesso
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então ocorre erro "InactiveAccount" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de alteração de situação por um Administrador Local inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    E a transação ocorre com sucesso
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então ocorre erro "InactiveAccount" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de alteração de situação de nó vinculado a outra organização
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então ocorre erro "NotLocalNode" na transação
    E verifico se o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" está ativo o resultado é true

  Cenário: Tentativa de alteração de nó por uma conta que não é administradora
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então ocorre erro "UnauthorizedAccess" na transação
    E verifico se o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" está ativo o resultado é true

  Cenário: Alteração de nó com endereço inexistente
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    Então ocorre erro "NodeNotFound" na transação


  ##############################################################################
  # Adição de nós via Governança
  ##############################################################################

  Cenário: Cadastro válido de nó pela Governança
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 4 para cadastrá-lo
    Então a transação ocorre com sucesso
    E o evento "NodeAdded" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4 com tipo "Validator" e nome "validator01"
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa de cadastro de nó pela Governança com organização inválida
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 5 para cadastrá-lo
    Então ocorre erro "InvalidOrganization" na transação
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa de cadastro de nó pela Governança com nó já existente
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 4 para cadastrá-lo
    Então ocorre erro "DuplicateNode" na transação

  Cenário: Tentativa de cadastro de nó pela Governança com nome inválido
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "" e a organização 4 para cadastrá-lo
    Então ocorre erro "InvalidArgument" na transação

  Cenário: Tentativa indevida de cadastro de nó por conta sem os poderes da Governança
    Quando a conta de governança "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 4 para cadastrá-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa indevida de cadastro de nó por Administrador Global com os poderes da Governança
    Quando a conta de governança "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 4 para cadastrá-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Tentativa indevida de cadastro de nó por Administrador Local com os poderes da Governança
    Quando a conta de governança "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o tipo "Validator", o nome "validator01" e a organização 4 para cadastrá-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"


  ##############################################################################
  # Exclusão de nós via Governança
  ##############################################################################

  Cenário: Remoção de nó válido pela Governança
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" do nó para removê-lo
    Então a transação ocorre com sucesso
    E o evento "NodeDeleted" é emitido para o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" da organização 4
    E se uma consulta é realizada ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe-se o erro "NodeNotFound"

  Cenário: Remoção de nó inexistente pela Governança
    Quando a conta de governança "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" do nó para removê-lo
    Então ocorre erro "NodeNotFound" na transação

  Cenário: Tentativa indevida de remoção de nó por conta sem os poderes da Governança
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta de governança "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" do nó para removê-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa indevida de remoção de nó por administrador global
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta de governança "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" do nó para removê-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true

  Cenário: Tentativa indevida de remoção de nó por administrador local
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando a conta de governança "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" do nó para removê-lo
    Então ocorre erro "UnauthorizedAccess" na transação
    E o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" é da organização 4, tem o nome "validator01", tipo "Validator" e situação ativa true


   ##############################################################################
   # Permissão de conectividade entre nós
   ##############################################################################

  Cenário: Conexão entre dois nós ativos
    # Org4 inclui nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    # BNDES inclui nó
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então a transação ocorre com sucesso
    Quando o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tenta se conectar ao nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c"
    Então o resultado da conexão é "CONNECTION_ALLOWED"

  Cenário: Conexão entre um nó ativo e outro inativo
    # Org4 inclui nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # BNDES inclui nó
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # Org4 desativa nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    E a transação ocorre com sucesso
    # Origem inativa e destino ativo
    Quando o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tenta se conectar ao nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c"
    Então o resultado da conexão é "CONNECTION_DENIED"
    # Origem ativa e destino inativo
    Quando o nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" tenta se conectar ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646"
    Então o resultado da conexão é "CONNECTION_DENIED"

  Cenário: Conexão entre dois nós inativos
    # Org4 inclui nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # BNDES inclui nó
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # Org4 desativa nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para mudar sua situação ativa para false
    E a transação ocorre com sucesso
    # BNDES desativa nó
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" para mudar sua situação ativa para false
    E a transação ocorre com sucesso
    Quando o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tenta se conectar ao nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c"
    Então o resultado da conexão é "CONNECTION_DENIED"
    
  Cenário: Conexão com nó de organização excluída
    # Org4 inclui nó
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # BNDES inclui nó
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a transação ocorre com sucesso
    # Governança exclui Org4
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    Então a transação ocorre com sucesso
    # Origem inativa e destino ativo
    Quando o nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tenta se conectar ao nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c"
    Então o resultado da conexão é "CONNECTION_DENIED"
    # Origem ativa e destino inativo
    Quando o nó "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" tenta se conectar ao nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646"
    Então o resultado da conexão é "CONNECTION_DENIED"
