package com.projeto.fatec.classes.usuario;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioRepository
        extends JpaRepository<UsuarioEntity, UsuarioId> {

    Optional<UsuarioEntity>
    findByUsuarioLoginAndAtivoTrueAndDeletedAtIsNull(
            String usuarioLogin
    );

}