package com.projeto.fatec.classes.pessoa.telefone;

import com.projeto.fatec.classes.pessoa.PessoaEntity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "TB_telefones_pessoas",
    uniqueConstraints = @UniqueConstraint(name = "UQ_TB_telefones_telefone_pesssoa", columnNames = {"pessoa_id", "telefone"})
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TelefonePessoaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;

    @Column(name = "telefone", nullable = false, length = 55)
    private String telefone;

    @Column(name = "principal", nullable = false)
    @Builder.Default
    private Boolean principal = false;
}
