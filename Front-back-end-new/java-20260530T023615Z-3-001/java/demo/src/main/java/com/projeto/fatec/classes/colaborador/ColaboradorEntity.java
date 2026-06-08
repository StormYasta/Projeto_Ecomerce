package com.projeto.fatec.classes.colaborador;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

import com.projeto.fatec.classes.colaborador.funcao.FuncaoColaboradorEntity;
import com.projeto.fatec.classes.pessoa.PessoaEntity;

@Entity
@Table(name = "TB_colaboradores")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ColaboradorEntity {

    @Id
    @Column(name = "pessoa_id", nullable = false)
    private Long pessoaId;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @MapsId
    @JoinColumn(name = "pessoa_id")
    private PessoaEntity pessoa;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "funcao", nullable = false)
    private FuncaoColaboradorEntity funcao;

    @Column(name = "salario_inicial", nullable = false, precision = 12, scale = 2)
    private BigDecimal salarioInicial;

    @Column(name = "salario_atual", nullable = false, precision = 12, scale = 2)
    private BigDecimal salarioAtual;

    @Column(name = "data_registro", nullable = false)
    private LocalDate dataRegistro;

    @Column(name = "num_carteira_trabalho", nullable = false, length = 11, unique = true)
    private String numCarteiraTrabalho;

    /** Opcional — CNH do colaborador */
    @Column(name = "num_cnh", length = 11)
    private String numCnh;

    @Column(name = "data_rescisao")
    private LocalDate dataRescisao;
}
