package com.projeto.fatec.repository.pessoa;

import com.projeto.fatec.entity.pessoa.EnderecoPessoaEntity;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EnderecoPessoaRepository extends JpaRepository<EnderecoPessoaEntity, Long> {

    List<EnderecoPessoaEntity> findByPessoa_Id(Long id);
    
    @Modifying
    @Query("UPDATE EnderecoPessoaEntity e SET e.principal = false WHERE e.pessoa.id = :pessoaId")
    void removerPrincipal(@Param("pessoaId") Long pessoaId);

    @Modifying
    @Query("UPDATE EnderecoPessoaEntity e SET e.principal = true WHERE e.id = :enderecoId")
    void definirPrincipal(@Param("enderecoId") Long enderecoId);
}