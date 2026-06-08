package com.projeto.fatec.entity.parceiro;

import com.projeto.fatec.entity.pessoa.PessoaEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data


@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_parceiros")
public class ParceiroEntity {

    @Id
    @Column(name = "pessoa_id")
    private Long pessoaId;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "area", nullable = false)
    private AreaParceiroEntity area;
}