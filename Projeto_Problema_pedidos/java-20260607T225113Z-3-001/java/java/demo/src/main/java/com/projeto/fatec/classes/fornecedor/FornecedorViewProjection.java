package com.projeto.fatec.classes.fornecedor;

public interface FornecedorViewProjection {

    Long getIdFornecedor();
    String getNome();
    String getCNPJ();
    String getEmail();
    String getTelefone();
    String getDescricao();
    Boolean getAtivo();
}