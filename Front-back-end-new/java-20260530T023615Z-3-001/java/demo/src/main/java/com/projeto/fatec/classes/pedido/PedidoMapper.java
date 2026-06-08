package com.projeto.fatec.classes.pedido;

import org.springframework.stereotype.Component;

@Component
public class PedidoMapper {

    public PedidoEntity toEntity(PedidoDTO.Insert dto) {

        return PedidoEntity.builder()
                .id(dto.id())
                .build();
    }
  
    public PedidoEntity toEntity(PedidoDTO.Update dto) {
        return PedidoEntity.builder()
                .id(dto.id())
                .build();
    }

    public record Insert(
        
    ){}
}
