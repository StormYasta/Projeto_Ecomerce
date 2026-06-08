package com.projeto.fatec.entity.fornecedor;

import java.util.List;

import com.projeto.fatec.entity.parceiro.ParceiroEntity;

import jakarta.persistence.*;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_fornecedores")
public class FornecedorEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nome", nullable = false, length = 255, unique = true)
    private String nome;

    @Column(name = "cnpj", nullable = false, length = 20, unique = true)
    private String cnpj;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "representante", nullable = false)
    private ParceiroEntity representante;

    @OneToMany(mappedBy = "fornecedor", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<TelefoneFornecedorEntity> telefones;

    @OneToMany(mappedBy = "fornecedor", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<EmailFornecedorEntity> emails;
}