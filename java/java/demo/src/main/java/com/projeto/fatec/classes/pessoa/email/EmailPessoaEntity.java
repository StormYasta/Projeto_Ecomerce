package com.projeto.fatec.classes.pessoa.email;

import com.projeto.fatec.classes.pessoa.PessoaEntity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
    name = "TB_emails_pessoas",
    uniqueConstraints = @UniqueConstraint(name = "UQ_TB_emails_email_pessoa", columnNames = {"pessoa_id", "email"})
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmailPessoaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;

    @Column(name = "email", nullable = false, length = 55)
    private String email;

    @Column(name = "principal")
    @Builder.Default
    private Boolean principal = false;
}
