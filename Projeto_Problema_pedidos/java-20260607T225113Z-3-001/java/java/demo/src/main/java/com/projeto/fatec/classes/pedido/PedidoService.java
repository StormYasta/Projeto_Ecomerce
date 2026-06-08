package com.projeto.fatec.classes.pedido;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class PedidoService {

    private final PedidoRepository repository;

    @Transactional
    public void insertPedido(PedidoDTO.Insert dto) {
        repository.insertPedido(
                dto.clienteId(),
                dto.produtoId(),
                dto.status(),
                dto.dataPedido());
    }

    @Transactional(readOnly = true)
    public PedidoViewProjection findPedido(Long id) {
        return repository.pedidoById(id);
    }

    @Transactional
    public void updatePedido(PedidoDTO.Update dto) {
        repository.updatePedido(
                dto.id(),
                dto.clienteId(),
                dto.produtoId(),
                dto.status());
    }

    @Transactional
    public void cancelPedido(Long id) {
        repository.cancelPedido(id);
    }

    @Transactional(readOnly = true)
    public List<PedidoViewProjection> listPedidos() {
        return repository.listPedidos();
    }

}
