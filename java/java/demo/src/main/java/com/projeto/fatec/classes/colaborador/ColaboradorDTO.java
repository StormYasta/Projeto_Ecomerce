package com.projeto.fatec.classes.colaborador;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ColaboradorDTO {
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
                        Integer funcao,
                        BigDecimal salarioInicial,
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
                        Integer funcao,
                        BigDecimal salarioAtual,
                        LocalDate dataRegistro,
                        String numeroCTPS,
                        String numeroCNH) {
        }

}
