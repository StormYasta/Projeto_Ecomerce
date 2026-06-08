package com.projeto.fatec.classes.pedido;

public class PedidoDTO {

    public record Insert(
            long id,
            Long clienteId,
            Long produtoId,
            String dataPedido
    ) {}

    public record Update(
            long id,
            Long clienteId,
            Long produtoId,
            String dataPedido
    ) {}
}
