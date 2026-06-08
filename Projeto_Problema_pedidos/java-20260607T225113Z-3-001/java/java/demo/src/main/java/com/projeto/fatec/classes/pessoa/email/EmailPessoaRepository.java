package com.projeto.fatec.classes.pessoa.email;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface EmailPessoaRepository extends JpaRepository<EmailPessoaEntity, Long> {

}
