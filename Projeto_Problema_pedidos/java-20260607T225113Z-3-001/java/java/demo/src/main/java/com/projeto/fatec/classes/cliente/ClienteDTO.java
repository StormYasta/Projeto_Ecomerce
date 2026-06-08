package com.projeto.fatec.classes.cliente;

import java.time.LocalDate;

public class ClienteDTO {

    public record Insert(
            Long pessoaId,
            String nome,
            String sobrenome,
            String cpf,
            Integer statusId,
            LocalDate dataNascimento,
            String email,
            String telefone,
            String cep,
            String numero,
            String logradouro,
            String bairro,
            String cidade,
            String uf,
            String complemento,
            String login,
            String hashSenha
    ) {}

    public record Update(
            Long pessoaId,
            String nome,
            String sobrenome,
            String cpf,
            Integer statusId,
            LocalDate dataNascimento
    ) {}
}