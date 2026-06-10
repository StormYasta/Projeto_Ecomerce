package com.projeto.fatec.classes.pedido.item;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ProdutoPedidoId implements Serializable {

    @Column(name = "produto_id", nullable = false)
    private Long produtoId;

    @Column(name = "pedido_id", nullable = false)
    private Long pedidoId;
}