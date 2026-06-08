package com.projeto.fatec.service.pedido;

import com.projeto.fatec.entity.pedido.StatusPedidoEntity;
import com.projeto.fatec.repository.pedido.StatusPedidoRepository;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class StatusPedidoService {

    private final StatusPedidoRepository statusPedidoRepository;

    public StatusPedidoService(StatusPedidoRepository statusPedidoRepository) {
        this.statusPedidoRepository = statusPedidoRepository;
    }

    @Transactional
    public StatusPedidoEntity newStatusPedido(StatusPedidoEntity statusPedido) {

        if(statusPedido == null) {
            throw new IllegalArgumentException("Argumento status pedido passado como null");
        }

        return statusPedidoRepository.save(statusPedido);
    }
}
