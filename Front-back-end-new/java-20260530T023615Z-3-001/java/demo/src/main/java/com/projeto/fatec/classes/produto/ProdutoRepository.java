package com.projeto.fatec.classes.produto;

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
        @Param("PrecoVenda") Double precoVenda,
        @Param("custo") Double custo,
        @Param("estoque") int estoque,
        @Param("imagemurl") String imagemUrl
    );

    @Procedure(procedureName = "SP_upgrade_produto")
    void updateProduto(
        @Param("Id") Long id,
        @Param("Nome") String nome,
        @Param("Descricao") String descricao,
        @Param("PrecoVenda") Double precoVenda,
        @Param("custo") Double custo,
        @Param("estoque") int estoque,
        @Param("imagemurl") String imagemUrl
    );

    @Query(value = "SELECT * FROM FN_produto_BYID WHERE id = :id", nativeQuery = true)
    ProdutoViewProjection produtoById(@Param("id") Long id);

    @Query (value = "SELECT * FROM VW_produto", nativeQuery = true)
    List<ProdutoViewProjection> listarProdutos();

    @Procedure(procedureName = "SP_inactivate_produto")
    void inativarProduto(@Param("Id") Long id);
}
