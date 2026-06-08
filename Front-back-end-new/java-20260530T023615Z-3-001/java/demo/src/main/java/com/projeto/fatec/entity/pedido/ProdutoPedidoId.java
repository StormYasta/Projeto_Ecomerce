package com.projeto.fatec.entity.pedido;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class ProdutoPedidoId implements Serializable {

    @Column(name = "produto_id")
    private Long produtoId;

    @Column(name = "pedido_id")
    private Long pedidoId;
}