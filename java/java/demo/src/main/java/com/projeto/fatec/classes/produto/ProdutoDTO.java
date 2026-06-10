package com.projeto.fatec.classes.produto;

import java.math.BigDecimal;
import java.math.BigInteger;

public class ProdutoDTO {

    public record Insert(
            Long id,
            String nome,
            String descricao,
            BigDecimal precoVenda,
            BigDecimal precoCusto,
            BigInteger estoque,
            BigInteger fornecedorId,
            String imagemUrl
    ) {}

    public record Update(
            Long id,
            String nome,
            String descricao,
            BigDecimal precoVenda,
            BigDecimal precoCusto,
            Integer estoque,
            String imagemUrl
    ) {}
}
