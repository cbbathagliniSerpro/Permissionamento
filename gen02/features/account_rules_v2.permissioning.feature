# language: pt

Funcionalidade: Gestão de contas - Controle de permissionamento

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
    # OrgExc será organização 3
    E a organização "12345678901234" "OrgExc" do tipo "Associate" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    # Administrador global da organização 3 - OrgExc
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Governança adiciona conta de administração local para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" na organização 1 com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Governança adiciona conta de implantação para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" na organização 1 com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Governança adiciona conta de usuário para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" na organização 1 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    # Governança adiciona conta de usuário para a OrgExc
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" na organização 3 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    # Verificando cadastro das organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,12345678901234,OrgExc,Associate,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" é da organização 1 com papel "DEPLOYER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000003" e situação ativa "true"
    E a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" é da organização 3 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000004" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Governança exclui OrgExc
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "false"
    E verifico se a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" está ativa o resultado é "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true"


  ##############################################################################
  # Permissionamento de transações
  ##############################################################################

  Cenário: Transação permitida a smart contract
    # Administrador global do BNDES pode chamar smart contract
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    # Administrador local do BNDES pode chamar smart contract
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    # Implantador do BNDES pode chamar smart contract
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    # Usuário do BNDES pode chamar smart contract
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

  Cenário: Conta não permissionada
    # Uma conta qualquer não pode chamar smart contract
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    
  Cenário: Conta inativa
    # Administrador global da OrgExc não pode chamar smart contract
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    # Usuário da OrgExc não pode chamar smart contract
    E a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"

  Cenário: Implantação de smart contract
    # Administrador global do BNDES pode implantar smart contract
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "true"
    # Administrador local do BNDES pode implantar smart contract
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "true"
    # Implantador do BNDES pode implantar smart contract
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "true"
    # Usuário do BNDES não pode chamar smart contract
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "false"


  ##############################################################################
  # Restrição de acesso de contas
  ##############################################################################

  Cenário: Configuração de restrição de acesso de conta por Administrador Global e Administrador Local
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "true"

    # Administrador Global do BNDES configura restrição de acesso para conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "true" permitindo acesso aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "false"

    # Administrador Local do BNDES libera restrição de acesso para conta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" remove restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "false" permitindo acesso aos endereços ""
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "true"

  Cenário: Sobrescrita de restrição de acesso de conta
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"

    # Administrador Global do BNDES configura restrição de acesso para conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "true" permitindo acesso aos endereços "0x0000000000000000000000000000000000008888"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "false"

    # Administrador Local do BNDES configura restrição de acesso para conta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "true" permitindo acesso aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "false"

    # Administrador Global do BNDES libera restrição de acesso para conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" remove restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "false" permitindo acesso aos endereços ""
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "true"

    # Administrador Local do BNDES libera restrição de acesso para conta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" remove restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a configuração de acesso ocorre com sucesso
    E o evento "AccountTargetAccessUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com restrição "false" permitindo acesso aos endereços ""
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x000000000000000000000000000000000000aaaa" tem verificação de permissionamento "true"

  Cenário: Tentativa de hack para permitir implantação de contratos por usuário comum
    # Usuário do BNDES não pode implantar smart contracts
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "false"
    # Administrador Local do BNDES configura restrição de acesso para conta indicando endereço 0x0 (implantação) como permitido
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000000000"
    Então a configuração de acesso ocorre com sucesso
    # Usuário do BNDES segue não podendo implantar smart contracts
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000000000" tem verificação de permissionamento "false"

  Cenário: Tentativa de configuração de restrição de acesso de conta por conta sem privilégio de acesso
    # Conta com perfil de implantação de smart contracts tenta configurar restrição de acesso
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "UnauthorizedAccess" na tentativa de configuração de acesso
    # Conta com perfil de usuário de aplicações tenta configurar restrição de acesso
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" configura restrição de acesso para a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "UnauthorizedAccess" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso de conta de Administrador Global
    # Governança adiciona nova conta de Administrador Global para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES tenta configurar restrição de acesso para a outra conta de Administrador Global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "InvalidRole" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso de conta por conta não autorizada ("por fora" da governança)
    # Conta não permissionada tenta configurar restrição de acesso
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "UnauthorizedAccess" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso por conta inativa
    # Administrador (inativo) de organização excluída - OrgExt - tenta configurar restrição de acesso
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" configura restrição de acesso para a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "InactiveAccount" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso a conta inexistente
    # Administrador Global do BNDES tenta configurar restrição de acesso para conta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "AccountNotFound" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso de conta sem indicar endereços
    # Administrador Global do BNDES tenta configurar restrição de acesso para conta sem indicar quais endereços alvo são permitidos
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" permitindo acesso somente aos endereços ""
    Então ocorre erro "InvalidArgument" na tentativa de configuração de acesso

  Cenário: Tentativa de remoção de restrição de acesso de conta indicando endereços
    # Administrador Global do BNDES tenta liberar restrição de acesso para conta indicando endereços alvo permitidos
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" remove restrição de acesso para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" indicando permissão de acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "InvalidArgument" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso de conta de outra organização
    # Governança adiciona nova conta de usuário para o TCU
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" na organização 2 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 2 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES tenta configurar restrição de acesso para conta do TCU (outra organização)
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso para a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" permitindo acesso somente aos endereços "0x0000000000000000000000000000000000008888,0x0000000000000000000000000000000000009999"
    Então ocorre erro "NotLocalAccount" na tentativa de configuração de acesso


  ##############################################################################
  # Restrição de acesso a smart contracts
  ##############################################################################

  Cenário: Smart contract com restrição de acesso total
    # Governança configura restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000008888" permitindo acesso somente pelas contas ""
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "true" permitindo as contas ""
    # Todas as contas ficam sem poder chamar o smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"

    # Governança remove restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" remove restrição de acesso ao endereço "0x0000000000000000000000000000000000008888"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "false" permitindo as contas ""
    # Todas as contas restabelecem acesso ao smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

  Cenário: Smart contract com restrição de acesso parcial
    # Governança configura restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000008888" permitindo acesso somente pelas contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "true" permitindo as contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    # Algumas contas ficam sem poder chamar o smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

    # Governança remove restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" remove restrição de acesso ao endereço "0x0000000000000000000000000000000000008888"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "false" permitindo as contas ""
    # Todas as contas restabelecem acesso ao smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

  Cenário: Sobrescrita de restrição de acesso a smart contract
    # Governança configura restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000008888" permitindo acesso somente pelas contas ""
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "true" permitindo as contas ""
    # Todas as contas ficam sem poder chamar o smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"

    # Governança configura nova restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000008888" permitindo acesso somente pelas contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "true" permitindo as contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    # Algumas contas ficam sem poder chamar o smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

    # Governança remove restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" remove restrição de acesso ao endereço "0x0000000000000000000000000000000000008888"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "false" permitindo as contas ""
    # Todas as contas restabelecem acesso ao smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

    # Governança remove novamente restrição de acesso a smart contract
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" remove restrição de acesso ao endereço "0x0000000000000000000000000000000000008888"
    Então a configuração de acesso ocorre com sucesso
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "false" permitindo as contas ""
    # Todas as contas restabelecem acesso ao smart contract
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"

  Cenário: Tentativa de configuração de restrição de acesso a smart contract por conta não autorizada ("por fora" da governança)
    # Administrador global do BNDES tenta configurar acesso a smart contract
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000008888" permitindo acesso somente pelas contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então ocorre erro "UnauthorizedAccess" na tentativa de configuração de acesso

  Cenário: Tentativa de configuração de restrição de acesso a smart contract inválido
    # Governança tenta configura restrição de acesso a smart contract 0x0
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000000000" permitindo acesso somente pelas contas "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então ocorre erro "InvalidAccount" na tentativa de configuração de acesso
