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
('VENDEDOR',			2500.00),
('GERENTE DE VENDAS',	4000.00),
('MARKETEIRO',			3000.00),
('SUPORTE',				3000.00);
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
