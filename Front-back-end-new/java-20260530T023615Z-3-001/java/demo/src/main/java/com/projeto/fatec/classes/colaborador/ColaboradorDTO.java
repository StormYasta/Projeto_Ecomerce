package com.projeto.fatec.classes.colaborador;

import java.time.LocalDate;

public class ColaboradorDTO {
    public record Insert(
            Long pessoaId,
            String nome,
            String sobrenome,
            String cpf,
            Integer statusId,
            LocalDate dataNascimento,
            String nomeSocial,
            String sobrenomeSocial,
            String email,
            String telefone,
            String cep,
            String numero,
            String logradouro,
            String bairro,
            String cidade,
            String uf,
            String complemento,
            Integer funcao,
            Float salarioInicial,
            LocalDate dataResgistro,
            String numeroCTPS,
            String numeroCNH,
            String login,
            String hashSenha) {
    }

    public record Update(
            Long pessoaId,
            String nome,
            String sobrenome,
            String cpf,
            Integer statusId,
            LocalDate dataNascimento,
            String nomeSocial,
            String sobrenomeSocial,
            Integer funcao,
            Float salarioAtual,
            LocalDate dataResgistro,
            String numeroCTPS,
            String numeroCNH) {
    }

}
