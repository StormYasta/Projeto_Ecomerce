package com.projeto.fatec.login;

public class LoginDTO {

    public record  Request(
        String login,
        String senha
    ) {
    }
}
