package com.projeto.fatec.classes.pedido;

import java.time.LocalDate;

public interface PedidoViewProjection {
    Long getIdPedido();
    Long getClienteId();
    LocalDate getData();
    String getStatus();
}
