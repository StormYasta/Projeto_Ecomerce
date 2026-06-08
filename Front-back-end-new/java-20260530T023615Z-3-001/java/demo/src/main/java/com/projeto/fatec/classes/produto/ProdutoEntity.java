package com.projeto.fatec.classes.produto;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.projeto.fatec.classes.fornecedor.FornecedorEntity;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "TB_produtos")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProdutoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "nome", nullable = false, length = 255, unique = true)
    private String nome;

    @Column(name = "descricao", nullable = false, length = 1000)
    private String descricao;

    @Column(name = "preco_venda", nullable = false, precision = 18, scale = 2)
    private double precoVenda;

    @Column(name = "custo", nullable = false, precision = 18, scale = 2)
    private double custo;

    @Column(name = "estoque", nullable = false)
    private int estoque;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "fornecedor_id", nullable = false)
    private FornecedorEntity fornecedor;

    @Column(name = "ativo", nullable = false)
    @Builder.Default
    private Boolean ativo = true;

    @Column(name = "imagem_url", length = 510, unique = true)
    private String imagemUrl;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "produto")
    @Builder.Default
    private List<com.projeto.fatec.classes.pedido.produto_pedido.ProdutoPedidoEntity> pedidos = new java.util.ArrayList<>();
}
