package com.projeto.fatec.classes.produto;

public interface ProdutoViewProjection {

    Long getId();
    String getNome();
    String getDescricao();
    Double getPrecoVenda();
    Double getCusto();
    Integer getEstoque();
    String getImagemUrl();
}
