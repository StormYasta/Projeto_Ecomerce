# FATEC E-commerce

Sistema acadêmico de e-commerce desenvolvido para a disciplina/projeto da FATEC. O projeto possui uma API em Java com Spring Boot, um frontend em HTML/CSS/JavaScript puro e uma base de dados SQL Server estruturada com tabelas, views, functions, stored procedures e triggers.

## Visão geral

O sistema funciona como um painel administrativo para gerenciar as principais entidades de um e-commerce:

- Clientes  
- Colaboradores  
- Fornecedores  
- Produtos  
- Pedidos  
- Itens de pedido  
- Login de usuário

A aplicação foi organizada em três partes principais:

.

├── dba/                 \# Scripts do banco SQL Server

├── frontend/            \# Telas HTML, CSS e JavaScript

└── java/java/demo/      \# API Spring Boot

Nos arquivos enviados, o `pom.xml` do backend está em `java/java/demo`.

## Tecnologias utilizadas

### Backend

- Java 17  
- Spring Boot 3.5.13  
- Spring Web  
- Spring Data JPA  
- Spring Validation  
- Spring WebFlux  
- Lombok  
- Maven  
- SQL Server JDBC Driver

### Frontend

- HTML5  
- CSS3  
- JavaScript puro  
- Fetch API

### Banco de dados

- SQL Server  
- Tabelas relacionais  
- Views  
- Functions  
- Stored Procedures  
- Triggers  
- Script de carga/merge SQL em Python

## Funcionalidades

### Login

- Autenticação simples por login e senha com autenticação de token e role de usuário.  
- Usuário master é criado pelo script SQL de desenvolvimento.

### Clientes

- Cadastro de cliente com dados pessoais, e-mail, telefone, endereço e usuário.  
- Listagem de clientes.  
- Busca por ID.  
- Atualização de dados pessoais.  
- Inativação por soft delete.

### Colaboradores

- Cadastro de colaborador com função, salário, CTPS, CNH e dados pessoais.  
- Listagem de colaboradores.  
- Busca por ID.  
- Atualização de dados.  
- Inativação por soft delete.

### Fornecedores

- Cadastro de fornecedores.  
- Listagem geral.  
- Listagem apenas de fornecedores ativos.  
- Busca por ID.  
- Atualização.  
- Ativação e inativação.

### Produtos

- Cadastro de produtos vinculados a fornecedores.  
- Controle de preço de venda, custo, estoque e imagem.  
- Listagem de produtos.  
- Busca por ID.  
- Atualização.  
- Ativação e inativação.

### Pedidos

- Criação de pedido vinculado a cliente.  
- Listagem de pedidos.  
- Busca por ID.  
- Alteração de status.  
- Cancelamento de pedido.  
- Adição, atualização, listagem e remoção de itens do pedido.  
- Baixa de estoque por trigger no banco de dados.

## Arquitetura do projeto

Fluxo geral da aplicação:

Frontend HTML/CSS/JS

        ↓ fetch API

API REST Spring Boot

        ↓ Repositories JPA / queries nativas

SQL Server

        ↓

Stored Procedures, Views, Functions e Triggers

O backend não utiliza apenas operações automáticas do JPA. As principais operações de escrita são feitas por procedures no SQL Server, enquanto consultas usam views e functions.

## Estrutura de pastas

frontend/

├── index.html                \# Tela de login

├── dashboard.html            \# Painel principal

├── style.css                 \# Estilos globais

├── utils.js                  \# Máscaras e funções auxiliares

├── cliente/                  \# CRUD de clientes

├── colaborador/              \# CRUD de colaboradores

├── fornecedor/               \# CRUD de fornecedores

├── produto/                  \# CRUD de produtos

└── pedido/                   \# Cadastro, status, visualização e itens de pedido

java/java/demo/

├── pom.xml

├── mvnw / mvnw.cmd

└── src/main/

    ├── java/com/projeto/fatec/

    │   ├── classes/

    │   │   ├── cliente/

    │   │   ├── colaborador/

    │   │   ├── fornecedor/

    │   │   ├── pedido/

    │   │   ├── pessoa/

    │   │   ├── produto/

    │   │   └── usuario/

    │   ├── exception/

    │   ├── login/

    │   └── utils/

    └── resources/

        └── application.properties

dba/

├── db\_full\_create.sql              \# Script completo do banco

├── tables/                         \# Criação das tabelas

├── views/                          \# Views de consulta

├── procedures/                     \# Procedures e functions

├── triggers/                       \# Triggers

├── user/                           \# Usuário e usuário master

├── merge-sql.py                    \# Gera o db\_full\_create.sql

└── injeta\_mock\_ecommerce.py        \# Script opcional para inserir dados mockados

## Pré-requisitos

Antes de rodar o projeto, instale:

- Java 17 ou superior  
- SQL Server  
- SQL Server Management Studio ou Azure Data Studio  
- Maven, opcional, pois o projeto possui Maven Wrapper  
- Python 3, opcional, apenas para scripts auxiliares do DBA  
- Navegador web

## Configuração do banco de dados

O banco utilizado pelo projeto se chama:

dev\_projeto\_fatec\_ecomerce

Atenção: o nome no script está como `ecomerce`, com apenas um `m`.

### 1\. Criar login do SQL Server

O arquivo `dba/user/user.sql` possui o comando de criação de login comentado. Antes de executar o script completo, crie o login usado pela API ou ajuste o `application.properties`.

Exemplo:

CREATE LOGIN projeto\_fatec

WITH PASSWORD \= 'sua\_senha\_aqui';

GO

Depois, mantenha o mesmo usuário e senha no backend.

### 2\. Executar o script completo

Execute o arquivo abaixo no SQL Server:

dba/db\_full\_create.sql

Esse script cria:

- Database  
- Tabelas  
- Inserts iniciais de status, roles e funções  
- Views  
- Functions  
- Stored procedures  
- Usuário de banco  
- Usuário master de desenvolvimento

### 3\. Conferir a conexão da API

No backend, confira o arquivo:

java/java/demo/src/main/resources/application.properties

Exemplo de configuração:

spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=dev\_projeto\_fatec\_ecomerce;encrypt=true;trustServerCertificate=true

spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

spring.datasource.username=projeto\_fatec

spring.datasource.password=sua\_senha\_aqui

Não é recomendado subir senhas reais no GitHub. Para produção, o ideal é usar variáveis de ambiente.

## Como rodar o backend

Entre na pasta onde está o `pom.xml`:

cd java/java/demo

No Windows:

mvnw.cmd spring-boot:run

No Linux/macOS:

./mvnw spring-boot:run

A API ficará disponível em:

http://localhost:8080

Para gerar o `.jar`:

./mvnw clean package

Para executar o `.jar` gerado:

java \-jar target/fatec-ecommerce-0.0.1-SNAPSHOT.jar

## Como rodar o frontend

O frontend consome a API em:

http://localhost:8080

As URLs estão definidas diretamente nos arquivos `.js` e no `index.html`.

Você pode abrir o arquivo `frontend/index.html` diretamente no navegador ou servir a pasta localmente.

Exemplo com Python:

cd frontend

python \-m http.server 5500

Depois acesse:

http://localhost:5500/index.html

## Login inicial

O script SQL cria um usuário master para desenvolvimento.

Login: master

Senha: definida no script user.sql

No script atual, a senha é armazenada diretamente no campo `senha_hash`. Para ambiente real, é recomendado implementar hash de senha e autenticação com token.

## Endpoints da API

### Login

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/login` | Valida login e senha |

Body esperado:

{

  "login": "master",

  "senha": "sua\_senha"

}

### Clientes

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/clientes` | Cadastra cliente |
| GET | `/clientes` | Lista clientes |
| GET | `/clientes/{id}` | Busca cliente por ID |
| PUT | `/clientes/{id}` | Atualiza cliente |
| DELETE | `/clientes/{id}` | Inativa cliente |

### Colaboradores

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/colaboradores` | Cadastra colaborador |
| GET | `/colaboradores` | Lista colaboradores |
| GET | `/colaboradores/{id}` | Busca colaborador por ID |
| PUT | `/colaboradores/{id}` | Atualiza colaborador |
| DELETE | `/colaboradores/{id}` | Inativa colaborador |
| GET | `/funccolaboradores` | Lista funções de colaboradores |

### Fornecedores

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/fornecedores` | Cadastra fornecedor |
| GET | `/fornecedores` | Lista fornecedores |
| GET | `/fornecedores/ativos` | Lista fornecedores ativos |
| GET | `/fornecedores/{id}` | Busca fornecedor por ID |
| PUT | `/fornecedores/{id}` | Atualiza fornecedor |
| PUT | `/fornecedores/ativar/{id}` | Ativa fornecedor |
| DELETE | `/fornecedores/{id}` | Inativa fornecedor |

### Produtos

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/produtos` | Cadastra produto |
| GET | `/produtos` | Lista produtos |
| GET | `/produtos/{id}` | Busca produto por ID |
| PUT | `/produtos/{id}` | Atualiza produto |
| PUT | `/produtos/ativar/{id}` | Ativa produto |
| DELETE | `/produtos/{id}` | Inativa produto |

### Pedidos

| Método | Rota | Descrição |
| :---- | :---- | :---- |
| POST | `/pedidos` | Cria pedido |
| GET | `/pedidos` | Lista pedidos |
| GET | `/pedidos/{id}` | Busca pedido por ID |
| PUT | `/pedidos/{id}/status` | Atualiza status do pedido |
| DELETE | `/pedidos/{id}` | Cancela pedido |
| GET | `/pedidos/{id}/itens` | Lista itens do pedido |
| POST | `/pedidos/{id}/itens` | Adiciona item ao pedido |
| PUT | `/pedidos/{id}/itens/{produtoId}` | Atualiza quantidade de item |
| DELETE | `/pedidos/{id}/itens/{produtoId}` | Remove item do pedido |

## Exemplos de requisições

### Cadastrar fornecedor

{

  "nome": "Fornecedor Exemplo",

  "cnpj": "12345678000199",

  "email": "contato@fornecedor.com",

  "telefone": "17999999999",

  "descricao": "Fornecedor de peças e acessórios"

}

### Cadastrar produto

{

  "nome": "Motor Ventilador",

  "descricao": "Motor para refrigeração",

  "precoVenda": 189.90,

  "precoCusto": 120.00,

  "estoque": 10,

  "fornecedorId": 1,

  "imagemUrl": "https://exemplo.com/imagem.jpg"

}

### Criar pedido

{

  "clienteId": 1

}

### Adicionar item ao pedido

{

  "produtoId": 1,

  "quantidade": 2,

  "valorPago": 189.90

}

### Atualizar status do pedido

{

  "statusId": 2

}

## Scripts auxiliares

### Gerar script SQL completo

O arquivo `merge-sql.py` junta os scripts das subpastas em um único `db_full_create.sql`.

Exemplo:

cd dba

python merge-sql.py . tables views procedures user

### Injetar dados mockados

O arquivo `injeta_mock_ecommerce.py` insere dados de um arquivo Excel no banco.

Dependências:

pip install pandas openpyxl pyodbc

Exemplo com usuário e senha:

python injeta\_mock\_ecommerce.py \--server localhost \--database dev\_projeto\_fatec\_ecomerce \--user sa \--password SUA\_SENHA

Exemplo com autenticação integrada do Windows:

python injeta\_mock\_ecommerce.py \--server localhost \--database dev\_projeto\_fatec\_ecomerce \--trusted

Para limpar os dados mockados antes de inserir novamente:

python injeta\_mock\_ecommerce.py \--server localhost \--database dev\_projeto\_fatec\_ecomerce \--trusted \--reset

O script espera o arquivo `dados_mock_ecommerce_estatistica.xlsx`, salvo na mesma pasta, ou um caminho informado com `--xlsx`.

## Observações importantes

- A API está configurada para rodar na porta `8080`.  
- O frontend está apontando diretamente para `http://localhost:8080`.  
- Os controllers usam `@CrossOrigin(origins = "*")`, permitindo requisições do frontend local.  
- O projeto usa soft delete para algumas entidades, como pessoas, fornecedores e produtos.  
- O controle de estoque é tratado no banco, incluindo trigger para baixa ao inserir item no pedido.  
- O login atual compara a senha enviada com o valor salvo em `senha_hash`, sem criptografia real.

## Possíveis problemas e soluções

### Erro de versão do Java

O projeto exige Java 17\. Verifique com:

java \-version

Se aparecer Java 8, instale o Java 17 e configure o `JAVA_HOME`.

### API não conecta no banco

Confira:

- SQL Server está rodando  
- Porta `1433` está liberada  
- Banco `dev_projeto_fatec_ecomerce` existe  
- Usuário e senha no `application.properties` estão corretos  
- O login SQL Server foi criado antes do usuário de banco

### Frontend mostra erro ao conectar

Confira:

- Backend está rodando em `http://localhost:8080`  
- SQL Server está conectado corretamente  
- O arquivo JS aponta para a porta correta  
- O navegador não bloqueou a requisição

### Produto não cadastra

Confira se existe pelo menos um fornecedor ativo. O cadastro de produto depende de `fornecedorId`.

### Pedido não recebe item

Confira:

- Pedido existe  
- Produto existe  
- Produto possui estoque suficiente  
- Produto não está inativo

## Melhorias futuras

- Implementar autenticação com JWT.  
- Criptografar senhas com BCrypt.  
- Remover senhas fixas dos arquivos e usar variáveis de ambiente.  
- Criar documentação Swagger/OpenAPI.  
- Adicionar testes automatizados.  
- Padronizar respostas JSON da API.  
- Centralizar a URL da API no frontend.  
- Criar tratamento visual de erros no painel.  
- Criar Docker Compose com API e SQL Server.  
- Melhorar o controle de permissões por tipo de usuário.

## Status do projeto

Projeto funcional em ambiente local, com foco acadêmico, contendo integração entre frontend, API REST e banco SQL Server.  
