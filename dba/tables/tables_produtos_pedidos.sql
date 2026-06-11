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