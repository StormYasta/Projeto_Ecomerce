package com.projeto.fatec.classes.cliente;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

import com.projeto.fatec.classes.pedido.PedidoEntity;
import com.projeto.fatec.classes.pessoa.PessoaEntity;

@Entity
@Table(name = "TB_clientes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ClienteEntity {

    @Id
    @Column(name = "pessoa_id", nullable = false)
    private Long pessoaId;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId
    @JoinColumn(name = "pessoa_id")
    private PessoaEntity pessoa;

    @OneToMany(mappedBy = "cliente")
    @Builder.Default
    private List<PedidoEntity> pedidos = new ArrayList<>();
}
