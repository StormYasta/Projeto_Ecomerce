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
        Produto.custo			AS PrecoCusto,
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