package com.projeto.fatec.classes.colaborador;

import java.time.LocalDate;

public interface ColaboradorViewProjection {

    Long getIdColaborador();
    String getNome();
    String getSobrenome();
    String getCpf();
    LocalDate getDataNascimento();
    LocalDate getDataCadastro();
    String getStatusDescricao();
    String getEmail();
    String getTelefone();
    String getCep();
    String getNumero();
    String getLogradouro();
    String getBairro();
    String getCidade();
    String getUf();
    String getComplemento();
    String getFuncaoDescricao();
    String getSalarioInicial();
    String getSalarioAtual();
    LocalDate getDataRegistro();
    String getNumCarteiraTrabalho();
    String getNumCNH();
}