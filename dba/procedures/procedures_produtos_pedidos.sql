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
-- VIZUALIZAÇÂO DE PEDIDO POR ID DO CLIENTE
CREATE FUNCTION	FN_Pedido_BYID_Cliente (
	@ClienteId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pedidos WHERE ClienteId = @ClienteId);
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
CREATE PROCEDURE SP_add_produto_pedido (
    @Pedido_Id   BIGINT,
    @Produto_Id  BIGINT,
    @Quantidade  INT,
    @Valor_pago  DECIMAL(18,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- validação de pedido
        IF NOT EXISTS (SELECT 1 FROM TB_pedidos WHERE id = @Pedido_Id)
            THROW 50001, 'Pedido não encontrado', 1;

        -- validação de produto
        IF NOT EXISTS (SELECT 1 
                       FROM TB_produtos 
                       WHERE id = @Produto_Id 
                         AND ativo = 1)
            THROW 50001, 'Produto não encontrado ou inativo', 1;

        -- validação de quantidade
        IF @Quantidade <= 0
            THROW 50001, 'Quantidade inválida', 1;

        -- valida duplicidade
        IF EXISTS (
            SELECT 1 
            FROM TB_produtos_pedidos
            WHERE produto_id = @Produto_Id 
              AND pedido_id = @Pedido_Id
        )
            THROW 50001, 'Produto já adicionado ao pedido', 1;

        -- insert de item no pedido
        INSERT INTO TB_produtos_pedidos 
            (produto_id, pedido_id, quantidade, valor_pago)
        VALUES 
            (@Produto_Id, @Pedido_Id, @Quantidade, @Valor_pago);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
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
GO------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- LISTAR ITENS DE CADA PEDIDO E COM FILTRO DE ID DE CLIENTE
CREATE FUNCTION FN_view_produtos_pedido_BYID_Cliente (
    @Pedido_Id	BIGINT,
	@Cliente_Id BIGINT
)
RETURNS TABLE
AS
RETURN (
    SELECT	Item.produto_id,
			Produto.nome,
			Item.quantidade,
	        Item.valor_pago

    FROM TB_produtos_pedidos Item
	INNER JOIN TB_pedidos  Pedido   ON Pedido.id = Item.pedido_id
    INNER JOIN TB_produtos Produto	ON Produto.id = Item.produto_id
	INNER JOIN TB_Clientes Cliente	ON Cliente.pessoa_id = Pedido.cliente_id

	WHERE Pedido.id = @Pedido_Id AND Cliente.pessoa_id = @Cliente_Id
);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE PRODUTOS || PEDIDOS
CREATE PROCEDURE SP_update_produto_pedido (
    @Pedido_Id      BIGINT,
    @Produto_Id     BIGINT,
    @QuantidadeNova INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- valida pedido ativo
        IF EXISTS (
            SELECT 1
            FROM TB_pedidos P
            INNER JOIN TB_status_pedido S ON S.id = P.status_id
            WHERE P.id = @Pedido_Id
              AND S.descricao IN ('CANCELADO', 'ENTREGUE')
        )
            THROW 50001, 'Pedido não pode ser alterado', 1;

        -- valida item existe
        IF NOT EXISTS (
            SELECT 1
            FROM TB_produtos_pedidos
            WHERE pedido_id = @Pedido_Id
              AND produto_id = @Produto_Id
        )
            THROW 50001, 'Item não encontrado no pedido', 1;

        -- valida quantidade
        IF @QuantidadeNova <= 0
            THROW 50001, 'Quantidade inválida', 1;

        -- update de itens do pedido
        UPDATE TB_produtos_pedidos
        SET quantidade = @QuantidadeNova
        WHERE pedido_id = @Pedido_Id
          AND produto_id = @Produto_Id;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- REMOVE DE PRODUTOS EM PRODUTOS||PEDIDOS
CREATE PROCEDURE SP_remove_produto_pedido (
    @Pedido_Id  BIGINT,
    @Produto_Id BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- valida existência do item no pedido
        IF NOT EXISTS (
            SELECT 1 
            FROM TB_produtos_pedidos 
            WHERE pedido_id = @Pedido_Id 
              AND produto_id = @Produto_Id
        )
            THROW 50001, 'Produto não encontrado no pedido', 1;

        -- remoção do item
        DELETE FROM TB_produtos_pedidos
        WHERE pedido_id = @Pedido_Id 
          AND produto_id = @Produto_Id;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
