# language: pt

Funcionalidade: Mock de admin

  Cenário: Teste básico do mock de admin
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é admin master
    E o endereço "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é admin master
    Então a autorização para o endereço "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é "true"
    E a autorização para o endereço "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é "true"
    E a autorização para o endereço "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" é "false"
    E a autorização para o endereço "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é "false"
