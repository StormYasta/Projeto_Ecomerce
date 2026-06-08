package com.projeto.fatec.classes.colaborador.funcao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FuncaoColaboradorRepository extends JpaRepository<FuncaoColaboradorEntity, Integer> {

    Optional<FuncaoColaboradorEntity> findByDescricao(String descricao);

    List<FuncaoColaboradorEntity> findByAtivoTrue();

    boolean existsByDescricao(String descricao);
}
