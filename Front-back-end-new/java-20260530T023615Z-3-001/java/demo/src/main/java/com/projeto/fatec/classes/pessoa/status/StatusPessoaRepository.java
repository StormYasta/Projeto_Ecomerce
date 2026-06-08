package com.projeto.fatec.classes.pessoa.status;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Repository;

@Repository
public interface StatusPessoaRepository extends JpaRepository<StatusPessoaEntity, Integer> {

    @NonNull
    Optional<StatusPessoaEntity> findByDescricao(String descricao);
    
    @NonNull
    Optional<StatusPessoaEntity> findById(@NonNull Integer id);
}