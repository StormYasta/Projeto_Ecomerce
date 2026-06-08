package com.projeto.fatec.classes.fornecedor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FornecedorRepository extends JpaRepository<FornecedorEntity, Long> {

    @Procedure(procedureName = "SP_insert_fornecedor")
    void inserirFornecedor(
            @Param("Nome") String nome,
            @Param("CNPJ") String cnpj,
            @Param("Email") String email,
            @Param("Telefone") String telefone,
            @Param("Descricao") String descricao,
            @Param("RepresentanteId") Long representanteId);
}
