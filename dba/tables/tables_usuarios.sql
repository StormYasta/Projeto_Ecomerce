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
