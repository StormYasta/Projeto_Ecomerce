package com.projeto.fatec.classes.parceiro;

import com.projeto.fatec.classes.parceiro.area.AreaParceiroEntity;
import com.projeto.fatec.classes.pessoa.PessoaEntity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TB_parceiros")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ParceiroEntity {

    @Id
    @Column(name = "pessoa_id", nullable = false)
    private Long pessoaId;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId
    @JoinColumn(name = "pessoa_id")
    private PessoaEntity pessoa;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "area", nullable = false)
    private AreaParceiroEntity area;
}
