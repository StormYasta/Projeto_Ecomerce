package com.projeto.fatec.classes.pedido.produto_pedido;

import java.math.BigDecimal;

import com.projeto.fatec.classes.pedido.PedidoEntity;
import com.projeto.fatec.classes.produto.ProdutoEntity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TB_produtos_pedidos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProdutoPedidoEntity {

    @EmbeddedId
    private ProdutoPedidoId id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("produtoId")
    @JoinColumn(name = "produto_id", nullable = false)
    private ProdutoEntity produto;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId("pedidoId")
    @JoinColumn(name = "pedido_id", nullable = false)
    private PedidoEntity pedido;

    @Column(name = "quantidade", nullable = false)
    private Integer quantidade;

    @Column(name = "valor_pago", nullable = false)
    private BigDecimal valorPago;
}
