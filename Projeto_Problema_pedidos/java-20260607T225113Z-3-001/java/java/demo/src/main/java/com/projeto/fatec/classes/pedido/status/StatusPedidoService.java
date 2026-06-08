package com.projeto.fatec.classes.pedido.status;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class StatusPedidoService {

    private final StatusPedidoRepository repository;

    @Transactional(readOnly = true)
    public List<StatusPedidoEntity> listarStatusPedidos() {
        return repository.findAll();
    }
}
