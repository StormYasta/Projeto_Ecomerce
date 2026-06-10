package com.projeto.fatec.classes.pedido.status;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TB_status_pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StatusPedidoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "descricao", nullable = false, length = 255, unique = true)
    private String descricao;
}