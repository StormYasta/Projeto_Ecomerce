package com.projeto.fatec.classes.pedido;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.projeto.fatec.classes.cliente.ClienteEntity;
import com.projeto.fatec.classes.pedido.item.ProdutoPedidoEntity;
import com.projeto.fatec.classes.pedido.status.StatusPedidoEntity;

@Entity
@Table(name = "TB_pedidos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PedidoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "cliente_id", nullable = false)
    private ClienteEntity cliente;

    @Column(name = "data_pedido", nullable = false)
    private LocalDateTime dataPedido;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "status_id", nullable = false)
    private StatusPedidoEntity status;

    @OneToMany(mappedBy = "pedido")
    @Builder.Default
    private List<ProdutoPedidoEntity> itens = new ArrayList<>();
}