package com.projeto.fatec.classes.fornecedor;

public class FornecedorDTO {

    public record Insert(
            String nome,
            String cnpj,
            String email,
            String telefone,
            String descricao
    ) {}

    public record Update(
            Long id,
            String nome,
            String cnpj,
            String email,
            String telefone,
            String descricao
    ) {}
}