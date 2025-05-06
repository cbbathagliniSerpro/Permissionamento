# language: pt

Funcionalidade: Governança do permissionamento - Cenários de consultas

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
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x01", limite de 30001 blocos e descrição "Proposta 1"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x02", limite de 30002 blocos e descrição "Proposta 2"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x03", limite de 30003 blocos e descrição "Proposta 3"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x04", limite de 30004 blocos e descrição "Proposta 4"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x05", limite de 30005 blocos e descrição "Proposta 5"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0x06", limite de 30006 blocos e descrição "Proposta 6"
    E a quantidade total de propostas é 6


  ##############################################################################
  # Consulta de propostas
  ##############################################################################
  
  Cenário: Consulta de todas as propoastas em uma única página
    Quando consulto as propostas a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de propostas é "1,0x01,30001,Proposta 1|2,0x02,30002,Proposta 2|3,0x03,30003,Proposta 3|4,0x04,30004,Proposta 4|5,0x05,30005,Proposta 5|6,0x06,30006,Proposta 6"
    Quando consulto as propostas a partir da página 1 com tamanho de página 6
    Então o resultado da consulta de propostas é "1,0x01,30001,Proposta 1|2,0x02,30002,Proposta 2|3,0x03,30003,Proposta 3|4,0x04,30004,Proposta 4|5,0x05,30005,Proposta 5|6,0x06,30006,Proposta 6"

  Cenário: Consulta de todas as propostas com página de um elemento apenas
    Quando consulto as propostas a partir da página 1 com tamanho de página 1
    Então o resultado da consulta de propostas é "1,0x01,30001,Proposta 1"
    Quando consulto as propostas a partir da página 2 com tamanho de página 1
    Então o resultado da consulta de propostas é "2,0x02,30002,Proposta 2"
    Quando consulto as propostas a partir da página 3 com tamanho de página 1
    Então o resultado da consulta de propostas é "3,0x03,30003,Proposta 3"
    Quando consulto as propostas a partir da página 4 com tamanho de página 1
    Então o resultado da consulta de propostas é "4,0x04,30004,Proposta 4"
    Quando consulto as propostas a partir da página 5 com tamanho de página 1
    Então o resultado da consulta de propostas é "5,0x05,30005,Proposta 5"
    Quando consulto as propostas a partir da página 6 com tamanho de página 1
    Então o resultado da consulta de propostas é "6,0x06,30006,Proposta 6"

  Cenário: Consulta de todas as propostas com paginação em sequência
    Quando consulto as propostas a partir da página 1 com tamanho de página 2
    Então o resultado da consulta de propostas é "1,0x01,30001,Proposta 1|2,0x02,30002,Proposta 2"
    Quando consulto as propostas a partir da página 2 com tamanho de página 2
    Então o resultado da consulta de propostas é "3,0x03,30003,Proposta 3|4,0x04,30004,Proposta 4"
    Quando consulto as propostas a partir da página 3 com tamanho de página 2
    Então o resultado da consulta de propostas é "5,0x05,30005,Proposta 5|6,0x06,30006,Proposta 6"

  Cenário: Consulta de todas as propostas com parâmetro de página inválido
    Quando consulto as propostas a partir da página 0 com tamanho de página 10
    Então ocorre erro "InvalidPaginationParameter" na consulta de proposta
    
  Cenário: Consulta de todas as propostas com parâmetro de tamanho de página inválido
    Quando consulto as propostas a partir da página 1 com tamanho de página 0
    Então ocorre erro "InvalidPaginationParameter" na consulta de proposta
    
  Cenário: Consulta de todas as propostas com paginação além do tamanho do resultado
    Quando consulto as propostas a partir da página 2 com tamanho de página 6
    Então o resultado da consulta de propostas é ""
    Quando consulto as propostas a partir da página 3 com tamanho de página 3
    Então o resultado da consulta de propostas é ""
    Quando consulto as propostas a partir da página 4 com tamanho de página 2
    Então o resultado da consulta de propostas é ""


