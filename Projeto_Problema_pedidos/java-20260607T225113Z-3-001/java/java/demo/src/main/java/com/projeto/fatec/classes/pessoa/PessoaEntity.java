package com.projeto.fatec.classes.pessoa;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.projeto.fatec.classes.cliente.ClienteEntity;
import com.projeto.fatec.classes.pessoa.email.EmailPessoaEntity;
import com.projeto.fatec.classes.pessoa.endereco.EnderecoPessoaEntity;
import com.projeto.fatec.classes.pessoa.status.StatusPessoaEntity;
import com.projeto.fatec.classes.pessoa.telefone.TelefonePessoaEntity;
import com.projeto.fatec.classes.usuario.UsuarioEntity;;

@Entity
@Table(name = "TB_pessoas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PessoaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "nome", nullable = false, length = 55)
    private String nome;

    @Column(name = "sobrenome", nullable = false, length = 55)
    private String sobrenome;

    @Column(name = "cpf", nullable = false, length = 11, unique = true)
    private String cpf;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "status_id", nullable = false)
    private StatusPessoaEntity status;

    @Column(name = "data_cadastro", nullable = false, updatable = false)
    @CreationTimestamp
    private LocalDateTime dataCadastro;

    @Column(name = "data_nascimento", nullable = false)
    private LocalDate dataNascimento;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    // Relacionamentos
    @OneToMany(mappedBy = "pessoa", orphanRemoval = true)
    @Builder.Default
    private List<EnderecoPessoaEntity> enderecos = new ArrayList<>();

    @OneToMany(mappedBy = "pessoa", orphanRemoval = true)
    @Builder.Default
    private List<EmailPessoaEntity> emails = new ArrayList<>();

    @OneToMany(mappedBy = "pessoa", orphanRemoval = true)
    @Builder.Default
    private List<TelefonePessoaEntity> telefones = new ArrayList<>();

    @OneToOne(mappedBy = "pessoa", orphanRemoval = true)
    private ClienteEntity cliente;

    @OneToMany(mappedBy = "pessoa", cascade = CascadeType.ALL)
    @Builder.Default
    private List<UsuarioEntity> usuarios = new ArrayList<>();

    @SuppressWarnings("unlikely-arg-type")
    public UsuarioEntity getUsuarioByRoleId(Long roleId) {

        return usuarios.stream()

                .filter(usuario -> usuario.getRole().getId().equals(roleId))

                .findFirst()

                .orElse(null);
    }
}
