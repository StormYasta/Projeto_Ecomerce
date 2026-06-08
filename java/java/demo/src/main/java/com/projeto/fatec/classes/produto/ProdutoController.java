package com.projeto.fatec.classes.produto;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
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
@RequestMapping("/produtos")
@RequiredArgsConstructor
public class ProdutoController {

    private final ProdutoService service;

    //CREATE
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody ProdutoDTO.Insert dto) {
        service.criarProduto(dto);
        return ResponseEntity.ok("Produto criado com sucesso");
    }
    
    //GET
    @GetMapping
    public List<ProdutoViewProjection> listar() {
        return service.listarProdutos();
    }

    @GetMapping("/{id}")
    public ProdutoViewProjection find(@PathVariable Long id) {
        return service.findProduto(id);
    }

    //UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<String> atualizar(@PathVariable Long id, @RequestBody ProdutoDTO.Update dto) {
        service.atualizarProduto(dto);
        return ResponseEntity.ok("Produto atualizado com sucesso");
    }

    //SOFT DELETE (INATIVAR)
    @DeleteMapping("/{id}")
    public ResponseEntity<String> inativar(@PathVariable @NonNull Long id) {
        service.inativarProduto(id);
        return ResponseEntity.ok("Produto inativado com sucesso");
    }
}
