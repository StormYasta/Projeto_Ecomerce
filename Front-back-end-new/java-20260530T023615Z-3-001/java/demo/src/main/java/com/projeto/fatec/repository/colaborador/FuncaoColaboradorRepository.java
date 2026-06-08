package com.projeto.fatec.repository.colaborador;

import com.projeto.fatec.entity.colaborador.FuncaoColaboradorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FuncaoColaboradorRepository extends JpaRepository<FuncaoColaboradorEntity, Integer> {
}