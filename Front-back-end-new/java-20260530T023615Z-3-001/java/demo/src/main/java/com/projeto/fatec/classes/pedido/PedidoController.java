package com.projeto.fatec.classes.pedido;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
    public void insertPedido(PedidoDTO.Insert dto) {
        service.insertPedido(dto);
    }

    //GET
    @GetMapping
    public List<PedidoViewProjection> listPedidos() {
        return service.listPedidos();
    }

    @GetMapping("/{id}")
    public PedidoViewProjection findPedido(Long id) {
        return service.findPedido(id);
    }

    //UPDATE
    @PostMapping("/{id}")
    public void updatePedido(PedidoDTO.Update dto) {
        service.updatePedido(dto);
    }

    //DELETE
    @PostMapping("/cancelar/{id}")
    public void cancelPedido(Long id) {
        service.cancelPedido(id);
    }
}
