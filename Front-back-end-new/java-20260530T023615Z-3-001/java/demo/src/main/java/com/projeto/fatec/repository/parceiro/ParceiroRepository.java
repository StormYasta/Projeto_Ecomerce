package com.projeto.fatec.repository.parceiro;

import com.projeto.fatec.entity.parceiro.ParceiroEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParceiroRepository extends JpaRepository<ParceiroEntity, Long> {
}