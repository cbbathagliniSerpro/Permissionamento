# language: pt

Funcionalidade: Governança do permissionamento

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
    # OrgExc será organização 6
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
    # Administrador global da organização 6 - OrgExc
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Governança adiciona conta de administração local para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" na organização 1 com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Governança adiciona conta de implantação para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" na organização 1 com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Governança adiciona conta de usuário para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" na organização 1 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    # Verificando cadastro das organizações
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,DATAPREV,Associate,true|4,33555921000170,PUC-Rio,Partner,false|5,02641663000110,CPQD,Associate,true|6,12345678901234,OrgExc,Associate,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" é da organização 1 com papel "DEPLOYER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000003" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 4 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" é da organização 5 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 6 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Governança exclui OrgExc
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 6
    E verifico se a organização 6 está ativa o resultado é "false"
    E verifico se a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" está ativa o resultado é "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,true|3,42422253000101,DATAPREV,Associate,true|4,33555921000170,PUC-Rio,Partner,false|5,02641663000110,CPQD,Associate,true"
    E implanto o smart contract de governança do permissionamento
    E a implantação do smart contract de governança do permissionamento ocorre com sucesso
    E implanto um smart contract mock para que sofra ações da governança
    E a implantação do smart contract mock ocorre com sucesso


  # Sobre os calldatas, deve-se utilizar a especificação de ABI: https://docs.soliditylang.org/en/v0.8.28/abi-spec.html
  # Function selector: https://docs.soliditylang.org/en/v0.8.28/abi-spec.html#function-selector

  # ExecutionMock.setCode(uint256)
  #
  #   setCode(uint256) -> Keccak-256 de setCode(uint256) = dfc0bedb739978f9c7b224cfb7e74eb506194e6201f65e1cd77cf48815596d91
  #   function selector -> 4 primeiros bytes = dfc0bedb
  #   Observação: Não pode ser setCode(uint), tem que ser setCode(uint256). uint é alias para uint256. (https://docs.soliditylang.org/en/v0.8.28/types.html#integers)
  #
  #   2024 -> ABI Encode de um uint256 -> 00000000000000000000000000000000000000000000000000000000000007e8
  #
  #   Logo, o calldata para a chamada ExecutionMock.setCode(2024) é dfc0bedb00000000000000000000000000000000000000000000000000000000000007e8

  # ExecutionMock.setMessage(string)
  #
  #   setMessage(string) -> Keccak-256 de setMessage(string) = 368b8772abb9fe9b0c79f44896ca2616a6823123c811ce2be7d997dd9e193269
  #   function selector -> 4 primeiros bytes = 368b8772
  #
  #   "Dois mil e vinte e quatro" -> ABI Encode de uma string -> 00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000019446f6973206d696c20652076696e746520652071756174726f00000000000000
  #
  #   Logo, o calldata para a chamada ExecutionMock.setMessage("Dois mil e vinte e quatro") é 368b877200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000019446f6973206d696c20652076696e746520652071756174726f00000000000000

  ##############################################################################
  # Criação de proposta
  ##############################################################################

  Cenário: Criação de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"

  Cenário: Tentativa de criar proposta com perfis de acesso sem privilégio
    # Administrador Local do BNDES tenta criar uma proposta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    
    # Implantador de smart contracts do BNDES tenta criar uma proposta
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    
    # Usuário do BNDES tenta criar uma proposta
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com conta inativa
    # Administrador Global da OrgExc tenta criar uma proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com conta não cadastrada
    # Conta não cadastrada tenta criar uma proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com as listas de targets e calldatas de tamanhos diferentes
    # Administrador Global do BNDES tenta criar uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvos "0x0000000000000000000000000000000000000001", com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8,0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "InvalidArgument" na criação da proposta    

  Cenário: Tentativa de criar proposta com duração de zero blocos
    # Administrador Global do BNDES tenta criar uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 0 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "InvalidArgument" na criação da proposta    

  Cenário: Tentativa de criar proposta sem descrição
    # Administrador Global do BNDES tenta criar uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição ""
    Então ocorre erro "InvalidArgument" na criação da proposta    


  ##############################################################################
  # Cancelamento de proposta
  ##############################################################################

  Cenário: Cancelamento de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta com mensagem "O cadastramento da proposta foi feito de forma errada"
    E a proposta tem situação "Canceled", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    E o motivo de cancelamento da proposta é "O cadastramento da proposta foi feito de forma errada"

  Cenário: Cancelamento de proposta por outro Administrador Global da mesma organização
    # Governança adiciona nova conta de Administrador Global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Segundo Administrador Global do BNDES cancela a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta com mensagem "O cadastramento da proposta foi feito de forma errada"
    E a proposta tem situação "Canceled", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"

  Cenário: Cancelamento de proposta com resultado já definido
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global do BNDES tenta cancelar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "Proposta não deve mais ser executada"
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta com mensagem "Proposta não deve mais ser executada"
    E a proposta tem situação "Canceled", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"

  Cenário: Cancelamento de proposta via Governança
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Governança cancela a proposta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta com mensagem "O cadastramento da proposta foi feito de forma errada"
    E a proposta tem situação "Canceled", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    E o motivo de cancelamento da proposta é "O cadastramento da proposta foi feito de forma errada"

  Cenário: Tentativa de cancelamento de proposta com Administrador Global de outra organização
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do TCU tenta cancelar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" cancela a proposta com motivo "Proposta indecorosa"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta com conta inativa
    # Governança adiciona a OrgExc2 como organização 7
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "43210987654321" "OrgExc" do tipo "Associate" e direito de voto "true"
    Então a organização 7 é "43210987654321" "OrgExc" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 7 está ativa o resultado é "true"
    # Governança adiciona novo administrador global para a OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" na organização 7 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Novo administrador global cadastra nova proposta
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,7" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Governança exclui a organização 7 - OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 7
    # Então a OrgExc2 e suas contas ficam inativas
    E verifico se a organização 7 está ativa o resultado é "false"
    E verifico se a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" está ativa o resultado é "false"
    # Novo administrador global tenta cancelar a proposta
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta com perfis de acesso sem privilégio
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Local do BNDES tenta cancelar proposta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta
    # Implantador de smart contracts do BNDES tenta cancelar a proposta
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta
    # Usuário do BNDES tenta cancelar a proposta
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta com conta não cadastrada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Conta não cadastrada tenta cancelar proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta inexistente
    # Administrador Global do BNDES tenta cancelar uma proposta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta 1
    Então ocorre erro "ProposalNotFound" no cancelamento da proposta
  
  Cenário: Tentativa de cancelamento de proposta já cancelada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta com mensagem "O cadastramento da proposta foi feito de forma errada"
    # Administrador Global do BNDES tenta cancelar a proposta novamente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "Cancelando novamente!"
    Então ocorre erro "IllegalState" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta encerrada
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    # Administrador Global do BNDES tenta cancelar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "A proposta deve ser desfeita!"
    Então ocorre erro "IllegalState" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta sem razão de cancelamento
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES tenta cancelar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo ""
    Então ocorre erro "InvalidArgument" no cancelamento da proposta


  ##############################################################################
  # Envio de votos
  ##############################################################################

  Cenário: Aprovação de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 5
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 2
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 3
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,Rejection,Approval"

  Cenário: Rejeição de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Rejection,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 5
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Rejection,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para rejeitar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 2
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Rejection,Rejection,NotVoted,Approval"
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 3
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3,5" e votos "Rejection,Rejection,Rejection,Approval"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Empate e consequente rejeição de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 2
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para rejeitar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 5
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Rejection"
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 3
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3,5" e votos "Approval,Approval,Rejection,Rejection"
    # Proposta não chega a ter aprovação da maioria, então é rejeitada
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Encerramento de proposta por tempo de duração
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,NotVoted"

  Cenário: Encerramento de proposta aprovada
    # Administrador Global do BNDES cria uma proposta com apenas 3 blocos de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 5
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Approval,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela organização 2
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Já foram "gastos 3 blocos", então a duração da proposta já esgotou
    # Administrador Global da Dataprev tenta enviar voto para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"

  Cenário: Encerramento de proposta rejeitada
    # Administrador Global do BNDES cria uma proposta com apenas 3 blocos de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta com alvo do smart contract de teste, dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 1
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Rejection,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para rejeitar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 5
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "Rejection,NotVoted,NotVoted,Rejection"
    # Administrador Global do TCU vota para rejeitar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela organização 2
    E a proposta tem situação "Active", resultado "Rejected", organizações "1,2,3,5" e votos "Rejection,Rejection,NotVoted,Rejection"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta
    # Já foram "gastos 3 blocos", então a duração da proposta já esgotou
    # Administrador Global da Dataprev tenta enviar voto para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Rejected", organizações "1,2,3,5" e votos "Rejection,Rejection,NotVoted,Rejection"

  Cenário: Tentativa de envio de voto repetido
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    # Administrador Global do BNDES tenta votar novamente para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto
    # Governança adiciona um segundo Administrador Global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # O novo Administrador Global do BNDES tenta votar novamente pelo BNDES para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto

  Cenário: Tentativa de envio de voto por organização não participante
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Governança adiciona a NovaOrg como organização 7
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "43210987654321" "NovaOrg" do tipo "Associate" e direito de voto "true"
    Então a organização 7 é "43210987654321" "NovaOrg" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 7 está ativa o resultado é "true"
    # Governança adiciona novo administrador global para a NovaOrg
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" na organização 7 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E verifico se a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" está ativa o resultado é "true"
    # Administrador Global da NovaOrg (que não participa da proposta) tenta enviar voto
    Quando a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto por organização sem direito a voto
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global da PUC-Rio (sem direito a voto) tenta enviar voto
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com perfis de acesso sem privilégio
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Local do BNDES tenta enviar voto
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto
    # Implantador de smart contracts do BNDES tenta enviar voto
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto
    # Usuário contracts do BNDES tenta enviar voto
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com conta inativa
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global da OrgExc tenta enviar voto
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com conta não cadastrada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Conta não cadastrada tenta enviar voto
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto para proposta inexistente
    # Administrador Global do BNDES tenta enviar voto para uma proposta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval" para a proposta 1
    Então ocorre erro "ProposalNotFound" no envio do voto
  
  Cenário: Tentativa de envio de voto para proposta encerrada
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    # Administrador Global do CPQD tenta enviar voto para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto

  Cenário: Tentativa de envio de voto para proposta cancelada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então a proposta é cancelada com sucesso
    # Administrador Global do CPQD tenta enviar voto para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto

  
  ##############################################################################
  # Execução de propostas
  ##############################################################################
  
  Cenário: Execução de proposta com uma única ação
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Consultamos o smart contract de teste
    Quando consulto o código do smart contract de teste o resultado é 0
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Consultamos o smart contract de teste para obter novo resultado, ajustado pela execução da proposta
    Quando consulto o código do smart contract de teste o resultado é 2024
  
  Cenário: Execução de proposta com duas ações
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8,0x368b877200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000019446f6973206d696c20652076696e746520652071756174726f00000000000000", limite de 30000 blocos e descrição "Ajustando código e mensagem para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Consultamos o smart contract de teste
    Quando consulto o código do smart contract de teste o resultado é 0
    Quando consulto a mensagem do smart contract de teste o resultado é "No message"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Consultamos o smart contract de teste para obter novo resultado, ajustado pela execução da proposta
    Quando consulto o código do smart contract de teste o resultado é 2024
    Quando consulto a mensagem do smart contract de teste o resultado é "Dois mil e vinte e quatro"

  Cenário: Execução de proposta após encerramento por duração
    # Administrador Global do BNDES cria uma proposta com apenas 3 blocos de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Já foram "gastos 3 blocos", então a duração da proposta já esgotou
    # Administrador Global da Dataprev tenta enviar voto para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Consultamos o smart contract de teste
    Quando consulto o código do smart contract de teste o resultado é 0
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalExecuted" é emitido para a proposta
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Consultamos o smart contract de teste para obter novo resultado, ajustado pela execução da proposta
    Quando consulto o código do smart contract de teste o resultado é 2024

  Cenário: Execução de proposta com erro devido a parâmetros errados
    # Administrador Global do BNDES cria uma proposta com erro no segundo calldata
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8,0x368b8772", limite de 30000 blocos e descrição "Ajustando código e mensagem para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Consultamos o smart contract de teste
    Quando consulto o código do smart contract de teste o resultado é 0
    E consulto a mensagem do smart contract de teste o resultado é "No message"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então ocorre erro "FailedCall" na execução da proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Verificando que o estado inicial do smart contract de teste não mudou
    E consulto o código do smart contract de teste o resultado é 0
    E consulto a mensagem do smart contract de teste o resultado é "No message"
    # Administrador Global do BNDES cancela a proposta que não poderá ser executada
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "Proposta não poderá ser executada"
    Então a proposta é cancelada com sucesso
    E a proposta tem situação "Canceled", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
  
  Cenário: Execução de proposta com chamada que é revertida
    # Administrador Global do BNDES cria uma proposta cuja segunda chamada será revertida
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8,0x30af58d2", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Consultamos o smart contract de teste
    Quando consulto o código do smart contract de teste o resultado é 0
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então ocorre erro "FailedCall" na execução da proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"
    # Verificando que o estado inicial do smart contract de teste não mudou
    E consulto o código do smart contract de teste o resultado é 0
    E consulto a mensagem do smart contract de teste o resultado é "No message"
    # Administrador Global do BNDES cancela a proposta que não poderá ser executada
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "Proposta não poderá ser executada"
    Então a proposta é cancelada com sucesso
    E a proposta tem situação "Canceled", resultado "Approved", organizações "1,2,3,5" e votos "Approval,Approval,NotVoted,Approval"

  Cenário: Tentativa de execução de proposta sem resultado definido
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então ocorre erro "IllegalState" na execução da proposta
  
  Cenário: Tentativa de execução de proposta já executada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalExecuted" é emitido para a proposta
    # Administrador Global do BNDES executa a proposta novamente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então ocorre erro "IllegalState" na execução da proposta
  
  Cenário: Tentativa de execução de proposta cancelada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta com motivo "Proposta não deve mais ser executada"
    Então a proposta é cancelada com sucesso
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então ocorre erro "IllegalState" na execução da proposta
  
  Cenário: Tentativa de execução de proposta com perfis de acesso sem privilégio
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Local do BNDES tenta executar a proposta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" executa a proposta
    Então ocorre erro "UnauthorizedAccess" na execução da proposta
    # Implantador de smart contracts do BNDES tenta executar a proposta
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" executa a proposta
    Então ocorre erro "UnauthorizedAccess" na execução da proposta
    # Usuário do BNDES tenta executar a proposta
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" executa a proposta
    Então ocorre erro "UnauthorizedAccess" na execução da proposta

  Cenário: Tentativa de execução de proposta com conta inativa
    # Governança adiciona a OrgExc2 como organização 7
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "43210987654321" "OrgExc" do tipo "Associate" e direito de voto "true"
    Então a organização 7 é "43210987654321" "OrgExc" do tipo "Associate" e direito de voto "true"
    E verifico se a organização 7 está ativa o resultado é "true"
    # Governança adiciona novo administrador global para a OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" na organização 7 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Governança exclui a organização 7 - OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 7
    # Então a OrgExc2 e suas contas ficam inativas
    E verifico se a organização 7 está ativa o resultado é "false"
    E verifico se a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" está ativa o resultado é "false"
    # Administrador Global da OrgExc2 tenta cancelar a proposta
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" cancela a proposta com motivo "O cadastramento da proposta foi feito de forma errada"
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de execução de proposta com conta não cadastrada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Conta não cadastrada tenta executar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" executa a proposta
    Então ocorre erro "UnauthorizedAccess" na execução da proposta


  ##############################################################################
  # Consulta de proposta e votos
  ##############################################################################

  Cenário: Consulta de proposta e votos
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xdfc0bedb00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    
  Cenário: Consulta de proposta não existente
    Quando um observador consulta a proposta 1 ocorre erro "ProposalNotFound"
    Quando um observador consulta a proposta 0 ocorre erro "ProposalNotFound"
