# language: pt

Funcionalidade: Smart contracts "governáveis"

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é admin master
    E implanto o smart contract governável

  Cenário: Acesso controlado à funcionalidade de acesso restrito
    Quando tento executar funcionalidade de acesso restrito à governança com a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    Então a funcionalidade de acesso restrito é executada com sucesso

  Cenário: Acesso não autorizado à funcionalidade de acesso restrito
    Quando tento executar funcionalidade de acesso restrito à governança com a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então ocorre erro "UnauthorizedAccess" na funcionalidade de acesso restrito

  Cenário: Acesso a funcionalidade sem restrições de acesso
    Quando tento executar funcionalidade sem restrição de acesso com a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    Então a funcionalidade sem restrição de acesso é executada com sucesso
    Quando tento executar funcionalidade sem restrição de acesso com a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Então a funcionalidade sem restrição de acesso é executada com sucesso
