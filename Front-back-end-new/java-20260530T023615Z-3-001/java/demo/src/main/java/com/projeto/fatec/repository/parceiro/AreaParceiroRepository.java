package com.projeto.fatec.repository.parceiro;

import com.projeto.fatec.entity.parceiro.AreaParceiroEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AreaParceiroRepository extends JpaRepository<AreaParceiroEntity, Integer> {
}