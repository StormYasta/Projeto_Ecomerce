package com.projeto.fatec.classes.produto;

import java.math.BigDecimal;

public interface ProdutoViewProjection {

    Long getIdProduto();
    String getNome();
    String getDescricao();
    BigDecimal getPrecoVenda();
    BigDecimal getCusto();
    Integer getEstoque();
    String getImagemUrl();
}