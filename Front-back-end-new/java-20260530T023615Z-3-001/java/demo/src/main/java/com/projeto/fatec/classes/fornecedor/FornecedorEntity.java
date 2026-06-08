package com.projeto.fatec.classes.fornecedor;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.projeto.fatec.classes.parceiro.ParceiroEntity;

import java.time.LocalDateTime;

@Entity
@Table(name = "TB_fornecedores")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FornecedorEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "nome", nullable = false, length = 255, unique = true)
    private String nome;

    @Column(name = "cnpj", nullable = false, length = 14, unique = true)
    private String cnpj;

    @Column(name = "email", nullable = false, length = 55, unique = true)
    private String email;

    @Column(name = "telefone", nullable = false, length = 55, unique = true)
    private String telefone;

    @Column(name = "ativo", nullable = false)
    @Builder.Default
    private Boolean ativo = true;

    /** FK opcional para TB_parceiros */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "representante")
    private ParceiroEntity representante;

    @Column(name = "descricao", length = 255)
    private String descricao;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}
