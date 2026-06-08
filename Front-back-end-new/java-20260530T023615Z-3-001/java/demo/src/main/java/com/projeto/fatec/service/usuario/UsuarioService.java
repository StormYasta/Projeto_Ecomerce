package com.projeto.fatec.service.usuario;

import com.projeto.fatec.entity.usuario.UsuarioEntity;
import com.projeto.fatec.repository.usuario.UsuarioRepository;

import jakarta.transaction.Transactional;

import org.springframework.stereotype.Service;

@Service
public class UsuarioService { 

    private final UsuarioRepository usuarioRepository;

    public UsuarioService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @Transactional
    public UsuarioEntity newUsuario(UsuarioEntity usuario) {

        if(usuario == null) {
            throw new IllegalArgumentException("Argumento usuario passado como null");
        }

        return usuarioRepository.save(usuario);
    }

}
