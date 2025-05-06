# language: pt

Funcionalidade: Governança do permissionamento - Cenários de votação

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
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Verificando cadastro das organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E implanto o smart contract de governança do permissionamento
    E a implantação do smart contract de governança do permissionamento ocorre com sucesso
    E implanto um smart contract mock para que sofra ações da governança
    E a implantação do smart contract mock ocorre com sucesso


  ##############################################################################
  # Votação com 2 organizações
  ##############################################################################
  
  Cenário: Aprovação de proposta com 2 organizações
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "Approval,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2" e votos "Approval,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta

  Cenário: Rejeição de proposta com 2 organizações
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "Rejection,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2" e votos "Rejection,Rejection"
    # Proposta é rejeistada por maioria
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Empate de proposta com 2 organizações
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2" e votos "Approval,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2" e votos "Approval,Rejection"
    # Proposta é aprovada por maioria
    E o evento "ProposalRejected" é emitido para a proposta


  ##############################################################################
  # Votação com 3 organizações
  ##############################################################################
  
  Cenário: Aprovação de proposta com 3 organizações no último voto
    # Governança adiciona a Prodemge com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    # Governança adiciona novo administrador global para a Prodemge
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Rejection,NotVoted,NotVoted"
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Rejection,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3" e votos "Rejection,Approval,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta

  Cenário: Aprovação de proposta com 3 organizações no segundo voto
    # Governança adiciona a Prodemge com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    # Governança adiciona novo administrador global para a Prodemge
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Approval,NotVoted,NotVoted"
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3" e votos "Approval,NotVoted,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global do TCU vota para rejeitar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3" e votos "Approval,Rejection,Approval"

  Cenário: Rejeição de proposta com 3 organizações no último voto
    # Governança adiciona a Prodemge com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    # Governança adiciona novo administrador global para a Prodemge
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Rejection,NotVoted,NotVoted"
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Rejection,NotVoted,Approval"
    # Administrador Global do TCU vota para rejeitar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3" e votos "Rejection,Rejection,Approval"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Rejeição de proposta com 3 organizações no segundo voto
    # Governança adiciona a Prodemge com organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    Então a organização 3 é "16636540000104" "Prodemge" do tipo "Associate" e direito de voto "true"
    # Governança adiciona novo administrador global para a Prodemge
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x00", limite de 30000 blocos e descrição "Proposta"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3" e votos "Rejection,NotVoted,NotVoted"
    # Administrador Global do TCU vota para rejeitar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3" e votos "Rejection,Rejection,NotVoted"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3" e votos "Rejection,Rejection,Approval"
