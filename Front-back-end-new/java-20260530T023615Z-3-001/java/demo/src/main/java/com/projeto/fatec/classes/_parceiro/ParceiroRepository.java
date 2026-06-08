package com.projeto.fatec.classes.parceiro;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParceiroRepository extends JpaRepository<ParceiroEntity, Long> {

    List<ParceiroEntity> findByAreaId(Integer areaId);
}
