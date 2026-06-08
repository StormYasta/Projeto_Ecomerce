package com.projeto.fatec.entity.pedido;

import com.projeto.fatec.entity.produto.ProdutoEntity;

import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_produtos_pedidos")
public class ProdutoPedidoEntity {

    @EmbeddedId
    private ProdutoPedidoIdEntity id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("produtoId")
    @JoinColumn(name = "produto_id", nullable = false)
    private ProdutoEntity produto;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("pedidoId")
    @JoinColumn(name = "pedido_id", nullable = false)
    private PedidoEntity pedido;

    @Column(name = "quantidade", nullable = false)
    private Integer quantidade;
}