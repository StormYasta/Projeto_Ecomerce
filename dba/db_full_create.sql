-- ============================================================
-- Subpasta: tables
-- ============================================================

-- ------------------------------------------------------------
-- Arquivo: tables_pessoas.sql
-- ------------------------------------------------------------
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DA BASE DE DADOS -----------------
------------------------------------------------------------------------------------------------------
CREATE DATABASE dev_projeto_fatec_ecomerce;
GO
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS TABELAS -----------------
------------------------------------------------------------------------------------------------------

/* 
 Tabela de status de pessoa.

	Relacionamentos:
		Envia chave primária para TB_pessoas(status_id).
*/
	

CREATE TABLE TB_status_pessoa (
	id			INT			NOT NULL IDENTITY,
	descricao	VARCHAR(55)	NOT NULL,

	CONSTRAINT PK_TB_status_pessoas	PRIMARY KEY (id),
	CONSTRAINT UQ_TB_status_pessoas	UNIQUE		(descricao)
);
INSERT INTO TB_status_pessoa (descricao) VALUES
('ATIVO'),
('INATIVO'),
('SUSPENSO'),
('BLOQUEADO');
SELECT * FROM TB_status_pessoa;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de pessoas.
	
	Relacionamentos:
		Recebe chave estrangeira de TB_status(id) para status_id;
		Envia chave primária para TB_enderecos(pessoa_id);
		Envia chave primária para TB_emails(pessoa_id);
		Envia chave primária para TB_telefones(pessoa_id);
		
		Herança nas tabelas TB_clientes, TB_colaboradores.
*/

CREATE TABLE TB_pessoas (
	id					BIGINT			NOT NULL	IDENTITY,
	nome				VARCHAR	(55)	NOT NULL,
	sobrenome			VARCHAR (55)	NOT NULL,	
	cpf					VARCHAR	(11)	NOT NULL,
	status_id			INT				NOT NULL,
	data_cadastro		DATETIME		NOT NULL	DEFAULT GETDATE(),
	data_nascimento		DATE			NOT NULL,

	created_at			DATETIME		NOT NULL	DEFAULT GETDATE(),
	updated_at			DATETIME		NOT NULL	DEFAULT GETDATE(),
	deleted_at			DATETIME			NULL	DEFAULT (NULL),

	CONSTRAINT PK_TB_pessoas				PRIMARY KEY (id),
	CONSTRAINT FK_TB_pessoas_status			FOREIGN KEY (status_id)	REFERENCES TB_status_pessoa(id),
	CONSTRAINT UQ_TB_pessoas_cpf			UNIQUE		(cpf),
	CONSTRAINT CK_TB_pessoas_cpf			CHECK		(LEN(cpf) = 11 AND cpf NOT LIKE '%[^0-9]%')
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de endereços de Pessoas.
	
	Relacionamentos:
		Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
		Entidade fraca de TB_pessoas.
		
*/
CREATE TABLE TB_enderecos_pessoas (
	id				BIGINT			NOT NULL IDENTITY,
	pessoa_id		BIGINT			NOT NULL,
    cep				VARCHAR(8)		NOT NULL,	
	numero			VARCHAR(5)		NOT NULL,
    logradouro		VARCHAR(255)	NOT NULL,
	bairro			VARCHAR(55)		NOT NULL,
  	cidade			VARCHAR(255)	NOT NULL,
  	uf				VARCHAR(2)		NOT NULL,
	principal		BIT				NOT NULL	DEFAULT (0),

	complemento		VARCHAR(255)		NULL,

	CONSTRAINT PK_TB_enderecos_pessoas		PRIMARY KEY (id, pessoa_id),
	CONSTRAINT FK_TB_enderecos_pessoa		FOREIGN KEY (pessoa_id)					REFERENCES TB_pessoas(id),
	CONSTRAINT UQ_TB_enderecos_cep 			UNIQUE		(pessoa_id, cep, numero),
	CONSTRAINT CK_TB_enderecos_uf			CHECK		(uf IN ('AC', 'AL', 'AP', 
																'AM', 'BA', 'CE', 
																'DF', 'ES', 'GO', 
																'MA', 'MT', 'MS', 
																'MG', 'PA', 'PB', 
																'PR', 'PE', 'PI', 
																'RJ', 'RN', 'RS', 
																'RO', 'RR', 'SC', 
																'SP', 'SE', 'TO'))
);

CREATE UNIQUE INDEX UX_endereco_principal
ON TB_enderecos_pessoas (pessoa_id)
WHERE principal = 1

GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de E-mails de Pessoas.
	
	Relacionamentos:
		Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
		Entidade fraca de TB_pessoas.
		
*/
CREATE TABLE TB_emails_pessoas (
	id				BIGINT			NOT NULL	IDENTITY ,
	pessoa_id		BIGINT			NOT NULL,
	email			VARCHAR(55)		NOT NULL,
	principal		BIT					NULL	DEFAULT (0),

	CONSTRAINT PK_TB_emails_pessoa				PRIMARY KEY (id, pessoa_id),
	CONSTRAINT FK_TB_emails_pessoa				FOREIGN KEY (pessoa_id) REFERENCES TB_pessoas(id),
	CONSTRAINT UQ_TB_emails_email_pessoa		UNIQUE		(pessoa_id, email),
	CONSTRAINT CK_TB_emails_formato_pessoa		CHECK		(email LIKE '%_@__%.__%')
);

CREATE UNIQUE INDEX UX_email_principal
ON TB_emails_pessoas (pessoa_id)
WHERE principal = 1

GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de Telefones de Pessoas.

	Relacionamentos:
		Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
		Entidade fraca de TB_pessoas.
		
*/
CREATE TABLE TB_telefones_pessoas (
	id				BIGINT			NOT NULL	IDENTITY,
	pessoa_id		BIGINT			NOT NULL,
	telefone		VARCHAR(55)		NOT NULL,
	principal		BIT				NOT NULL	DEFAULT (0),

	CONSTRAINT PK_TB_telefones_pessoa			PRIMARY KEY (id, pessoa_id),
	CONSTRAINT FK_TB_telefones_pessoa			FOREIGN KEY (pessoa_id) REFERENCES TB_pessoas(id),
	CONSTRAINT UQ_TB_telefones_telefone_pesssoa	UNIQUE		(pessoa_id, telefone),
	CONSTRAINT CK_TB_telefones_formato_pessoa	CHECK		(telefone NOT LIKE '%[^0-9]%' AND LEN(telefone) BETWEEN 8 AND 15)
);


CREATE UNIQUE INDEX UX_telefone_principal
ON TB_telefones_pessoas (pessoa_id)
WHERE principal = 1

GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de clientes.
 
	Relacionamentos:
		Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
		Herança de TB_pessoas.
*/
CREATE TABLE TB_clientes (
	
	pessoa_id			BIGINT		NOT NULL,

	CONSTRAINT PK_TB_clientes				PRIMARY KEY (pessoa_id),
	CONSTRAINT FK_TB_clientes				FOREIGN KEY (pessoa_id)		REFERENCES TB_pessoas(id)

);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/*
	Tabela de funções de colaboradores.

		Relacionamentos:
			Envia chave primária para TB_colaboradores(funcao).
*/
CREATE TABLE TB_funcoes_colaboradores (
	id				INT				NOT NULL IDENTITY,
	descricao		VARCHAR(55)		NOT NULL,
	salario_base	DECIMAL(12, 2)	NOT NULL,
	ativo			BIT				NOT NULL DEFAULT (1),

	CONSTRAINT PK_TB_funcoes_colaboradores				PRIMARY KEY (id),
	CONSTRAINT UQ_TB_funcoes_colaboradores_descricao	UNIQUE (descricao)
);

INSERT INTO TB_funcoes_colaboradores (descricao, salario_base) VALUES
('GERENTE',			5000.00),
('ANALISTA',		3000.00),
('DESENVOLVEDOR',	2500.00),
('SUPORTE',			2000.00);
SELECT * FROM TB_funcoes_colaboradores;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de colaboradores.
 
	Relacionamentos:
		Recebe chave estrangeira de TB_funcoes_colaboradores(id) para funcao;
		Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
		Herança de TB_pessoas.
*/

CREATE TABLE TB_colaboradores (
	
	pessoa_id				BIGINT			NOT NULL,
	funcao					INT				NOT NULL,
	salario_inicial			DECIMAL(12, 2)	NOT NULL,
	salario_atual			DECIMAL(12, 2)	NOT NULL,
	data_registro			DATE			NOT NULL,
	num_carteira_trabalho	VARCHAR(11)		NOT NULL,

	num_cnh					VARCHAR(11)			NULL,
	data_rescisao			DATE				NULL,

	CONSTRAINT PK_TB_colaboradores			PRIMARY KEY (pessoa_id),
	CONSTRAINT FK_TB_colaboradores_pessoa	FOREIGN KEY (pessoa_id) REFERENCES TB_pessoas(id),
	CONSTRAINT FK_TB_colaboradores_funcao	FOREIGN KEY (funcao)	REFERENCES TB_funcoes_colaboradores(id),
	CONSTRAINT UQ_TB_colaboradores_ctps		UNIQUE		(num_carteira_trabalho),
	CONSTRAINT CK_TB_colaboradores_inicial	CHECK		(salario_inicial >= 1500),
	CONSTRAINT CK_TB_colaboradores_salarios CHECK		(salario_atual >= salario_inicial),
	CONSTRAINT CK_TB_colaboradores_ctps		CHECK		(num_carteira_trabalho NOT LIKE '%[^0-9]%'),
	CONSTRAINT CK_TB_colaboradores_cnh		CHECK		(num_cnh IS NULL OR num_cnh NOT LIKE '%[^0-9]%'),
	CONSTRAINT CK_TB_colaboradores_rescisao CHECK		(data_rescisao >= data_registro)
);
GO

-- ------------------------------------------------------------
-- Arquivo: tables_produtos_pedidos.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de fornecedores.

	Relacionamentos:
		Envia chave primária para TB_produtos(fornecedor_id).
*/
CREATE TABLE TB_fornecedores (
	id				BIGINT			NOT NULL	IDENTITY,
	nome			VARCHAR(255)	NOT NULL,
	cnpj			VARCHAR(14)		NOT NULL,
	email			VARCHAR(55)		NOT NULL,
	telefone		VARCHAR(55)		NOT NULL,
	ativo			BIT				NOT NULL	DEFAULT 1,

	descricao		VARCHAR(255)		 NULL,

	created_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	updated_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	deleted_at		DATETIME			NULL,

	CONSTRAINT PK_TB_fornecedores				PRIMARY KEY (id),
	CONSTRAINT UQ_TB_fornecedores_nome			UNIQUE		(nome),
	CONSTRAINT UQ_TB_fornecedores_cnpj			UNIQUE		(cnpj),			
	CONSTRAINT UQ_TB_fornecedores_telefone		UNIQUE		(telefone),
	CONSTRAINT UQ_TB_fornecedores_email			UNIQUE		(email),
	CONSTRAINT CK_TB_fornecedores_telefone		CHECK		(telefone NOT LIKE '%[^0-9]%' AND LEN(telefone) BETWEEN 8 AND 15),
	CONSTRAINT CK_TB_fornecedores_email			CHECK		(email LIKE '%_@__%.__%')
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/* 
 Tabela de produtos.

	Relacionamentos:
		Envia chave primária para TB_produtos_pedidos(produto_id).
		Recebe chave estrangeira de TB_fornecedores(id) para fornecedor_id.
*/
CREATE TABLE TB_produtos (
	id				BIGINT			NOT NULL	IDENTITY,
	nome			VARCHAR(255)	NOT NULL,
	descricao		VARCHAR(1000)	NOT NULL,
	preco_venda		DECIMAL(18,2)	NOT NULL,
	custo			DECIMAL(18,2)	NOT NULL,
	estoque			BIGINT			NOT NULL,
	fornecedor_id	BIGINT			NOT NULL,
	ativo			BIT				NOT NULL	DEFAULT 1,

	imagem_url		VARCHAR(510)		NULL,

	created_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	updated_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	deleted_at		DATETIME			NULL,

	CONSTRAINT PK_TB_produtos				PRIMARY KEY (id),
	CONSTRAINT FK_TB_produtos_fornecedor	FOREIGN KEY (fornecedor_id) REFERENCES TB_fornecedores(id),
	CONSTRAINT UQ_TB_produtos_nome			UNIQUE		(nome),
	CONSTRAINT UQ_TB_produtos_imagem		UNIQUE		(imagem_url),
	CONSTRAINT CK_TB_produtos_preco_venda	CHECK		(preco_venda >= 0),
	CONSTRAINT CK_TB_produtos_custo			CHECK		(custo >= 0),
	CONSTRAINT CK_TB_produtos_estoque		CHECK		(estoque >= 0)
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

/*
	Tabela de status de pedidos.
		
		Relacionamentos:
			Envia chave primária para TB_produtos_pedidos(status_id).
*/

CREATE TABLE TB_status_pedido (
	id				INT				NOT NULL	IDENTITY,
	descricao		VARCHAR(255)	NOT NULL,
	
	CONSTRAINT PK_TB_status_pedido			 PRIMARY KEY	(id),
	CONSTRAINT UQ_TB_status_pedido_descricao UNIQUE			(descricao)
);
INSERT INTO TB_status_pedido (descricao) VALUES 
('PENDENTE'), 
('EM PROCESSAMENTO'), 
('ENVIADO'), 
('ENTREGUE'), 
('CANCELADO');
SELECT * FROM TB_status_pedido;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/*
	Tabela de pedidos.

		Relacionamentos:
			Envia chave primária para TB_produtos_pedidos(pedido_id).
			Recebe chave estrangeira de TB_clientes(pessoa_id) para cliente_id.
			Recebe chave estrangeira de TB_status_pedido(id) para status_id.
*/

CREATE TABLE TB_pedidos (
	id				BIGINT			NOT NULL	IDENTITY,
	cliente_id		BIGINT			NOT NULL,
	data_pedido		DATETIME		NOT NULL,
	status_id		INT				NOT NULL,
	
	CONSTRAINT PK_TB_pedidos			PRIMARY KEY (id),
	CONSTRAINT FK_TB_pedidos_cliente	FOREIGN KEY (cliente_id)	REFERENCES TB_clientes(pessoa_id),
	CONSTRAINT FK_TB_pedidos_status		FOREIGN KEY (status_id)		REFERENCES TB_status_pedido(id)
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/*
	Tabela de produtos por pedidos.

		Relacionamentos:
			Recebe chave estrangeira de TB_produtos(id) para produto_id.
			Recebe chave estrangeira de TB_pedidos(id) para pedido_id.
*/
CREATE TABLE TB_produtos_pedidos (
	produto_id		BIGINT			NOT NULL,
	pedido_id		BIGINT			NOT NULL,
	quantidade		INT				NOT NULL,
	valor_pago		DECIMAL(12, 2)	NOT NULL,
	
	CONSTRAINT PK_TB_produtos_pedidos			PRIMARY KEY (produto_id, pedido_id),
	CONSTRAINT FK_TB_produtos_pedidos_produto	FOREIGN KEY (produto_id)	REFERENCES TB_produtos(id),
	CONSTRAINT FK_TB_produtos_pedidos_pedido	FOREIGN KEY (pedido_id)		REFERENCES TB_pedidos(id)
);
GO

-- ------------------------------------------------------------
-- Arquivo: tables_usuarios.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/*
	Tabela de Roles de usuários.

		Relacionamentos:
			Envia chave primária para TB_usuarios(user_role).
*/
CREATE TABLE TB_roles_usuarios (
	id			INT				NOT NULL IDENTITY,
	descricao	VARCHAR(50)		NOT NULL,
	ativo		BIT				NOT NULL	DEFAULT 1,

	CONSTRAINT PK_TB_roles_usuarios				PRIMARY KEY (id),
	CONSTRAINT UQ_TB_roles_usuarios_descricao	UNIQUE (descricao)
);
GO

INSERT INTO TB_roles_usuarios (descricao) VALUES
('ADMIN'),
('COLABORADOR'),
('CLIENTE');
GO

CREATE TRIGGER TRG_block_insert_roles_usuarios
ON TB_roles_usuarios
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('Atualmente não é possível inserir novos valores em TB_roles_usuarios', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
/*
	Tabela de Usuários do sistema.
		
		Relacionamentos:
			Recebe chave estrangeira de TB_pessoas(id) para pessoa_id;
			Recebe chave estrangeira de TB_roles_usuarios(id) para usuario_role.
			
*/

CREATE TABLE TB_usuarios (
	id				BIGINT			NOT NULL		IDENTITY,
	pessoa_id		BIGINT			NOT NULL,
	usuario_role	INT				NOT NULL,
	usuario_login	VARCHAR(255)	NOT NULL,
	senha_hash		VARCHAR(255)	NOT NULL,
	ativo			BIT				NOT NULL		DEFAULT 1,
	
	created_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	updated_at		DATETIME		NOT NULL	DEFAULT GETDATE(),
	deleted_at		DATETIME			NULL	DEFAULT (NULL),
	
	CONSTRAINT PK_TB_usuarios			PRIMARY KEY (id, pessoa_id),
	CONSTRAINT FK_TB_usuarios_pessoas	FOREIGN KEY (pessoa_id)		REFERENCES TB_pessoas(id),
	CONSTRAINT FK_TB_usuarios_roles		FOREIGN KEY (usuario_role)	REFERENCES TB_roles_usuarios(id)
);

-- ============================================================
-- Subpasta: views
-- ============================================================

-- ------------------------------------------------------------
-- Arquivo: views_pessoas.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS VIEWS DE PESSOAS  -----------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO GENÉRICA DE PESSOAS DO SISTEMA COM INFORMAÇÕES PRINCIPAIS
CREATE VIEW VW_pessoas AS
SELECT
        pessoa.id               AS IdPessoa,
        pessoa.nome             AS Nome,
        pessoa.cpf              AS CPF,
        pessoa.data_nascimento  AS DataNascimento,
    
        endereco.cep            AS CEP,
        endereco.logradouro     AS Logradouro,
        endereco.numero         AS Numero,
        endereco.uf             AS UF,
    
        telefone.telefone       AS Telefone,
        email.email             AS Email,

        status.id               AS IdStatus,
        status.descricao        AS status

FROM            tb_pessoas          AS pessoa
    LEFT JOIN   tb_emails_pessoas   AS email        ON pessoa.id = email.pessoa_id      AND email.principal     = 1
    LEFT JOIN tb_enderecos_pessoas  AS endereco     ON pessoa.id = endereco.pessoa_id   AND endereco.principal  = 1
    LEFT JOIN tb_telefones_pessoas  AS telefone     ON pessoa.id = telefone.pessoa_id   AND telefone.principal  = 1
    INNER JOIN tb_status_pessoa     AS status       ON pessoa.status_id = status.id;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO COMPLETA DOS CLIENTES
CREATE VIEW VW_clientes_completos AS
	SELECT  
			Pessoa.id					AS IdCliente,
			Pessoa.nome					AS Nome,
			Pessoa.sobrenome			AS Sobrenome,
			Pessoa.cpf					AS CPF,
			Pessoa.data_nascimento		AS DataNascimento,
			Pessoa.data_cadastro		AS DataCadastro,
			
            Status.descricao			AS StatusDescricao,
		    
            Email.email					AS Email,
			Telefone.telefone           AS Telefone,
			
            Endereco.cep                AS CEP,
			Endereco.numero             AS Numero,
			Endereco.logradouro         AS Logradouro,
			Endereco.bairro             AS Bairro,
			Endereco.cidade             AS Cidade,
			Endereco.uf                 AS UF,
			Endereco.complemento        AS Complemento
	
	FROM	           dbo.tb_status_pessoa			AS Status
			INNER JOIN dbo.tb_pessoas				AS Pessoa	    ON Pessoa.status_id = Status.id
			INNER JOIN dbo.tb_clientes				AS Cliente	    ON Pessoa.id = Cliente.pessoa_id 
			INNER JOIN dbo.tb_emails_pessoas		AS Email	    ON Pessoa.id = Email.pessoa_id      AND Email.principal     = 1
			INNER JOIN dbo.tb_telefones_pessoas		AS Telefone	    ON Pessoa.id = Telefone.pessoa_id   AND Telefone.principal  = 1
			INNER JOIN dbo.tb_enderecos_pessoas		AS Endereco	    ON Pessoa.id = Endereco.pessoa_id   AND Endereco.principal  = 1
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO COMPLETA DOS COLABORADORES
CREATE VIEW VW_colaboradores_completos AS
    SELECT  
            Pessoa.id					AS IdColaborador,
            Pessoa.nome					AS Nome,
            Pessoa.sobrenome			AS Sobrenome,
            Pessoa.cpf					AS CPF,
            Pessoa.data_nascimento		AS DataNascimento,
            Pessoa.data_cadastro		AS DataCadastro,
            Status.descricao			AS StatusDescricao,
            
            Email.email					AS Email,
            Telefone.telefone           AS Telefone,
            
            Endereco.cep                AS CEP,
            Endereco.numero             AS Numero,
            Endereco.logradouro         AS Logradouro,
            Endereco.bairro             AS Bairro,
            Endereco.cidade             AS Cidade,
            Endereco.uf                 AS UF,
            Endereco.complemento        AS Complemento,

            Funcao.descricao                    AS FuncaoDescricao,
            Colaborador.salario_inicial         AS SalarioInicial,
            Colaborador.salario_atual           AS SalarioAtual,
            Colaborador.data_registro           AS DataRegistro,
            Colaborador.num_carteira_trabalho   AS NumCarteiraTrabalho,
            Colaborador.num_cnh                 AS NumCNH
    
    FROM	           dbo.tb_status_pessoa			AS Status
            INNER JOIN dbo.tb_pessoas				AS Pessoa	    ON Pessoa.status_id = Status.id
            INNER JOIN dbo.tb_colaboradores		    AS Colaborador	ON Pessoa.id = Colaborador.pessoa_id
            INNER JOIN dbo.tb_funcoes_colaboradores AS Funcao	    ON Colaborador.funcao = Funcao.id
			INNER JOIN dbo.tb_emails_pessoas		AS Email	    ON Pessoa.id = Email.pessoa_id      AND Email.principal     = 1
			INNER JOIN dbo.tb_telefones_pessoas		AS Telefone	    ON Pessoa.id = Telefone.pessoa_id   AND Telefone.principal  = 1
			INNER JOIN dbo.tb_enderecos_pessoas		AS Endereco	    ON Pessoa.id = Endereco.pessoa_id   AND Endereco.principal  = 1
GO


-- ------------------------------------------------------------
-- Arquivo: views_produtos_pedidos.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS VIEWS DE FORNECEDORES -----------------
------------------------------------------------------------------------------------------------------
-- VIEW GERAL DOS FORNECEDORES
CREATE VIEW VW_fornecedores AS
SELECT  Fornecedor.id			AS IdFornecedor,
        Fornecedor.nome			AS Nome,
        Fornecedor.cnpj			AS CNPJ,
        Fornecedor.email		AS Email,
        Fornecedor.telefone		AS Telefone,
        Fornecedor.descricao	AS Descricao,

        Fornecedor.ativo		AS Ativo
    
FROM                TB_fornecedores     AS Fornecedor

GO
SELECT * FROM VW_fornecedores;
GO

-- VIEW GERAL DOS FORNECEDORES ATIVOS
CREATE VIEW VW_fornecedores_ativos AS
SELECT * FROM VW_fornecedores
WHERE ativo = 1;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS VIEWS DE PRODUTOS -----------------
------------------------------------------------------------------------------------------------------
CREATE VIEW VW_produtos AS
SELECT  Produto.id			    AS IdProduto,
        Produto.nome			AS Nome,
        Produto.descricao		AS Descricao,
        Produto.preco_venda		AS PrecoVenda,
        Produto.custo			AS Custo,
        Produto.estoque		    AS Estoque,
        Fornecedor.id			AS FornecedorId,
        Fornecedor.nome			AS FornecedorNome,
        Produto.imagem_url      AS ImagemUrl,
        Produto.ativo           AS Ativo

FROM    TB_produtos                 AS Produto
        INNER JOIN  TB_fornecedores AS Fornecedor   ON Produto.fornecedor_id = Fornecedor.id
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS VIEWS DE PEDIDOS -----------------
------------------------------------------------------------------------------------------------------
CREATE VIEW VW_pedidos AS
SELECT  Pedido.id			AS PedidoId,
		Pedido.cliente_id	AS ClienteId,
		Pedido.data_pedido	AS Data,
		
		Status.descricao	AS Status

FROM	TB_pedidos					AS Pedido
		INNER JOIN TB_status_pedido	AS Status		ON Status.id = Pedido.status_id
GO

-- ------------------------------------------------------------
-- Arquivo: views_usuarios.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO GERAL DE USUÁRIOS POR PESSOA
CREATE VIEW VW_usuarios AS

	SELECT	Pessoa.id				AS PessoaId,
			Pessoa.nome				AS Nome,
			Pessoa.sobrenome		AS Sobrenome,
			Pessoa.data_cadastro	AS DataCadastro,
		
			Status.descricao		AS StatusPessoa,
			
			Role.descricao			AS RoleDescricao,
			Usuario.usuario_login	AS UsuarioLogin,
			Usuario.created_at		AS CreatedAt,
			Usuario.updated_at		AS UpdatedAt,
			Usuario.deleted_at		AS DeletedAt,
			Usuario.ativo			AS Ativo,
			Usuario.id				AS UsuarioId

	FROM				dbo.TB_usuarios			AS Usuario
			INNER JOIN	dbo.TB_roles_usuarios	AS Role		ON Usuario.usuario_role = Role.id
			INNER JOIN	dbo.TB_pessoas			AS Pessoa	ON Usuario.pessoa_id = Pessoa.id
			INNER JOIN	dbo.TB_status_pessoa	AS Status	ON Pessoa.status_id = Status.id
	GO
	SELECT * FROM VW_usuarios;
GO

-- ============================================================
-- Subpasta: procedures
-- ============================================================

-- ------------------------------------------------------------
-- Arquivo: procedures_pessoas.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA PESSOAS	-----------------
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_insert_cliente (

	-- Pessoa
	@Nome				VARCHAR(55),
	@Sobrenome			VARCHAR(55),
	@CPF				VARCHAR(11),
	@Status_Id			INT,
	@Data_Nascimento	DATE,

	-- Email
	@Email				VARCHAR(55),

	-- Telefone
	@Telefone			VARCHAR(55),

	-- Endereco
	@CEP				VARCHAR(8),
	@Numero				VARCHAR(5),
	@Logradouro			VARCHAR(255),
	@Bairro				VARCHAR(255),
	@Cidade				VARCHAR(255),
	@UF					VARCHAR(2),
	@Complemento		VARCHAR(255),

	-- Atributos de Usuario
	@Login				VARCHAR(255),
	@Hash_Senha			VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação do STATUS
		IF NOT EXISTS (
			SELECT 1
			FROM TB_status_pessoa
			WHERE id = @Status_Id
		)
			THROW 50001, 'Status de Pessoa inválido', 1;

		-- Validação de CPF único
		IF EXISTS (
			SELECT 1
			FROM TB_pessoas
			WHERE cpf = @CPF
		)
			THROW 50002, 'CPF já cadastrado', 1;

		-- INSERT de Pessoa
		INSERT INTO TB_pessoas
			(nome, sobrenome, cpf, status_id,
			 data_cadastro, data_nascimento,
			 created_at, updated_at)

		VALUES
			(@Nome, @Sobrenome, @CPF, @Status_Id,
			 GETDATE(), @Data_Nascimento,
			 GETDATE(), GETDATE());

		-- Captura Id_pessoa
		DECLARE @IdPessoa BIGINT;

		SET @IdPessoa = SCOPE_IDENTITY();

		-- INSERT de Email
		INSERT INTO TB_emails_pessoas
			(pessoa_id, email, principal)

		VALUES
			(@IdPessoa, @Email, 1);

		-- INSERT de Telefone
		INSERT INTO TB_telefones_pessoas
			(pessoa_id, telefone, principal)

		VALUES
			(@IdPessoa, @Telefone, 1);

		-- INSERT de Endereco
		INSERT INTO TB_enderecos_pessoas
			(pessoa_id, cep, numero,
			 logradouro, bairro,
			 cidade, uf, complemento,
			 principal)

		VALUES
			(@IdPessoa, @CEP, @Numero,
			 @Logradouro, @Bairro,
			 @Cidade, @UF, @Complemento,
			 1);

		-- INSERT de Cliente
		INSERT INTO TB_clientes
			(pessoa_id)

		VALUES
			(@IdPessoa);

		-- INSERT de Usuario
		INSERT INTO TB_usuarios
			(pessoa_id, usuario_role,
			 usuario_login, senha_hash,
			 created_at, updated_at)

		VALUES
			(@IdPessoa, 3,
			 @Login, @Hash_Senha,
			 GETDATE(), GETDATE());

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- CADASTRO DE COLABORADOR
CREATE PROCEDURE SP_insert_colaborador (
	
	-- Pessoa
	@Nome				VARCHAR(55),
	@Sobrenome			VARCHAR(55),
	@CPF				VARCHAR(11),
	@Status_Id			INT,
	@Data_Nascimento	DATE,

	-- Email
	@Email				VARCHAR(55),
	
	-- Telefone
	@Telefone			VARCHAR(55),
	
	-- Endereco
	@CEP				VARCHAR(8),
	@Numero				VARCHAR(5),
	@Logradouro			VARCHAR(255),
	@Bairro				VARCHAR(255),
	@Cidade				VARCHAR(255),
	@UF					VARCHAR(2),
	@Complemento		VARCHAR(255),

	-- Atributos específicos de Colaborador
	@Funcao             INT,
	@Salario_Inicial    DECIMAL(18,2),
	@Data_Registro		DATE,
	@Num_CTPS           VARCHAR(11),
	@Num_CNH            VARCHAR(11),
	
	-- Atributos de Usuario
	@Login				VARCHAR(255),
	@Hash_Senha			VARCHAR(255)
)
AS 
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			BEGIN TRANSACTION;

			-- Validação do STATUS
			IF NOT EXISTS (
				SELECT 1
				FROM TB_status_pessoa
				WHERE id = @Status_Id
			)	THROW 50001, 'Status de Pessoa inválido', 1;

			-- Validação da FUNÇÃO
			IF NOT EXISTS (
				SELECT 1
				FROM TB_funcoes_colaboradores
				WHERE id = @Funcao
			)	THROW 50001, 'Função do Colaborador inválida', 1;

			-- Validação de CPF único
			IF EXISTS (SELECT 1 FROM TB_pessoas WHERE cpf = @CPF)
			THROW 50002, 'CPF já cadastrado', 1;

			-- validação do Salário/Função
			DECLARE @SalarioFuncao DECIMAL(12, 2)
			SET @SalarioFuncao = (SELECT salario_base FROM TB_funcoes_colaboradores WHERE id = @Funcao)
			IF @Salario_Inicial < @SalarioFuncao
			THROW 50003, 'Salário inicial não pode ser inferior ao salário base da função', 1;
			
			-- Normalização de campos opcionais
			SET @Num_CNH = NULLIF(LTRIM(RTRIM(@Num_CNH)), '')
			
			-- INSERT de Pessoa
			INSERT INTO TB_pessoas 
				(nome, sobrenome, cpf, status_id, data_cadastro, data_nascimento, created_at, updated_at)
			VALUES	
				(@Nome, @Sobrenome, @CPF, @Status_Id, GETDATE(), @Data_Nascimento,GETDATE(), GETDATE())

			-- Captura Id_pessoa
			DECLARE @IdPessoa BIGINT
			SET @IdPessoa = SCOPE_IDENTITY()

			-- INSERT de Email
			INSERT INTO TB_emails_pessoas 
				(pessoa_id, email, principal)
			VALUES
				(@IdPessoa, @Email, 1)		

			-- INSERT de Telefone
			INSERT INTO TB_telefones_pessoas 
				(pessoa_id, telefone, principal)
			VALUES
				(@IdPessoa, @Telefone, 1)

			-- INSERT de Endereco
			INSERT INTO TB_enderecos_pessoas 
				(pessoa_id, cep, numero, logradouro, bairro, cidade, uf, complemento, principal)
			VALUES
				(@IdPessoa, @CEP, @Numero, @Logradouro, @Bairro, @Cidade, @UF, @Complemento, 1)

			-- INSERT de Colaborador
			INSERT INTO TB_colaboradores 
				(pessoa_id, funcao, salario_inicial, salario_atual, data_registro, num_carteira_trabalho, num_cnh)
			VALUES
				(@IdPessoa, @Funcao, @Salario_Inicial, @Salario_Inicial, @Data_Registro, @Num_CTPS, @Num_CNH)
				
			-- INSERET de Usuario
			INSERT INTO TB_usuarios
				(pessoa_id, usuario_role, usuario_login, senha_hash, created_at, updated_at)
			VALUES
				(@IdPessoa, 2, @Login, @Hash_Senha, GETDATE(), GETDATE())			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO 
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA VISUALIZAÇÃO DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
-- VER PESSOA POR ID
CREATE FUNCTION	FN_Pessoa_BYID (
	@PessoaId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pessoas WHERE idPessoa = @PessoaId );
GO
------------------------------------------------------------------------------------------------------
-- VER PESSOA POR CPF
CREATE FUNCTION	FN_Pessoa_BYCPF (
	@PessoaCPF	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pessoas WHERE CPF = @PessoaCPF );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VER CLIENTE POR ID
CREATE FUNCTION	FN_Cliente_BYID (
	@ClienteId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_clientes_completos WHERE IdCliente = @ClienteId);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VER COLABORADOR POR ID
CREATE FUNCTION	FN_Colaboarador_BYID (
	@ColaboradorId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_colaboradores_completos WHERE IdColaborador = @ColaboradorId);
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA UPDATE DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE CLIENTE
CREATE PROCEDURE SP_update_cliente
(

	-- Atributos obrigatórios Pessoa
    @IdPessoa           BIGINT,
    @Nome               VARCHAR(55),
    @Sobrenome          VARCHAR(55),
    @CPF                VARCHAR(11),
    @Status_Id          INT,
    @Data_Nascimento    DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @Deleted_at DATETIME = NULL;
		DECLARE @StatusDescricao VARCHAR(55);

        -- validação de pessoa
        IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
            THROW 50001, 'Pessoa não encontrada', 1;

        -- validação de status
        IF NOT EXISTS (SELECT 1 FROM TB_status_pessoa WHERE id = @Status_Id)
            THROW 50001, 'Status inválido', 1;

		-- Validação de soft exclusão de pessoa
		SELECT @StatusDescricao = descricao
		FROM tb_status_pessoa
		WHERE id = @Status_Id;

		IF @StatusDescricao = 'INATIVO' OR @StatusDescricao = 'BLOQUEADO'
		BEGIN
			SET @Deleted_at = GETDATE();
		END
		
        -- atualiza pessoa
        UPDATE TB_pessoas
        SET nome				= @Nome,
            sobrenome			= @Sobrenome,
            cpf					= @CPF,
            status_id			= @Status_Id,
            data_nascimento		= @Data_Nascimento,
            updated_at			= GETDATE(),
			deleted_at			= @Deleted_at

        WHERE id = @IdPessoa;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
-- UPDATE DE COLABORADOR
CREATE PROCEDURE SP_update_colaborador
(
	-- Atributos obrigatórios Pessoa
    @IdPessoa           BIGINT,
    @Nome               VARCHAR(55),
    @Sobrenome          VARCHAR(55),
    @CPF                VARCHAR(11),
    @Status_Id          INT,
    @Data_Nascimento    DATE,
	-- Atributos específicos de Colaborador
	@Funcao             INT,
	@Salario_Atual	    DECIMAL(18,2),
	@Num_CTPS           VARCHAR(11),
	@Num_CNH            VARCHAR(11), -- Opcional
	@Data_Registro		DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @Deleted_at DATETIME = NULL;
		DECLARE @StatusDescricao VARCHAR(55);

        -- validação de pessoa
        IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
            THROW 50001, 'Pessoa não encontrada', 1;

        -- validação de status
        IF NOT EXISTS (SELECT 1 FROM TB_status_pessoa WHERE id = @Status_Id)
            THROW 50001, 'Status inválido', 1;

		-- Validação de soft exclusão de pessoa
		SELECT @StatusDescricao = descricao
		FROM tb_status_pessoa
		WHERE id = @Status_Id;

		IF @StatusDescricao = 'INATIVO' OR @StatusDescricao = 'BLOQUEADO'
		BEGIN
			SET @Deleted_at = GETDATE();
		END

		-- validação do Salário/Função
		DECLARE @SalarioFuncao DECIMAL(12, 2)
		SET @SalarioFuncao = (SELECT salario_base FROM TB_funcoes_colaboradores WHERE id = @Funcao)
		IF @Salario_Atual < @SalarioFuncao
		THROW 50003, 'Salário atual não pode ser inferior ao salário base da função', 1;
			
		-- Normalização de campos opcionais
		SET @Num_CNH = NULLIF(LTRIM(RTRIM(@Num_CNH)), '')

        -- atualiza pessoa
        UPDATE TB_pessoas
        SET nome				= @Nome,
            sobrenome			= @Sobrenome,
            cpf					= @CPF,
            status_id			= @Status_Id,
            data_nascimento		= @Data_Nascimento,
            updated_at			= GETDATE(),
			deleted_at			= @Deleted_at

        WHERE id = @IdPessoa;

		-- atualiza colaborador
		UPDATE TB_colaboradores
		SET funcao					= @Funcao,
			salario_atual			= @Salario_Atual,
			num_carteira_trabalho	= @Num_CTPS,
			num_cnh					= @Num_CNH,
			data_registro			= @Data_Registro

		WHERE pessoa_id = @IdPessoa;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA SOFT DELETE DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_inactivate_pessoa
	@IdPessoa BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @StatusInativoId INT
		SELECT @StatusInativoId = id FROM TB_status_pessoa WHERE descricao = 'INATIVO'

		-- validação de pessoa
		IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
			THROW 50001, 'Pessoa não encontrada', 1;
		
		-- atualização do status para INATIVO
		UPDATE TB_pessoas 
		SET status_id = @StatusInativoId, deleted_at = GETDATE()
		WHERE id = @IdPessoa;
	
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

-- ------------------------------------------------------------
-- Arquivo: procedures_produtos_pedidos.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA FORNECEDORES	-----------------
------------------------------------------------------------------------------------------------------
-- CADASTRO DE FORNECEDOR
CREATE PROCEDURE SP_insert_fornecedor (
	@Nome			VARCHAR(255),
	@CNPJ			VARCHAR(20),
	@Email			VARCHAR(255),
	@Telefone		VARCHAR(20),
	@Descricao		VARCHAR(255)
)

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			
			-- Validação de CNPJ único
			IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE cnpj = @CNPJ)
			THROW 50002, 'CNPJ já cadastrado', 1;
			
			-- Validação de Email único
			IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE email = @Email)
			THROW 50002, 'Email já cadastrado', 1;
			
			-- Validação de Telefone único
			IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE telefone = @Telefone)
			THROW 50002, 'Telefone já cadastrado', 1;

			-- INSERT de Fornecedor
			INSERT INTO TB_fornecedores 
					(nome, cnpj, email, telefone, descricao)
			VALUES
					(@Nome, @CNPJ, @Email, @Telefone, @Descricao)
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- LISTAR FORNECEDOR POR ID
CREATE FUNCTION	FN_Fornecedores_BYID (
	@FornecedorId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_fornecedores WHERE IdFornecedor = @FornecedorId );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE FORNECEDOR
CREATE PROCEDURE SP_update_fornecedor (
	@IdFornecedor		BIGINT,
	@Nome				VARCHAR(255),
	@CNPJ				VARCHAR(20),
	@Email				VARCHAR(255),
	@Telefone			VARCHAR(20),
	@Descricao			VARCHAR(255)
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY		
		BEGIN TRANSACTION;
		-- Validação de existência do fornecedor
		IF NOT EXISTS (SELECT 1 FROM TB_fornecedores WHERE id = @IdFornecedor)
		THROW 50001, 'Fornecedor não encontrado', 1;
			
		-- Validação de CNPJ único
		IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE cnpj = @CNPJ AND id <> @IdFornecedor)
		THROW 50002, 'CNPJ já cadastrado', 1;
			
		-- Validação de Email único
		IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE email = @Email AND id <> @IdFornecedor)
		THROW 50002, 'Email já cadastrado', 1;
			
		-- Validação de Telefone único
		IF EXISTS (SELECT 1 FROM TB_fornecedores WHERE telefone = @Telefone AND id <> @IdFornecedor)
		THROW 50002, 'Telefone já cadastrado', 1;

		-- Normalização de campos opcionais
		SET @Descricao			= NULLIF(LTRIM(RTRIM(@Descricao)), '')
			
		-- UPDATE de Fornecedor
		UPDATE TB_fornecedores
		SET nome			= @Nome,
			cnpj			= @CNPJ,
			email			= @Email,
			telefone		= @Telefone,
			descricao		= @Descricao,
			updated_at		= GETDATE()
		WHERE id = @IdFornecedor
		
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- DELETE DE FORNECEDOR (SOFT DELETE)
CREATE PROCEDURE SP_inactivate_fornecedor (
	@IdFornecedor BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY	
		BEGIN TRANSACTION;

		-- Validação de existência do fornecedor
		IF NOT EXISTS (SELECT 1 FROM TB_fornecedores WHERE id = @IdFornecedor)
		THROW 50001, 'Fornecedor não encontrado', 1;
			
		-- Soft delete do Fornecedor
		UPDATE TB_fornecedores
		SET ativo = 0,
			updated_at = GETDATE(),
			deleted_at = GETDATE()
		WHERE id = @IdFornecedor
			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

-- ACTIVATE DE FORNECEDOR
CREATE PROCEDURE SP_activate_fornecedor (
    @IdFornecedor BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validação de existência do fornecedor
        IF NOT EXISTS (
            SELECT 1
            FROM TB_fornecedores
            WHERE id = @IdFornecedor
        )
        THROW 50001, 'Fornecedor não encontrado', 1;

        -- Reativação do fornecedor
        UPDATE TB_fornecedores
        SET
            ativo = 1,
            updated_at = GETDATE(),
            deleted_at = NULL
        WHERE id = @IdFornecedor;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA PRODUTOS	-----------------
------------------------------------------------------------------------------------------------------
-- CADASTRO DE PRODUTO
CREATE PROCEDURE SP_insert_produto (
	@Nome			VARCHAR(255),
	@Descricao		VARCHAR(1000),
	@Preco_Venda	DECIMAL(18,2),
	@Custo			DECIMAL(18,2),
	@Estoque		BIGINT,
	@Fornecedor_Id	BIGINT,
	@Imagem_Url		VARCHAR(510)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY	
		BEGIN TRANSACTION;

		-- validação de fornecedor
		IF NOT EXISTS (SELECT 1 FROM TB_fornecedores WHERE id = @Fornecedor_Id AND ativo = 1)
		THROW 50001, 'Fornecedor não encontrado ou inativo', 1;

		-- Normalização de campos opcionais
		SET @Imagem_Url = NULLIF(LTRIM(RTRIM(@Imagem_Url)), '')
		
		-- Insert de produto
		INSERT INTO TB_produtos
				(nome, descricao, preco_venda, custo, estoque, fornecedor_id, ativo, imagem_url, created_at, updated_at)
		VALUES
				(@Nome, @Descricao, @Preco_Venda, @Custo, @Estoque, @Fornecedor_Id, 1, @Imagem_Url, GETDATE(), GETDATE())
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VIZUALIZAÇÃO DE PRODUTO POR ID
CREATE FUNCTION	FN_Produto_BYID (
	@ProdutoId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_produtos WHERE IdProduto = @ProdutoId );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPGRADE PRODUTO
CREATE PROCEDURE SP_upgrade_produto (
	@IdProduto		BIGINT,
	@Nome			VARCHAR(255),
	@Descricao		VARCHAR(1000),
	@Preco_Venda	DECIMAL(18,2),
	@Custo			DECIMAL(18,2),
	@Estoque		BIGINT,
	@Fornecedor_Id	BIGINT,
	@Imagem_Url		VARCHAR(510)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY	
		BEGIN TRANSACTION;
		-- validação de produto
		IF NOT EXISTS (SELECT 1 FROM TB_produtos WHERE id = @IdProduto)
		THROW 50001, 'Produto não encontrado', 1;

		-- validação de fornecedor
		IF NOT EXISTS (SELECT 1 FROM TB_fornecedores WHERE id = @Fornecedor_Id AND ativo = 1)
		THROW 50001, 'Fornecedor não encontrado ou inativo', 1;

		-- Normalização de campos opcionais
		SET @Imagem_Url = NULLIF(LTRIM(RTRIM(@Imagem_Url)), '')
		
		-- Update de produto
		UPDATE TB_produtos
		SET nome			= @Nome,
			descricao		= @Descricao,
			preco_venda		= @Preco_Venda,
			custo			= @Custo,
			estoque			= @Estoque,
			fornecedor_id	= @Fornecedor_Id,
			imagem_url		= @Imagem_Url,
			updated_at		= GETDATE()
		WHERE id = @IdProduto

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO 
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- DELETE DE PRODUTO (SOFT DELETE)
CREATE PROCEDURE SP_inactivate_produto (
	@IdProduto BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de existência do Produto
		IF NOT EXISTS (SELECT 1 FROM TB_produtos WHERE id = @IdProduto)
		THROW 50001, 'Produto não encontrado', 1;

		-- Soft delete do Produto
		UPDATE TB_produtos
		SET ativo = 0,
			updated_at = GETDATE(),
			deleted_at = GETDATE()
		WHERE id = @IdProduto			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

-- ATIVATE DE PRODUTO
CREATE PROCEDURE SP_activate_produto (
	@IdProduto BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de existência do Produto
		IF NOT EXISTS (SELECT 1 FROM TB_produtos WHERE id = @IdProduto)
		THROW 50001, 'Produto não encontrado', 1;

		-- Soft delete do Produto
		UPDATE TB_produtos
		SET ativo = 1,
			updated_at = GETDATE(),
			deleted_at = null
		WHERE id = @IdProduto			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA PEDIDOS	-----------------
------------------------------------------------------------------------------------------------------
-- INSERT DE PEDIDOS
CREATE PROCEDURE SP_insert_pedido (
    @Cliente_Id BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;

		-- validação de cliente
		IF NOT EXISTS (SELECT 1 FROM TB_clientes WHERE pessoa_id = @Cliente_Id)
		THROW 50001, 'Cliente não encontrado', 1;

		-- insert
        INSERT INTO TB_pedidos (cliente_id, data_pedido, status_id)
        VALUES (@Cliente_Id, GETDATE(), 1)

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VIZUALIZAÇÂO DE PEDIDO POR ID
CREATE FUNCTION	FN_Pedido_BYID (
	@PedidoId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pedidos WHERE PedidoId = @PedidoId );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- ATUALIZAÇÃO DE PEDIDO
CREATE PROCEDURE SP_update_pedido (
    @IdPedido BIGINT,
    @Status_Id INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;

		-- validação do status cancelado
		IF EXISTS (SELECT 1 FROM TB_status_pedido WHERE id = @Status_Id AND descricao = 'Cancelado')
		THROW 50000, 'Para essa ação utilize SP_delete_pedido', 1;

        -- validação de pedido
        IF NOT EXISTS (SELECT 1 FROM TB_pedidos WHERE id = @IdPedido)
        THROW 50001, 'Pedido não encontrado', 1;

        -- validação de status
        IF NOT EXISTS (SELECT 1 FROM TB_status_pedido WHERE id = @Status_Id)
        THROW 50001, 'Status inválido', 1;

        -- update
        UPDATE TB_pedidos
        SET status_id = @Status_Id
        WHERE id = @IdPedido

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- CANCELAMENTO DE PEDIDO
CREATE PROCEDURE SP_delete_pedido (
    @IdPedido BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;
        -- validação de pedido
        IF NOT EXISTS (SELECT 1 FROM TB_pedidos WHERE id = @IdPedido)
        THROW 50001, 'Pedido não encontrado', 1;

        -- pegar id do status "Cancelado"
        DECLARE @StatusCancelado INT

        SELECT @StatusCancelado = id
        FROM TB_status_pedido
        WHERE descricao = 'Cancelado'

        IF @StatusCancelado IS NULL
        THROW 50001, 'Status Cancelado não encontrado', 1;

        -- update (soft delete via status)
        UPDATE TB_pedidos
        SET status_id = @StatusCancelado
        WHERE id = @IdPedido

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA PRODUTOS||PEDIDOS	-----------------
------------------------------------------------------------------------------------------------------
-- INSERT DE ITEM (PRODUTOS) EM PRODUTOS || PEDIDOS
CREATE PROCEDURE SP_add_produto_pedido (
    @Pedido_Id	BIGINT,
    @Produto_Id BIGINT,
    @Quantidade INT,
	@Valor_pago DECIMAL(18,2)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;

        DECLARE @EstoqueAtual BIGINT;

        -- validação de pedido
        IF NOT EXISTS (SELECT 1 FROM TB_pedidos WHERE id = @Pedido_Id)
        THROW 50001, 'Pedido não encontrado', 1;

        -- validação de produto
        IF NOT EXISTS (SELECT 1 FROM TB_produtos WHERE id = @Produto_Id AND ativo = 1)
        THROW 50001, 'Produto não encontrado ou inativo', 1;

        -- validação de quantidade
        IF @Quantidade <= 0
        THROW 50001, 'Quantidade inválida', 1;

        -- validação de estoque
        SELECT @EstoqueAtual = estoque
        FROM TB_produtos
        WHERE id = @Produto_Id;

        IF @EstoqueAtual < @Quantidade
        THROW 50001, 'Estoque insuficiente', 1;

        -- valida duplicidade de produtos
        IF EXISTS (
            SELECT 1 FROM TB_produtos_pedidos
            WHERE produto_id = @Produto_Id AND pedido_id = @Pedido_Id
        )
        THROW 50001, 'Produto já adicionado ao pedido, utilize SP_update_produto_pedido para alterar quantidades', 1;

        -- insert de produto
        INSERT INTO TB_produtos_pedidos 
			(produto_id, pedido_id, quantidade, valor_pago)
        VALUES 
			(@Produto_Id, @Pedido_Id, @Quantidade, @Valor_pago);

        -- baixa de estoque
        UPDATE TB_produtos
        SET estoque = estoque - @Quantidade
        WHERE id = @Produto_Id;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- LISTAR ITENS DE CADA PEDIDO
CREATE FUNCTION FN_view_produtos_pedido_BYID (
    @Pedido_Id BIGINT
)
RETURNS TABLE
AS
RETURN (
    SELECT	Pedido.produto_id,
			Produto.nome,
			Pedido.quantidade,
	        Pedido.valor_pago

    FROM TB_produtos_pedidos Pedido
    INNER JOIN TB_produtos Produto ON Produto.id = Pedido.produto_id
    
	WHERE Pedido.pedido_id = @Pedido_Id
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE PRODUTOS || PEDIDOS
CREATE PROCEDURE SP_update_produto_pedido (
    @Pedido_Id		BIGINT,
    @Produto_Id		BIGINT,
    @QuantidadeNova INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;
    
        DECLARE @QuantidadeAtual	INT;	-- Quantidade do produto que atualmente está no pedido
        DECLARE @EstoqueAtual		BIGINT;	-- Estoque para a quantidade atual do produto
        DECLARE @EstoqueOriginal	BIGINT;	-- Estoque cheio, sem considerar a quantidade atual

		-- valida status do pedido
		IF EXISTS (	SELECT	1

					FROM	TB_pedidos Pedido 
							INNER JOIN TB_status_pedido Status ON Status.id = Pedido.status_id
					WHERE	Pedido.id = @Pedido_Id AND Status.descricao IN ('CANCELADO', 'ENTREGUE'))

		THROW 50003, 'Pedido não pode ser alterado', 1;

        -- valida produto
        IF NOT EXISTS (SELECT 1 FROM TB_produtos_pedidos WHERE produto_id = @Produto_Id AND pedido_id = @Pedido_Id)
        THROW 50001, 'Item não encontrado no pedido', 1;

		-- validade quantidade
        IF @QuantidadeNova <= 0
        THROW 50001, 'Quantidade inválida', 1;

		-- validade quantidade nova com o estoque
        SELECT	@QuantidadeAtual = quantidade
        FROM	TB_produtos_pedidos
        WHERE	produto_id = @Produto_Id AND pedido_id = @Pedido_Id;

		SELECT	@EstoqueAtual = estoque
		FROM	TB_produtos WITH (UPDLOCK, ROWLOCK)
		WHERE	id = @Produto_Id

		SET @EstoqueOriginal = @EstoqueAtual + @QuantidadeAtual

		IF (@EstoqueOriginal < @QuantidadeNova)
		THROW 50002, 'Estoque insulficiente', 1;

        -- update item
        UPDATE TB_produtos_pedidos
        SET quantidade = @QuantidadeNova
        WHERE produto_id = @Produto_Id AND pedido_id = @Pedido_Id;

        -- ajuste de estoque
        UPDATE TB_produtos
        SET estoque = @EstoqueOriginal - @QuantidadeNova
        WHERE id = @Produto_Id;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- REMOVE DE PRODUTOS EM PRODUTOS||PEDIDOS
CREATE PROCEDURE SP_remove_produto_pedido (
    @Pedido_Id BIGINT,
    @Produto_Id BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;

        DECLARE @Quantidade INT;

		-- validação do produto
		IF NOT EXISTS (SELECT 1 FROM TB_produtos_pedidos WHERE pedido_id = @Pedido_Id AND produto_id = @Produto_Id)
		THROW 50002, 'Produto não encontrato no pedido', 1;

		-- captura da quantidade
        SELECT	@Quantidade = quantidade
        FROM	TB_produtos_pedidos
        WHERE	produto_id = @Produto_Id AND pedido_id = @Pedido_Id;

        -- remoção do item
        DELETE FROM TB_produtos_pedidos
        WHERE produto_id = @Produto_Id AND pedido_id = @Pedido_Id;

        -- ajuste do estoque
        UPDATE TB_produtos
        SET estoque = estoque + @Quantidade
        WHERE id = @Produto_Id;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
    END CATCH
END
GO

-- ------------------------------------------------------------
-- Arquivo: procedures_usuarios.sql
-- ------------------------------------------------------------
USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA USUARIOS	-----------------
------------------------------------------------------------------------------------------------------
-- INSERT DE USUARIOS
CREATE PROCEDURE SP_insert_usuario (
	@Pessoa_Id			BIGINT,
	@Login 				VARCHAR(255),
	@Hash_Senha			VARCHAR(255),
	@Usuario_Role		INT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de Pessoa
		IF NOT EXISTS (
		SELECT 1
		FROM TB_pessoas
		WHERE id = @Pessoa_Id AND deleted_at IS NULL
		) THROW 50001, 'Pessoa associada ao usuário não existe ou está inativa.', 1;

		-- Validação de Role
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_roles_usuarios
		WHERE	id = @Usuario_Role AND ativo = 1
		) THROW 50001, 'Role de usuário inválida ou inativa.', 1;

		-- Validação de Login Único
		IF EXISTS (SELECT 1 FROM TB_usuarios WHERE usuario_login = @Login)
		THROW 50002, 'Login em uso', 1;

		-- Validação de Role/Pessoa
		IF EXISTS (	SELECT 1
					FROM TB_Pessoas AS Pessoa
					INNER JOIN TB_usuarios AS Usuario ON Pessoa.id = Usuario.pessoa_id

					WHERE Usuario.usuario_role = @Usuario_Role AND Pessoa.id = @Pessoa_Id
		) THROW 50002, 'A pessoa já possui um usuário com essa role.', 1;
		
		-- Insert do usuário
		INSERT INTO TB_usuarios 
			(pessoa_id, usuario_role, usuario_login, senha_hash)
		VALUES			
			(@Pessoa_Id, @Usuario_Role, @Login, @Hash_Senha)
			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO 
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO DE USUÁRIOS
CREATE FUNCTION	FN_Usuario_BYID (
	@UsuarioId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM TB_usuarios WHERE id = @UsuarioId);
GO
-- VISUALIZAÇÃO DE USUÁRIOS POR PESSOA
CREATE FUNCTION	FN_Usuario_BYPESSOA (
	@PessoaId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_usuarios WHERE PessoaId = @PessoaId );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE USUARIOS
CREATE PROCEDURE SP_update_usuario (
	@Id_Usuario			BIGINT,
	@Login 				VARCHAR(255),
	@Role				INT
)
AS
BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Captura do Id de Pessoa
		DECLARE @Pessoa_Id BIGINT
		SELECT @Pessoa_Id = pessoa_id FROM TB_usuarios WHERE id = @Id_Usuario

		-- Validação de Pessoa
		IF NOT EXISTS (SELECT 1 FROM TB_usuarios WHERE	id = @Id_Usuario) 
		THROW 50001, 'Login de usuario não encontrado.', 1;

		-- Validação de Role
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_roles_usuarios
		WHERE	id = @Role AND ativo = 1
		) THROW 50001, 'Role de usuário inválida ou inativa.', 1;

		-- Validação de Login Único
		IF EXISTS (SELECT 1 FROM TB_usuarios WHERE usuario_login = @Login AND id <> @Id_Usuario)
		THROW 50002, 'Login em uso', 1;

		-- Validação de Role/Pessoa
		IF EXISTS (	SELECT 1 
					
					FROM TB_Pessoas AS Pessoa
					INNER JOIN TB_usuarios AS Usuario ON Pessoa.id = Usuario.pessoa_id
					
					WHERE Usuario.usuario_role = @Role AND Pessoa.id = @Pessoa_Id

		) THROW 50002, 'A pessoa já possui um usuário com essa role.', 1;
		
		-- Update do usuário
		UPDATE	TB_usuarios
		SET		usuario_login	= @Login,
				usuario_role	= @Role,
				updated_at		= GETDATE()

		WHERE id = @Id_Usuario
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO 

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- SOFT DELETE DE USUARIOS
CREATE PROCEDURE SP_delete_usuario (
	@Id_Usuario	BIGINT
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de Usuario
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_usuarios
		WHERE	id = @Id_Usuario AND deleted_at IS NULL
		) THROW 50001, 'Usuario não encontrado ou já deletado.', 1;
		
		-- Soft delete do usuário
		UPDATE TB_usuarios
		SET deleted_at = GETDATE(),
			ativo = 0
		WHERE id = @Id_Usuario
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO

-- ============================================================
-- Subpasta: user
-- ============================================================

-- ------------------------------------------------------------
-- Arquivo: user.sql
-- ------------------------------------------------------------
-- CREATE LOGIN projeto_fatec
-- WITH PASSWORD = '##fatec##';
-- GO

USE dev_projeto_fatec_ecomerce;
CREATE USER usuario_fatec FOR LOGIN projeto_fatec;
GO

ALTER ROLE db_datareader ADD MEMBER usuario_fatec;
ALTER ROLE db_datawriter ADD MEMBER usuario_fatec;
GRANT EXECUTE TO usuario_fatec;
GRANT BACKUP DATABASE TO usuario_fatec;
GO

CREATE PROCEDURE dbo.SP_Create_Master_User
AS
BEGIN

    DECLARE @id BIGINT
	INSERT INTO TB_pessoas (nome, sobrenome, cpf, status_id, data_nascimento) VALUES ('MASTER', 'BOY', '99999999999', 1, '0001-01-01')
	SET @id = SCOPE_IDENTITY()

	INSERT INTO TB_usuarios (pessoa_id, usuario_role, usuario_login, senha_hash) VALUES (@id, 1, 'master', '##fatec##')
END
GO
EXEC dbo.SP_Create_Master_User
GO

-- BACKUP DATABASE [dev_projeto_fatec_ecomerce]
-- TO DISK = 'C:\Backup\bkp.bak'
-- WITH COMPRESSION;

-- RESTORE DATABASE dev_projeto_fatec_ecomerce
-- FROM DISK = 'C:\Backup\bkp.bak';


select * from VW_clientes_completos
select * from VW_colaboradores_completos
select * from VW_fornecedores
select * from VW_produtos

select * from TB_pessoas

select * from TB_usuarios

use dev_projeto_fatec_ecomerce