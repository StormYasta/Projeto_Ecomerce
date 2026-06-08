package com.projeto.fatec.entity.produto;

import java.math.BigDecimal;

import com.projeto.fatec.entity.fornecedor.FornecedorEntity;

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
@Table(name = "tb_produtos")
public class ProdutoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nome", nullable = false, length = 255)
    private String nome;

    @Column(name = "descricao", nullable = false, length = 1000)
    private String descricao;

    @Column(name = "preco_venda", nullable = false, precision = 18, scale = 2)
    private BigDecimal precoVenda;

    @Column(name = "custo", nullable = false, precision = 18, scale = 2)
    private BigDecimal custo;

    @Column(name = "estoque", nullable = false)
    private Long estoque;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fornecedor_id", nullable = false)
    private FornecedorEntity fornecedor;

    @Column(name = "imagem_url", length = 255)
    private String imagemUrl;
}