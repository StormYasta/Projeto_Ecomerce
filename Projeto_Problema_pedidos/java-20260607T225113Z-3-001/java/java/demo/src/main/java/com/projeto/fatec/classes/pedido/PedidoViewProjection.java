package com.projeto.fatec.classes.pedido;

import java.math.BigInteger;
import java.time.LocalDate;

public interface PedidoViewProjection {
    Long getIdPedido();
    BigInteger getClienteId();
    LocalDate getData();
    String getStatus();
}
