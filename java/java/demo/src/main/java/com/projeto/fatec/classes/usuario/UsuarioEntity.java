package com.projeto.fatec.classes.usuario;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

import com.projeto.fatec.classes.usuario.role.RoleUsuarioEntity;

import com.projeto.fatec.classes.pessoa.PessoaEntity;

@Entity
@Table(name = "TB_usuarios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pessoa_id", nullable = false)
    private PessoaEntity pessoa;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "usuario_role", nullable = false)
    private RoleUsuarioEntity role;

    @Column(name = "usuario_login", nullable = false, length = 255)
    private String usuarioLogin;

    @Column(name = "senha_hash", nullable = false, length = 255)
    private String senhaHash;

    @Column(name = "ativo", nullable = false)
    @Builder.Default
    private Boolean ativo = true;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}