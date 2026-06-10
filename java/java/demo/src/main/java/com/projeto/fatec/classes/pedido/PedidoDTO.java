package com.projeto.fatec.classes.pedido;

import java.math.BigDecimal;

public class PedidoDTO {

    public record Insert(
            Long clienteId
    ) {}

    public record UpdateStatus(
            Integer statusId
    ) {}

    public record AddItem(
            Long produtoId,
            Integer quantidade,
            BigDecimal valorPago
    ) {}

    public record UpdateItem(
            Integer quantidade
    ) {}
}