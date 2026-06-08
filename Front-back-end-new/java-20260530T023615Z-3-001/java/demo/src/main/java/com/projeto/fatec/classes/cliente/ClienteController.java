package com.projeto.fatec.classes.cliente;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/clientes")
@RequiredArgsConstructor
public class ClienteController {

    private final ClienteService service;

    // CREATE
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody ClienteDTO.Insert dto) {
        service.criarCliente(dto);
        return ResponseEntity.ok("Cliente criado com sucesso");
    }

    // GET
    @GetMapping
    public List<ClienteViewProjection> listar() {
        return service.listarClientes();
    }

    @GetMapping("/{id}")
    public ClienteViewProjection find(@PathVariable Long id) {
        return service.findCliente(id);
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<String> atualizar(@PathVariable Long id, @RequestBody ClienteDTO.Update dto) {
        service.atualizarCliente(dto);
        return ResponseEntity.ok("Cliente atualizado com sucesso");
    }

    // SOFT DELETE (INATIVAR)
    @DeleteMapping("/{id}")
    public ResponseEntity<String> inativar(@PathVariable Long id) {
        service.inativarCliente(id);
        return ResponseEntity.ok("Cliente inativado com sucesso");
    }
}