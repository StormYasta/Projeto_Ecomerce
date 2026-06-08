package com.projeto.fatec.entity.cliente;

import com.projeto.fatec.entity.pessoa.PessoaEntity;

import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_clientes")
public class ClienteEntity {

    @Id
    @Column(name = "pessoa_id")
    private Long pessoaId;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;
}