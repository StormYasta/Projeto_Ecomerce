
package com.projeto.fatec.repository.fornecedor;

import com.projeto.fatec.entity.fornecedor.TelefoneFornecedorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TelefoneFornecedorRepository extends JpaRepository<TelefoneFornecedorEntity, Long> {
}