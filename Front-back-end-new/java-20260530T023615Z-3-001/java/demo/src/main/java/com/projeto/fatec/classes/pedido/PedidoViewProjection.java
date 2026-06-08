package com.projeto.fatec.classes.pedido;

public interface PedidoViewProjection {
    Long getIdPedido();
    String getDataPedido();
    String getStatusDescricao();
    String getNomeCliente();
}
