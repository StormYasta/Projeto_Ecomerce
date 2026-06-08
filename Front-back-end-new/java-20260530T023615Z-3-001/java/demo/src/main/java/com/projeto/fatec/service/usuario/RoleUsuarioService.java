package com.projeto.fatec.service.usuario;

import com.projeto.fatec.entity.usuario.RoleUsuarioEntity;
import com.projeto.fatec.repository.usuario.RoleUsuarioRepository;

import jakarta.transaction.Transactional;

import org.springframework.stereotype.Service;

@Service
public class RoleUsuarioService { 

    private final RoleUsuarioRepository roleUsuarioRepository;

    public RoleUsuarioService(RoleUsuarioRepository roleUsuarioRepository) {
        this.roleUsuarioRepository = roleUsuarioRepository;
    }

    @Transactional
    public RoleUsuarioEntity newRoleUsuario(RoleUsuarioEntity roleUsuario) {

        if(roleUsuario == null) {
            throw new IllegalArgumentException("Argumento role usuario passado como null");
        }

        return roleUsuarioRepository.save(roleUsuario);
    }

}
