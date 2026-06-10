package com.projeto.fatec.classes.pedido;

import java.math.BigDecimal;

public interface PedidoItemProjection {

    Long getProdutoId();
    String getNome();
    Integer getQuantidade();
    BigDecimal getValorPago();
}