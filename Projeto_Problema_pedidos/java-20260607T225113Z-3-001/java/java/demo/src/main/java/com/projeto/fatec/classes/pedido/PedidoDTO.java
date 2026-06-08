package com.projeto.fatec.classes.pedido;

import java.math.BigInteger;
import java.time.LocalDate;

public class PedidoDTO {

    public record Insert(
            Long id,
            BigInteger clienteId,
            BigInteger produtoId,
            LocalDate dataPedido,
            Integer status
    ) {}

    public record Update(
            long id,
            BigInteger clienteId,
            BigInteger produtoId,
            LocalDate dataPedido,
            Integer status
    ) {}
}
