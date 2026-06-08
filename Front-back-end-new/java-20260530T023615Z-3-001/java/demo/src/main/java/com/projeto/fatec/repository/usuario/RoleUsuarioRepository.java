package com.projeto.fatec.repository.usuario;

import com.projeto.fatec.entity.usuario.RoleUsuarioEntity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoleUsuarioRepository extends JpaRepository<RoleUsuarioEntity, Integer> {
}