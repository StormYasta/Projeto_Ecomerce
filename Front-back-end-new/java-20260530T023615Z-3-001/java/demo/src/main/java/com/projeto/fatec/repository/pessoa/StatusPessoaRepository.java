package com.projeto.fatec.repository.pessoa;

import com.projeto.fatec.entity.pessoa.StatusPessoaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StatusPessoaRepository extends JpaRepository<StatusPessoaEntity, Integer> {
}