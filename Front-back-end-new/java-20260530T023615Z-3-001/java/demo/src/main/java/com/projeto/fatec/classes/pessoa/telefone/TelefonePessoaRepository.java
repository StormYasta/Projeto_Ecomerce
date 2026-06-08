package com.projeto.fatec.classes.pessoa.telefone;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TelefonePessoaRepository extends JpaRepository<TelefonePessoaEntity, Long> {
}
