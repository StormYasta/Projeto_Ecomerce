package com.projeto.fatec.login;

public class LoginDTO {

    public record Request(
            String login,
            String senha
    ) {}

    public record Response(
            String token,
            TipoUsuario tipo,
            Long pessoaId,
            String nome
    ) {}
}