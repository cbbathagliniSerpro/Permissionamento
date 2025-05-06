# language: pt

Funcionalidade: Implantação da gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    # A conta 0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199 é utilizada como admin,
    # conforme conceito da primeira geração do permissionamento, que representará
    # o smart contract de governança/votação.
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin master

  Cenário: Implantação de smart contract
    # BNDES será organização 1
    Dado a organização "33657248000189" "BNDES" do tipo "Patron" com direito de voto "true"
    # TCU será organização 2
    E a organização "00414607000118" "TCU" do tipo "Patron" com direito de voto "false"
    Quando implanto o smart contract de gestão de organizações
    Então a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a organização 1 é "33657248000189" "BNDES" do tipo "Patron" e direito de voto "true"
    E a organização 2 é "00414607000118" "TCU" do tipo "Patron" e direito de voto "false"
    E a lista de organizações é "1,33657248000189,BNDES,Patron,true|2,00414607000118,TCU,Patron,false"

  Cenário: Implantação de smart contract com apenas uma organização
    Dado a organização "33657248000189" "BNDES" do tipo "Patron" com direito de voto "true"
    Quando implanto o smart contract de gestão de organizações
    Então ocorre erro na implantação do smart contract de gestão de organizações

  Cenário: Implantação de smart contract sem organizações
    Dado que não há organizações definidas
    Quando implanto o smart contract de gestão de organizações
    Então ocorre erro na implantação do smart contract de gestão de organizações
