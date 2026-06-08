package com.projeto.fatec.classes.produto;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProdutoRepository extends JpaRepository<ProdutoEntity, Long> {

    @Procedure(procedureName = "SP_insert_produto")
    void inserirProduto(
            @Param("Nome") String nome,
            @Param("Descricao") String descricao,
            @Param("Preco_Venda") BigDecimal precoVenda,
            @Param("Custo") BigDecimal custo,
            @Param("estoque") BigInteger estoque,
            @Param("Fornecedor_Id") BigInteger fornecedorId,
            @Param("Imagem_Url") String imagemUrl);

    @Procedure(procedureName = "SP_upgrade_produto")
    void updateProduto(
            @Param("Id") Long id,
            @Param("Nome") String nome,
            @Param("Descricao") String descricao,
            @Param("PrecoVenda") BigDecimal precoVenda,
            @Param("custo") BigDecimal custo,
            @Param("estoque") Integer estoque,
            @Param("imagemurl") String imagemUrl);

    @Query(value = "SELECT * FROM FN_Produto_BYID(:ProdutoId)", nativeQuery = true)
    ProdutoViewProjection produtoById(@Param("ProdutoId") Long produtoId);

    @Query(value = "SELECT * FROM VW_produtos", nativeQuery = true)
    List<ProdutoViewProjection> listarProdutos();

    @Procedure(procedureName = "SP_inactivate_produto")
    void inativarProduto(@Param("Id") Long id);
}
