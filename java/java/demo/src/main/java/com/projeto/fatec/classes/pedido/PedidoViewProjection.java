package com.projeto.fatec.classes.pedido;

import java.time.LocalDateTime;

public interface PedidoViewProjection {

    Long getPedidoId();
    Long getClienteId();
    LocalDateTime getData();
    String getStatus();
}