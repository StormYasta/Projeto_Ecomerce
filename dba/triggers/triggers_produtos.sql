USE dev_projeto_fatec_ecomerce
GO

-- TRIGGER para baixar o estoque do produto quando um pedido for inserido, e impedir que o estoque fique negativo.
CREATE TRIGGER TR_produtos_pedidos_insert ON TB_produtos_pedidos 
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Produto
    SET Produto.estoque = Produto.estoque - inserted.quantidade
    FROM TB_produtos Produto
    INNER JOIN inserted ON inserted.produto_id = Produto.id;
    
    IF EXISTS (
        SELECT 1
        FROM TB_produtos Produto
        INNER JOIN inserted ON inserted.produto_id = Produto.id
        WHERE Produto.estoque < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Vai da não', 1;
    END
END
GO

-- TRIGGER para aumentar o estoque do produto quando um pedido for deletado.
CREATE TRIGGER TR_produtos_pedidos_delete ON TB_produtos_pedidos
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Produto
    SET Produto.estoque = Produto.estoque + deleted.quantidade
    FROM TB_produtos Produto
    INNER JOIN deleted ON deleted.produto_id = Produto.id;

    IF EXISTS (
        SELECT 1
        FROM TB_produtos Produto
        INNER JOIN deleted ON deleted.produto_id = Produto.id
        WHERE Produto.estoque < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Alguma coisa muito ruim aconteceu para ter caido aqui...', 1;
    END
END
GO

-- TRIGGER para ajustar o estoque do produto quando um pedido for atualizado
CREATE TRIGGER TR_produtos_pedidos_update
ON TB_produtos_pedidos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- volta para o estoque antigo
    UPDATE Produto
    SET Produto.estoque = Produto.estoque + deleted.quantidade
    FROM TB_produtos Produto
    INNER JOIN deleted ON deleted.produto_id = Produto.id;

    -- atualiza para o estoque novo
    UPDATE Produto
    SET Produto.estoque = Produto.estoque - inserted.quantidade
    FROM TB_produtos Produto
    INNER JOIN inserted ON inserted.produto_id = Produto.id;

    IF EXISTS (
        SELECT 1
        FROM TB_produtos
        WHERE estoque < 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Vai da não', 1;
    END
END
GO