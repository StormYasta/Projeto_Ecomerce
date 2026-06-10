package com.projeto.fatec.classes.pedido;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/pedidos")
@RequiredArgsConstructor
public class PedidoController {

    private final PedidoService service;

    // ── PEDIDO ────────────────────────────────────────────────────────────────

    // POST /pedidos
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody PedidoDTO.Insert dto) {
        service.criarPedido(dto);
        return ResponseEntity.ok("Pedido criado com sucesso");
    }

    // GET /pedidos
    @GetMapping
    public List<PedidoViewProjection> listar() {
        return service.listarPedidos();
    }

    // GET /pedidos/{id}
    @GetMapping("/{id}")
    public PedidoViewProjection find(@PathVariable Long id) {
        return service.findPedido(id);
    }

    // PUT /pedidos/{id}/status  →  atualiza apenas o status (PENDENTE → ENVIADO etc.)
    @PutMapping("/{id}/status")
    public ResponseEntity<String> atualizarStatus(
            @PathVariable Long id,
            @RequestBody PedidoDTO.UpdateStatus dto) {
        service.atualizarStatusPedido(id, dto);
        return ResponseEntity.ok("Status do pedido atualizado com sucesso");
    }

    // DELETE /pedidos/{id}  →  cancelamento via SP_delete_pedido
    @DeleteMapping("/{id}")
    public ResponseEntity<String> cancelar(@PathVariable Long id) {
        service.cancelarPedido(id);
        return ResponseEntity.ok("Pedido cancelado com sucesso");
    }

    // ── ITENS DO PEDIDO ───────────────────────────────────────────────────────

    // GET /pedidos/{id}/itens
    @GetMapping("/{id}/itens")
    public List<PedidoItemProjection> listarItens(@PathVariable Long id) {
        return service.listarItens(id);
    }

    // POST /pedidos/{id}/itens
    @PostMapping("/{id}/itens")
    public ResponseEntity<String> adicionarItem(
            @PathVariable Long id,
            @RequestBody PedidoDTO.AddItem dto) {
        service.adicionarItem(id, dto);
        return ResponseEntity.ok("Item adicionado ao pedido com sucesso");
    }

    // PUT /pedidos/{id}/itens/{produtoId}
    @PutMapping("/{id}/itens/{produtoId}")
    public ResponseEntity<String> atualizarItem(
            @PathVariable Long id,
            @PathVariable Long produtoId,
            @RequestBody PedidoDTO.UpdateItem dto) {
        service.atualizarItem(id, produtoId, dto);
        return ResponseEntity.ok("Quantidade do item atualizada com sucesso");
    }

    // DELETE /pedidos/{id}/itens/{produtoId}
    @DeleteMapping("/{id}/itens/{produtoId}")
    public ResponseEntity<String> removerItem(
            @PathVariable Long id,
            @PathVariable Long produtoId) {
        service.removerItem(id, produtoId);
        return ResponseEntity.ok("Item removido do pedido com sucesso");
    }
}