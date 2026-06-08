package com.projeto.fatec.classes.colaborador;

import java.time.LocalDate;

public interface ColaboradorViewProjection {

    Long getIdCliente();
    String getNome();
    String getSobrenome();
    String getCpf();
    LocalDate getDataNascimento();
    String getNomeSocial();
    String getSobrenomeSocial();
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
    String getFuncao();
    String getSalarioInicial();
    String getSalarioAtual();
    String getDataResgistro();
    String getNumCTPS();
    String getNunCNH();

}
