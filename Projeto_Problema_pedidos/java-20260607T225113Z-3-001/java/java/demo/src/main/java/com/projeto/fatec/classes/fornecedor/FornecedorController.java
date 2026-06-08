package com.projeto.fatec.classes.fornecedor;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/fornecedores")
@RequiredArgsConstructor
public class FornecedorController {

    private final FornecedorService service;

    // CREATE
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody FornecedorDTO.Insert dto) {
        service.criarFornecedor(dto);
        return ResponseEntity.ok("Fornecedor criado com sucesso");
    }

    // GET ALL
    @GetMapping
    public List<FornecedorViewProjection> listar() {
        return service.listarFornecedores();
    }

    // GET ATIVOS
    @GetMapping("/ativos")
    public List<FornecedorViewProjection> listarAtivos() {
        return service.listarFornecedoresAtivos();
    }

    // GET BY ID
    @GetMapping("/{id}")
    public FornecedorViewProjection find(@PathVariable Long id) {
        return service.findFornecedor(id);
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<String> atualizar(@PathVariable Long id, @RequestBody FornecedorDTO.Update dto) {
        service.atualizarFornecedor(dto);
        return ResponseEntity.ok("Fornecedor atualizado com sucesso");
    }

    @PutMapping("ativar/{id}")
    public ResponseEntity<String> ativar(@PathVariable Long id) {
        service.ativarFornecedor(id);;
        return ResponseEntity.ok("Fornecedor ativado com sucesso");
    }

    // SOFT DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<String> inativar(@PathVariable Long id) {
        service.inativarFornecedor(id);
        return ResponseEntity.ok("Fornecedor inativado com sucesso");
    }
}