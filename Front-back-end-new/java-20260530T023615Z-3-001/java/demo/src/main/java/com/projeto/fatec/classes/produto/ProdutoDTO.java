package com.projeto.fatec.classes.produto;

public class ProdutoDTO {

    public record Insert(
            Long id,
            String nome,
            String descricao,
            Double precoVenda,
            Double custo,
            int estoque,
            String imagemUrl
    ) {}

    public record Update(
            Long id,
            String nome,
            String descricao,
            Double precoVenda,
            Double custo,
            int estoque,
            String imagemUrl
    ) {}
}
