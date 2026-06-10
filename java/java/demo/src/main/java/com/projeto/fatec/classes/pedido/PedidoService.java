package com.projeto.fatec.classes.pedido;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PedidoService {

    private final PedidoRepository repository;

    // ── PEDIDO ────────────────────────────────────────────────────────────────

    @Transactional
    public void criarPedido(PedidoDTO.Insert dto) {
        repository.insertPedido(dto.clienteId());
    }

    @Transactional(readOnly = true)
    public List<PedidoViewProjection> listarPedidos() {
        return repository.listarPedidos();
    }

    @Transactional(readOnly = true)
    public PedidoViewProjection findPedido(Long id) {
        return repository.pedidoById(id);
    }

    @Transactional
    public void atualizarStatusPedido(Long id, PedidoDTO.UpdateStatus dto) {
        repository.updateStatusPedido(id, dto.statusId());
    }

    @Transactional
    public void cancelarPedido(Long id) {
        repository.cancelarPedido(id);
    }

    // ── ITENS DO PEDIDO ───────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<PedidoItemProjection> listarItens(Long pedidoId) {
        return repository.listarItensPedido(pedidoId);
    }

    @Transactional
    public void adicionarItem(Long pedidoId, PedidoDTO.AddItem dto) {
        repository.addItemPedido(
                pedidoId,
                dto.produtoId(),
                dto.quantidade(),
                dto.valorPago());
    }

    @Transactional
    public void atualizarItem(Long pedidoId, Long produtoId, PedidoDTO.UpdateItem dto) {
        repository.updateItemPedido(pedidoId, produtoId, dto.quantidade());
    }

    @Transactional
    public void removerItem(Long pedidoId, Long produtoId) {
        repository.removeItemPedido(pedidoId, produtoId);
    }
}