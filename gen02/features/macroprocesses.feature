# language: pt

Funcionalidade: Macroprocessos de gestão da RBB

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
    # Dataprev será a organização 3
    E a organização "42422253000101" "DATAPREV" do tipo "Associate" com direito de voto "true"
    # PUC-Rio será a organização 4
    E a organização "33555921000170" "PUC-Rio" do tipo "Partner" com direito de voto "false"
    # CPQD será a organização 5
    E a organização "02641663000110" "CPQD" do tipo "Associate" com direito de voto "true"
    # RNP será organização 6
    E a organização "03508097000136" "RNP" do tipo "Associate" com direito de voto "true"
    # Prodemge será organização 7
    E a organização "16636540000104" "Prodemge" do tipo "Associate" com direito de voto "true"
    # SERPRO será organização 8
    E a organização "33683111000107" "SERPRO" do tipo "Associate" com direito de voto "true"
    # OrgExc será organização 9
    E a organização "12345678901234" "OrgExc" do tipo "Associate" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    # Administrador global da organização 3 - Dataprev
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    # Administrador global da organização 4 - PUC-Rio
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097"
    # Administrador global da organização 5 - CPQD
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    # Administrador global da organização 6 - RNP
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    # Administrador global da organização 7 - Prodemge
    E a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E"
    # Administrador global da organização 8 - SERPRO
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0"
    # Administrador global da organização 9 - OrgExc
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Cadastrando restrição de acesso a smart contract (restrição usada em cenário abaixo)
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" configura restrição de acesso ao endereço "0x0000000000000000000000000000000000009999" permitindo acesso somente pelas contas ""
    Então a configuração de acesso ocorre com sucesso
    # Cadastrando outro Administrador Global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a adição é realizada com sucesso
    # Verificando cadastro das organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,DATAPREV,Associate,true|4,33555921000170,PUC-Rio,Partner,false|5,02641663000110,CPQD,Associate,true|6,03508097000136,RNP,Associate,true|7,16636540000104,Prodemge,Associate,true|8,33683111000107,SERPRO,Associate,true|9,12345678901234,OrgExc,Associate,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 4 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" é da organização 5 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 6 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" é da organização 8 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" é da organização 9 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Implantação do smart contract de governança
    E implanto o smart contract de governança do permissionamento
    E a implantação do smart contract de governança do permissionamento ocorre com sucesso
    E o smart contract de governança é adicionado como admin master
    # Preparação para criação da proposta para deixar apenas o smart contract de governança como admin master
    Dado o alvo "Admin" para chamada da função "removeAdmin(address)" com parâmetros "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    # Administrador Global do BNDES cria a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Só governança como admin master"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global da RNP vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,Approval,Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,Approval,Approval,NotVoted,NotVoted,NotVoted"
    # Verificando o resultado da execução, se somente a Governança é admin master
    E se verifico se a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin master o resultado é "false"
    E se verifico se o smart contract de governança é admin master o resultado é "true"

  Cenário: Entrada de uma nova organização
    # Preparação de passos para uma proposta
    Dado o alvo "OrganizationImpl" para chamada da função "addOrganization(string,string,uint8,bool)" com parâmetros "04082993000149,IBICT,1,true"
    E o alvo "AccountRulesV2Impl" para chamada da função "addAccount(address,uint256,bytes32,bytes32)" com parâmetros "0xBcd4042DE499D14e55001CcbB24a551F3b954096,10,0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f,0x0000000000000000000000000000000000000000000000000000000000000000"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Inclusão do IBICT"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global da RNP vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "OrganizationAdded" foi emitido para a organização 10 "04082993000149" com nome "IBICT" tipo "Associate" e direito de voto "true"
    E o evento "AccountAdded" foi emitido para a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096", organização 10, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,Approval,NotVoted,Approval,NotVoted"
    # Verificando o resultado da execução, se organização e admin global foram criados
    E a organização 10 é "04082993000149" "IBICT" do tipo "Associate" e direito de voto "true"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,DATAPREV,Associate,true|4,33555921000170,PUC-Rio,Partner,false|5,02641663000110,CPQD,Associate,true|6,03508097000136,RNP,Associate,true|7,16636540000104,Prodemge,Associate,true|8,33683111000107,SERPRO,Associate,true|9,12345678901234,OrgExc,Associate,true|10,04082993000149,IBICT,Associate,true"
    E a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" é da organização 10 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"

  Cenário: Saída de uma organização
    # Preparação de passos para uma proposta
    Dado o alvo "OrganizationImpl" para chamada da função "deleteOrganization(uint256)" com parâmetros "9"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Exclusão da OrgExc"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,NotVoted,Approval,Approval,NotVoted"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "OrganizationDeleted" foi emitido para a organização 9
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,NotVoted,Approval,Approval,NotVoted"
    # Verificando o resultado da execução, se organização foi excluída
    E verifico se a organização 9 está ativa o resultado é "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,DATAPREV,Associate,true|4,33555921000170,PUC-Rio,Partner,false|5,02641663000110,CPQD,Associate,true|6,03508097000136,RNP,Associate,true|7,16636540000104,Prodemge,Associate,true|8,33683111000107,SERPRO,Associate,true"

  Cenário: Cadastro de novo Administrador Global
    # Preparação de passos para uma proposta
    Dado o alvo "AccountRulesV2Impl" para chamada da função "addAccount(address,uint256,bytes32,bytes32)" com parâmetros "0xBcd4042DE499D14e55001CcbB24a551F3b954096,1,0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f,0x0000000000000000000000000000000000000000000000000000000000000000"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Novo administrador global do BNDES"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "AccountAdded" foi emitido para a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Verificando o resultado da execução, se organização e admin global foram criados
    E a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E verifico se a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" está ativa o resultado é "true"

  Cenário: Exclusão de Administrador Global
    # Preparação de passos para uma proposta
    Dado o alvo "AccountRulesV2Impl" para chamada da função "deleteAccount(address)" com parâmetros "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Exclusão de administrador global do BNDES"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "AccountDeleted" foi emitido para a conta "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" da organização 1
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Verificando o resultado da execução, se organização e admin global foram criados
    E se tento obter os dados da conta "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" ocorre erro "AccountNotFound"
    E verifico se a conta "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" está ativa o resultado é "false"

  Cenário: Perda de chave privada de Administrador Global / "Substituição" de Administrador Global
    # Simulando perda de chave privada do Administrador Global do BNDES
    # Preparação de passos para uma proposta
    Dado o alvo "AccountRulesV2Impl" para chamada da função "addAccount(address,uint256,bytes32,bytes32)" com parâmetros "0xBcd4042DE499D14e55001CcbB24a551F3b954096,1,0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f,0x0000000000000000000000000000000000000000000000000000000000000000"
    E o alvo "AccountRulesV2Impl" para chamada da função "deleteAccount(address)" com parâmetros "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Substituição de administrador global do BNDES"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "AccountAdded" foi emitido para a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096", organização 1, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    E o evento "AccountDeleted" foi emitido para a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" da organização 1
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Verificando o resultado da execução, se organização e admin global foram criados
    E a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E se tento obter os dados da conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" ocorre erro "AccountNotFound"
    E verifico se a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" está ativa o resultado é "false"

  Cenário: Restrição de acesso a smart contract
    # Verificando acesso ao smart contract 0x8888
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    # Preparação de passos para uma proposta
    Dado o alvo "AccountRulesV2Impl" para chamada da função "setSmartContractSenderAccess(address,bool,address[])" com parâmetros "0x0000000000000000000000000000000000008888,true,[0x71bE63f3384f5fb98995898A86B02Fb2426c5788;0xFABB0ac9d68B0B445fB7357272Ff202C5651694a]"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Restrição de acesso ao smart contract 0x8888"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000008888" com restrição "true" permitindo as contas "0x71bE63f3384f5fb98995898A86B02Fb2426c5788,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    # Verificando acesso ao smart contract 0x8888
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "true"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    Então a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    Então a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    Então a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"
    Então a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000008888" tem verificação de permissionamento "false"

  Cenário: Remoção de restrição de acesso a smart contract
    # Verificando acesso ao smart contract 0x9999
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    Então a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "false"
    # Preparação de passos para uma proposta
    Dado o alvo "AccountRulesV2Impl" para chamada da função "setSmartContractSenderAccess(address,bool,address[])" com parâmetros "0x0000000000000000000000000000000000009999,false,[]"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Remoção de restrição de acesso ao smart contract 0x9999"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E o evento "SmartContractSenderAccessUpdated" foi emitido para o smart contract "0x0000000000000000000000000000000000009999" com restrição "false" permitindo as contas ""
    # Verificando acesso ao smart contract 0x9999
    Então a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"
    Então a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" chamar o endereço "0x0000000000000000000000000000000000009999" tem verificação de permissionamento "true"

  Cenário: Cancelamento de uma proposta
    # Preparação de passos para uma proposta - 2
    Dado o alvo "AccountRulesV2Impl" para chamada da função "deleteAccount(address)" com parâmetros "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720"
    # Administrador Global do TCU cria uma proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cria proposta com descrição "Exclusão de administrador global do BNDES"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Porém, a Governança decidiu cancelar a proposta acima
    # Então, pode-se criar uma segunda proposta - 3 - para cancelar a primeira
    Dado o alvo "Governance" para chamada da função "cancelProposal(uint256,string)" com parâmetros "2,Proposta não deve seguir"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Cancelamento da proposta 2"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do RPN vota para aprovar a proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta 3
    E a proposta 3 tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
    # Administrador Global do CPQD executa a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta 3
    E o evento "ProposalExecuted" é emitido para a proposta 3
    E o evento "ProposalCanceled" é emitido para a proposta 2 com mensagem "Proposta não deve seguir"
    E a proposta 2 tem situação "Canceled", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    E a proposta 3 tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,Approval,Approval,Approval,Approval,NotVoted,Approval,NotVoted"
