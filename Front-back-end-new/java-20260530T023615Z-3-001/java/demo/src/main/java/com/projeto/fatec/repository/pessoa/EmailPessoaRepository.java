
package com.projeto.fatec.repository.pessoa;

import com.projeto.fatec.entity.pessoa.EmailPessoaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmailPessoaRepository extends JpaRepository<EmailPessoaEntity, Long> {
}