package com.projeto.fatec.classes.pedido;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/pedidos")
@RequiredArgsConstructor
public class PedidoController {

    private final PedidoService service;

    //CREATE
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody PedidoDTO.Insert dto) {
        service.insertPedido(dto);
        return ResponseEntity.ok("Pedido criado com sucesso");
    }

    //GET
    @GetMapping
    public List<PedidoViewProjection> listPedidos() {
        return service.listPedidos();
    }

    @GetMapping("/{id}")
    public PedidoViewProjection findPedido(@PathVariable Long id) {
        return service.findPedido(id);
    }

    //UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<String> updatePedido(@PathVariable Long id, @RequestBody PedidoDTO.Update dto) {
        service.updatePedido(dto);
        return ResponseEntity.ok("Pedido atualizado com sucesso");
    }

    //DELETE
    @DeleteMapping("/cancelar/{id}")
    public ResponseEntity<String> cancelPedido(@PathVariable Long id) {
        service.cancelPedido(id);
        return ResponseEntity.ok("Pedido cancelado com sucesso");
    }
}
