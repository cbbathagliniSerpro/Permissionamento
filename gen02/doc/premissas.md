# Premissas

Premissas utilizadas para a elaboração dos [macroprocessos](macroprocessos.md) e definição de requisitos (histórias de usuário) da segunda geração dos *smart contracts* de permissionamento:

1. As contas (de administração ou não) e nós devem ser vinculadas a organizações.
2. O controle de acesso às funcionalidades será feito através de papeis – Role-Based Access Control (RBAC). Os seguintes papeis deverão ser criados:
   1. Administrador Global: Pode gerenciar o permissionamento de rede de forma global e também realizar a gestão local de sua organização, como um Administrador Local.
   2. Administrador Local: Pode gerenciar contas e nós da própria organização e fazer a implantação de aplicações.
   3. Implantador de Aplicações: Pode fazer a implantação de aplicações e enviar transações.
   4. Usuário de Aplicações: Pode enviar transações.
3. É necessário que exista ao menos um Administrador Global ativo para cada organização ativa.
4. Ações que afetem o funcionamento global da rede (ex.: reponteiramento de *smart contracts* de permissionamento ou a adição de uma nova organização) deverão ser votados pelas organizações, através de um de seus Administradores Globais.
5. Somente o mecanismo/*smart contract* de governança, através do qual as votações serão realizadas, terá acesso a funcionalidades de gestão global da rede.
   1. Administradores Globais, de forma isolada, **não** terão capacidade de realizar ações que afetem o funcionamento global da rede.
6. A implementação deve ser feita com base nos requisitos estritamente necessários. Deve-se:
   1. Modelar apenas atributos e funções que tenham sentido aos requisitos de negócio.
   2. Especificar consultas apenas que sejam necessários aos fluxos de negócio. As demais consultas podem ser implementadas *off chain* via dados de eventos.
