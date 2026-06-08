package com.projeto.fatec.classes.produto;

import org.springframework.stereotype.Component;

@Component
public class ProdutoMapper {

    public ProdutoEntity toEntity(ProdutoDTO.Insert dto) {

        return ProdutoEntity.builder()
        .id(dto.id())
        .nome(dto.nome())
        .descricao(dto.descricao())
        .precoVenda(dto.precoVenda())
        .custo(dto.custo())
        .estoque(dto.estoque())
        .imagemUrl(dto.imagemUrl())
        .build();
    }
  
    public ProdutoEntity toEntity(ProdutoDTO.Update dto) {
        return ProdutoEntity.builder()
        .id(dto.id())
        .nome(dto.nome())
        .descricao(dto.descricao())
        .precoVenda(dto.precoVenda())
        .custo(dto.custo())
        .estoque(dto.estoque())
        .imagemUrl(dto.imagemUrl())
        .build();
    }

    public record Insert(
        
    ){}
}
