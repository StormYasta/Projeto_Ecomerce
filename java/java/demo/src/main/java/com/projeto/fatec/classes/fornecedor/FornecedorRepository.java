package com.projeto.fatec.classes.fornecedor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FornecedorRepository extends JpaRepository<FornecedorEntity, Long> {

    @Procedure(procedureName = "SP_insert_fornecedor")
    void insertFornecedor(
            @Param("Nome")      String nome,
            @Param("CNPJ")      String cnpj,
            @Param("Email")     String email,
            @Param("Telefone")  String telefone,
            @Param("Descricao") String descricao);

    @Query(value = "SELECT * FROM VW_fornecedores", nativeQuery = true)
    List<FornecedorViewProjection> listarFornecedores();

    @Query(value = "SELECT * FROM VW_fornecedores_ativos", nativeQuery = true)
    List<FornecedorViewProjection> listarFornecedoresAtivos();

    @Query(value = "SELECT * FROM FN_Fornecedores_BYID(:id)", nativeQuery = true)
    FornecedorViewProjection fornecedorById(@Param("id") Long id);

    @Procedure(procedureName = "SP_update_fornecedor")
    void updateFornecedor(
            @Param("IdFornecedor")  Long id,
            @Param("Nome")          String nome,
            @Param("CNPJ")          String cnpj,
            @Param("Email")         String email,
            @Param("Telefone")      String telefone,
            @Param("Descricao")     String descricao);

    @Procedure(procedureName = "SP_inactivate_fornecedor")
    void inactivateFornecedor(@Param("IdFornecedor") Long id);
    
    @Procedure(procedureName = "SP_activate_fornecedor")
    void activateFornecedor(@Param("IdFornecedor") Long id);
}