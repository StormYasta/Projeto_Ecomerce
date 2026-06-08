package com.projeto.fatec.classes.cliente;

import java.time.LocalDate;

public interface ClienteViewProjection {

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
}