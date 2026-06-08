
-- TRIGGER para baixar o estoque do produto quando um pedido for inserido, e impedir que o estoque fique negativo.
CREATE TRIGGER TRG_BaixaEstoque_ProdutoPedido ON TB_produtos_pedidos AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    UPDATE produto
    SET produto.estoque = produto.estoque - inserted.quantidade
    FROM TB_produtos produto
    INNER JOIN inserted
        ON produto.id = inserted.produto_id;

    IF EXISTS (
        SELECT 1
        FROM TB_produtos produto
        WHERE produto.estoque < 0
    ) BEGIN 
		ROLLBACK TRANSACTION;
        RAISERROR ('Não vai dar não.', 16, 1);
    END
END;
GO