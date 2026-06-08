package com.projeto.fatec.classes.pedido.status;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/pedidos/status")
@RequiredArgsConstructor
public class StatusPedidoController {

    private final StatusPedidoService service;

    @GetMapping
    public List<StatusPedidoEntity> listar() {
        return service.listarStatusPedidos();
    }
}
