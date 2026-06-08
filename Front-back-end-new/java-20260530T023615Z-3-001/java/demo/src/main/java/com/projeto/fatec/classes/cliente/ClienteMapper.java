package com.projeto.fatec.classes.cliente;

import org.springframework.stereotype.Component;

import com.projeto.fatec.classes.pessoa.PessoaEntity;

@Component
public class ClienteMapper {
 
    public ClienteEntity toEntity(ClienteDTO.Insert dto, PessoaEntity pessoa) {

        return ClienteEntity.builder()
                .pessoaId(dto.pessoaId())
                .pessoa(pessoa)
                .build();
    }
  
    public ClienteEntity toEntity(ClienteDTO.Update dto, PessoaEntity pessoa) {
        return ClienteEntity.builder()
                .pessoaId(dto.pessoaId())
                .pessoa(pessoa)
                .build();
    }

    public record Insert(
        
    ){}

}