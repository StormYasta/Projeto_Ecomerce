package com.projeto.fatec.repository.colaborador;

import com.projeto.fatec.entity.colaborador.ColaboradorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ColaboradorRepository extends JpaRepository<ColaboradorEntity, Long> {
}
