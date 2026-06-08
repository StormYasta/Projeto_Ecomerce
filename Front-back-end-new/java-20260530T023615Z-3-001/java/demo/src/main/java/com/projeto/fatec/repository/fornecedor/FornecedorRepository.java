
package com.projeto.fatec.repository.fornecedor;

import com.projeto.fatec.entity.fornecedor.FornecedorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FornecedorRepository extends JpaRepository<FornecedorEntity, Long> {
}