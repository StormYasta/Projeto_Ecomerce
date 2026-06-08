package com.projeto.fatec.classes.parceiro.area;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AreaParceiroRepository extends JpaRepository<AreaParceiroEntity, Integer> {

    Optional<AreaParceiroEntity> findByDescricao(String descricao);

    List<AreaParceiroEntity> findByAtivoTrue();

    boolean existsByDescricao(String descricao);
}
