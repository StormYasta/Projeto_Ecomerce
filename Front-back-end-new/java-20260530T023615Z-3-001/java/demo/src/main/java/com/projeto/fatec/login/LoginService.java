package com.projeto.fatec.login;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.projeto.fatec.classes.usuario.UsuarioRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final UsuarioRepository repository;

    @Transactional(readOnly = true)
    public boolean validarLogin(LoginDTO.Request dto) {

        if (dto == null || dto.login() == null || dto.senha() == null) {
            return false;
        }

        return repository
                .findByUsuarioLoginAndAtivoTrueAndDeletedAtIsNull(dto.login())
                .map(user -> user.getSenhaHash().equals(dto.senha()))
                .orElse(false);
    }
}