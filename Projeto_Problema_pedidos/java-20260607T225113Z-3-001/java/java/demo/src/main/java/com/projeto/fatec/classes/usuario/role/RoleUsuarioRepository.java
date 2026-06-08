package com.projeto.fatec.classes.usuario.role;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoleUsuarioRepository extends JpaRepository<RoleUsuarioEntity, Integer> {

    Optional<RoleUsuarioEntity> findByDescricao(String descricao);

    List<RoleUsuarioEntity> findByAtivoTrue();

    boolean existsByDescricaoAndAtivoTrue(String descricao);
}
