package com.projeto.fatec.entity.pessoa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_enderecos_pessoas")
public class EnderecoPessoa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private Pessoa pessoa;

    @Column(name = "cep", nullable = false, length = 12)
    private String cep;

    @Column(name = "numero", nullable = false, length = 6)
    private String numero;

    @Column(name = "logradouro", nullable = false, length = 100)
    private String logradouro;

    @Column(name = "bairro", nullable = false, length = 50)
    private String bairro;

    @Column(name = "uf", nullable = false, length = 3)
    private String uf;

    @Column(name = "estado", nullable = false, length = 15)
    private String estado;

    @Column(name = "principal", nullable = false)
    private Boolean principal = false;

    @Column(name = "complemento", length = 100)
    private String complemento;
}