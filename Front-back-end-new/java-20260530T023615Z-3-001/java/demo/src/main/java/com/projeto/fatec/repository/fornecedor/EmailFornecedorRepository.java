package com.projeto.fatec.repository.fornecedor;

import com.projeto.fatec.entity.fornecedor.EmailFornecedorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmailFornecedorRepository extends JpaRepository<EmailFornecedorEntity, Long> {
}
