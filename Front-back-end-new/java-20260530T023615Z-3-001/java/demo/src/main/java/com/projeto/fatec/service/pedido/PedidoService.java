package com.projeto.fatec.service.pedido;

import com.projeto.fatec.entity.pedido.PedidoEntity;
import com.projeto.fatec.repository.pedido.PedidoRepository;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class PedidoService {

    private final PedidoRepository pedidoRepository;

    public PedidoService(PedidoRepository pedidoRepository) {
        this.pedidoRepository = pedidoRepository;
    }

    @Transactional
    public PedidoEntity newPedido(PedidoEntity pedido) {
        if (pedido == null) {
            throw new IllegalArgumentException("Pedido não pode ser null");
        }

        return pedidoRepository.save(pedido);
    }
}