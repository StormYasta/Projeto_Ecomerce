package com.projeto.fatec.classes.produto;

import java.math.BigDecimal;
import java.math.BigInteger;

public class ProdutoDTO {

    public record Insert(
            Long id,
            String nome,
            String descricao,
            BigDecimal precoVenda,
            BigDecimal custo,
            BigInteger estoque,
            BigInteger fornecedorId,
            String imagemUrl
    ) {}

    public record Update(
            Long id,
            String nome,
            String descricao,
            BigDecimal precoVenda,
            BigDecimal custo,
            Integer estoque,
            String imagemUrl
    ) {}
}
