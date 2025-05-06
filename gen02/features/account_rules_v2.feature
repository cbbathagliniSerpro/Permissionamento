# language: pt

Funcionalidade: Gestão de contas

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
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Administrador global da OrgExc adiciona novo administrador local
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" adiciona a conta local "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    # Administrador global da OrgExc adiciona nova conta de usuário
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" adiciona a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Verificando cadastro das organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,12345678901234,OrgExc,Associate,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 3 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000004" e situação ativa "true"
    E a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 3 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    # Governança exclui a OrgExc, logo, suas contas ficarão inativas
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true"
    E verifico se a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" está ativa o resultado é "false"
    E verifico se a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" está ativa o resultado é "false"

  ##############################################################################
  # Adição de contas locais
  ##############################################################################
  
  Cenário: Adição de conta local, com administrador global e com administrador local
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Administrador local do BNDES adiciona nova conta de usuário
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"

  Cenário: Adição de conta local de Administrador Local com hash zerado
    # Administrador global do BNDES tenta adicionar conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"

  Cenário: Tentativa de adição de conta local com conta não permissionada
    # Uma conta qualquer tenta adicionar uma nova conta local
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com conta sem perfil de acesso necessário
    # Administrador global do BNDES adiciona nova conta de usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Nova conta de usuário tenta adicionar nova conta de usuário
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com endereço inválido
    # Administrador global do BNDES tenta adicionar nova conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x0000000000000000000000000000000000000000" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local repetida
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Administrador global do BNDES tenta adicionar novamente o mesmo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com administrador de organização inativa
    # Administrador global da OrgExc tenta adiciona nova conta de usuário, mas está inativo
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    Então ocorre erro "InactiveAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com administrador local inativo
    # Administrador local da OrgExc tenta adiciona nova conta de usuário, mas está inativo
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    Então ocorre erro "InactiveAccount" na tentativa de adição de conta
    
  Cenário: Tentativa de adição de conta local com perfil de administrador global
    # Administrador global do BNDES tenta adicionar outro administrador global como "conta local"
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com perfil inválido
    # Administrador global do BNDES tenta adicionar conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "UNKNOWN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com hash zerado
    # Administrador global do BNDES tenta adicionar conta de implantação de smart contracts
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de adição de conta
    # Administrador global do BNDES tenta adicionar conta de usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de adição de conta


  ##############################################################################
  # Adição de contas via governança
  ##############################################################################

  Cenário: Adição de conta de administrador global pela governança
    # Governança adiciona novo administrador global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Governança adiciona conta de usuário para o BNDES
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"

  Cenário: Adição de conta de Administrador Global com hash zerado
    # Governança adiciona Administrador Global com hash zerado
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    
  Cenário: Adição de conta de Administrador Local com hash zerado
    # Governança adiciona Administrador Local com hash zerado
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"

  Cenário: Tentativa de adição de conta por conta não autorizada ("por fora" da governança)
    # Administrador global do BNDES tenta cadastrar diretamente outro administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com endereço inválido
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x0000000000000000000000000000000000000000" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta repetida
    # Governança adiciona conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Governança tenta adicionar novamente a mesma conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com perfil inválido
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "UNKNOWN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com hash zerado
    # Governança tenta adicionar conta de implantação de smart contracts
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de adição de conta
    # Governança tenta adicionar conta de usuário
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de adição de conta


  ##############################################################################
  # Exclusão de contas locais
  ##############################################################################
  
  Cenário: Exclusão de conta local, com administrador global e com administrador local
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    # Administrador local do BNDES adiciona nova conta de usuário
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador local do BNDES exclui conta de usuário
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" exclui a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a exclusão é realizada com sucesso
    E o evento "AccountDeleted" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" da organização 1
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" não consta na lista de contas do papel "USER_ROLE"
    E se tento obter os dados da conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" ocorre erro "AccountNotFound"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "false"
    # Administrador global do BNDES exclui administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    Então a exclusão é realizada com sucesso
    E o evento "AccountDeleted" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" da organização 1
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" não consta na lista de contas do papel "LOCAL_ADMIN_ROLE"
    E se tento obter os dados da conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" ocorre erro "AccountNotFound"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "false"

  Cenário: Tentativa de exclusão de conta local com conta não permissionada
    # Uma conta qualquer tenta excluir uma nova conta local
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" exclui a conta local "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então ocorre erro "UnauthorizedAccess" na tentativa de exclusão de conta

  Cenário: Tentativa de exclusão de conta local com conta sem perfil de acesso necessário
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES adiciona nova conta de usuário 0x3C44
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" está ativa o resultado é "true"
    # Nova conta de usuário 0x7099 tenta realizar exclusão da conta 0x3C44
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" exclui a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"
    Então ocorre erro "UnauthorizedAccess" na tentativa de exclusão de conta

  Cenário: Tentativa de exclusão de conta local com administrador de organização inativa
    # Administrador global da OrgExc tenta excluir nova conta de usuário, mas está inativo
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" exclui a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc"
    Então ocorre erro "InactiveAccount" na tentativa de exclusão de conta

  Cenário: Tentativa de exclusão de conta de outra organização
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do TCU tenta excluir conta do BNDES
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" exclui a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então ocorre erro "NotLocalAccount" na tentativa de exclusão de conta
    
  Cenário: Tentativa de exclusão de conta de administrador global
    # Governança adiciona novo administrador global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES 0x71bE tenta excluir novo administrador 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então ocorre erro "InvalidRole" na tentativa de exclusão de conta

  Cenário: Tentativa de exclusão de conta local inexistente
    # Administrador global do BNDES tenta excluir conta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"
    Então ocorre erro "AccountNotFound" na tentativa de exclusão de conta
    # Administrador global do BNDES tenta excluir conta com endereço zerado
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x0000000000000000000000000000000000000000"
    Então ocorre erro "AccountNotFound" na tentativa de exclusão de conta


  ##############################################################################
  # Exclusão de contas via governança
  ##############################################################################

  Cenário: Exclusão de conta de administrador global pela governança
    # Governança adiciona novo administrador global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    # Governança exclui administrador global "original" do BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então a exclusão é realizada com sucesso
    E o evento "AccountDeleted" foi emitido para a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" da organização 1
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" não consta na lista de contas do papel "GLOBAL_ADMIN_ROLE"
    E verifico se a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" está ativa o resultado é "false"

  Cenário: Tentativa de excluão de conta por conta não autorizada ("por fora" da governança)
    # Governança adiciona novo administrador global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador global do BNDES tenta excluir diretamente o outro administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    Então ocorre erro "UnauthorizedAccess" na tentativa de exclusão de conta

  Cenário: Tentativa de exclusão de conta inexistente
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a conta "0x0000000000000000000000000000000000000000"
    Então ocorre erro "AccountNotFound" na tentativa de exclusão de conta

  Cenário: Governança tenta remover último admnistrador global
    # Governança exclui administrador global do BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então ocorre erro "IllegalState" na tentativa de exclusão de conta


  ##############################################################################
  # Atualização de contas locais
  ##############################################################################
  
  Cenário: Atualização de conta local, com administrador global e com administrador local
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    # Administrador local do BNDES adiciona nova conta de usuário
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"

    # Administrador global do BNDES atualiza conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    Então a atualização é realizada com sucesso
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000003" e situação ativa "true"
    E o evento "AccountUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" não consta na lista de contas do papel "USER_ROLE"
    # Administrador global do BNDES atualiza status da conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a situação ativa da conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" para "false"
    Então a atualização é realizada com sucesso
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000003" e situação ativa "false"
    E o evento "AccountStatusUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" da organização 1 com situação ativa "false"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "false"

    # Administrador local do BNDES atualiza conta local
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    Então a atualização é realizada com sucesso
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000004" e situação ativa "false"
    E o evento "AccountUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" não consta na lista de contas do papel "LOCAL_ADMIN_ROLE"
    # Administrador local do BNDES atualiza status da conta local
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" atualiza a situação ativa da conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" para "true"
    Então a atualização é realizada com sucesso
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000004" e situação ativa "true"
    E o evento "AccountStatusUpdated" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" da organização 1 com situação ativa "true"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"

  Cenário: Atualização de conta de administrador local com hash zerado
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador global do BNDES atualiza hash da conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a atualização é realizada com sucesso
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountUpdated" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"

  Cenário: Atualização de conta para administrador local com hash zerado
    # Administrador global do BNDES adiciona novo usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador global do BNDES atualiza papel e hash da conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a atualização é realizada com sucesso
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountUpdated" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"

  Cenário: Atualização de papel de conta local com hash válido
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador global do BNDES altera papel da conta para implantador de smart contracts
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a atualização é realizada com sucesso
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "DEPLOYER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountUpdated" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" não consta na lista de contas do papel "LOCAL_ADMIN_ROLE"
    # Administrador global do BNDES altera papel da conta para usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a atualização é realizada com sucesso
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountUpdated" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" não consta na lista de contas do papel "DEPLOYER_ROLE"

  Cenário: Tentativa de atualização de conta local com conta não permissionada
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    # Uma conta qualquer tenta atualizar uma conta local
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de conta
    # Uma conta qualquer tenta atualizar o status de uma conta local
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" atualiza a situação ativa da conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" para "false"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de conta local com conta sem perfil de acesso necessário
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES adiciona nova conta de usuário 0x3C44
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" está ativa o resultado é "true"
    # Nova conta de usuário 0x7099 tenta alterar conta 0x3C44
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" atualiza a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de conta
    # Nova conta de usuário 0x7099 tenta alterar status da conta 0x3C44
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" atualiza a situação ativa da conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" para "false"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de conta local com administrador de organização inativa
    # Administrador global da OrgExc tenta atualizar conta local
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" atualiza a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "InactiveAccount" na tentativa de atualização de conta
    # Administrador global da OrgExc tenta atualizar status de conta local
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" atualiza a situação ativa da conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" para "false"
    Então ocorre erro "InactiveAccount" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de conta de outra organização
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do TCU tenta atualizar conta do BNDES
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "NotLocalAccount" na tentativa de atualização de conta
    # Administrador global do TCU tenta atualizar status de conta do BNDES
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" atualiza a situação ativa da conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" para "false"
    Então ocorre erro "NotLocalAccount" na tentativa de atualização de conta
    
  Cenário: Tentativa de atualização de conta de administrador global
    # Governança adiciona novo administrador global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES tenta atualizar outro administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "InvalidRole" na tentativa de atualização de conta
    # Administrador global do BNDES tenta atualizar status de outro administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a situação ativa da conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" para "false"
    Então ocorre erro "InvalidRole" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de conta local inexistente
    # Administrador global do BNDES tenta atualizar papel de conta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "AccountNotFound" na tentativa de atualização de conta
    # Administrador global do BNDES tenta atualizar status de conta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a situação ativa da conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" para "false"
    Então ocorre erro "AccountNotFound" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de conta local com perfil inválido
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES tenta atualizar conta local com papel inválido
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "UNKNOWN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "InvalidRole" na tentativa de atualização de conta

  Cenário: Tentativa de "promoção" de conta local para administrador global
    # Administrador global do BNDES adiciona nova conta de usuário 0x7099
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E verifico se a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" está ativa o resultado é "true"
    # Administrador global do BNDES tenta atualizar papel da conta local para administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então ocorre erro "InvalidRole" na tentativa de atualização de conta

  Cenário: Tentativa de atualização de papel de conta local com hash zerado
    # Administrador global do BNDES adiciona novo administrador local com hash zerado
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Administrador global do BNDES tenta altera papel da conta para implantador de smart contracts com hash zerado
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de atualização de conta
    # Administrador global do BNDES altera papel da conta para usuário com hash zerado
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" atualiza a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorre erro "InvalidHash" na tentativa de atualização de conta


  ##############################################################################
  # Consultas
  ##############################################################################
  
  Cenário: Consulta de conta existente
    Quando um observador consulta a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então a consulta de conta ocorre com sucesso

  Cenário: Consulta de conta inexistente
    Quando um observador consulta a conta "0x0000000000000000000000000000000000000001"
    Então ocorre erro "AccountNotFound" na consulta de conta

  Cenário: Conta existente ativa
    Quando verifico se a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" está ativa o resultado é "true"

  Cenário: Conta existente de organização inativa
    Quando verifico se a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" está ativa o resultado é "false"

  Cenário: Conta inexistente inativa
    Quando verifico se a conta "0x0000000000000000000000000000000000000001" está ativa o resultado é "false"
