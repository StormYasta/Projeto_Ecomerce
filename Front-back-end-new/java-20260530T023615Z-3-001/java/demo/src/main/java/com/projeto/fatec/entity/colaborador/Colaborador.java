package com.projeto.fatec.entity.colaborador;

import java.math.BigDecimal;
import java.time.LocalDate;

import com.projeto.fatec.entity.pessoa.Pessoa;

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
@Table(name = "tb_colaboradores")
public class Colaborador {

    @Id
    @Column(name = "pessoa_id")
    private Long pessoaId;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private Pessoa pessoa;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "funcao", nullable = false)
    private FuncaoColaborador funcao;

    @Column(name = "salario_inicial", nullable = false, precision = 12, scale = 2)
    private BigDecimal salarioInicial;

    @Column(name = "salario_atual", nullable = false, precision = 12, scale = 2)
    private BigDecimal salarioAtual;

    @Column(name = "data_registro", nullable = false)
    private LocalDate dataRegistro;

    @Column(name = "num_carteira_trabalho", nullable = false, length = 50)
    private String numCarteiraTrabalho;

    @Column(name = "data_nascimento", nullable = false)
    private LocalDate dataNascimento;

    @Column(name = "num_cnh", length = 50)
    private String numCnh;

    @Column(name = "data_rescisao")
    private LocalDate dataRescisao;
}