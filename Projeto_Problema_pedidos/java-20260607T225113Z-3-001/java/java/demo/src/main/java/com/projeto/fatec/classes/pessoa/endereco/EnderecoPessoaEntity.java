package com.projeto.fatec.classes.pessoa.endereco;

import com.projeto.fatec.classes.pessoa.PessoaEntity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "TB_enderecos_pessoas",
    uniqueConstraints = @UniqueConstraint(name = "UQ_TB_enderecos_cep", columnNames = {"pessoa_id", "cep", "numero"})
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EnderecoPessoaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;

    @Column(name = "cep", nullable = false, length = 8)
    private String cep;

    @Column(name = "numero", nullable = false, length = 5)
    private String numero;

    @Column(name = "logradouro", nullable = false, length = 255)
    private String logradouro;

    @Column(name = "bairro", nullable = false, length = 55)
    private String bairro;

    @Column(name = "cidade", nullable = false, length = 255)
    private String cidade;

    @Column(name = "uf", nullable = false, length = 2)
    private String uf;

    @Column(name = "principal", nullable = false)
    @Builder.Default
    private Boolean principal = false;

    @Column(name = "complemento", length = 255)
    private String complemento;
}
