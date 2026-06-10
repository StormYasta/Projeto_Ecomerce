package com.projeto.fatec.classes.produto;

import java.math.BigDecimal;

public interface ProdutoViewProjection {

    Long getIdProduto();
    String getNome();
    String getDescricao();
    BigDecimal getPrecoVenda();
    BigDecimal getPrecoCusto();
    Integer getEstoque();
    String getImagemUrl();
}