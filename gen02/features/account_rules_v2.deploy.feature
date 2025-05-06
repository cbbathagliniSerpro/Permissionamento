# language: pt

Funcionalidade: Implantação da gestão de contas

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

  Cenário: Implantação de smart contract de gestão de contas
    # Administrador global da organização 1 - BNDES
    Dado a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    Quando implanto o smart contract de gestão de contas
    Então a implantação do smart contract de gestão de contas ocorre com sucesso
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a", organização 2, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"

  Cenário: Implantação de smart contract com apenas uma conta
    Dado a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Quando implanto o smart contract de gestão de contas
    Então ocorre erro na implantação do smart contract de gestão de contas

  Cenário: Implantação de smart contract sem contas
    Quando implanto o smart contract de gestão de contas
    Então ocorre erro na implantação do smart contract de gestão de contas
