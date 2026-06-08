package com.projeto.fatec.controller.pessoa;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.projeto.fatec.entity.pessoa.PessoaEntity;
import com.projeto.fatec.service.pessoa.PessoaService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/pessoa")
@RequiredArgsConstructor
public class PessoaController {

    private final PessoaService pessoaService;

    // CREATE
    @PostMapping
    public ResponseEntity<PessoaEntity> newPessoa(@RequestBody PessoaEntity pessoa) {
        return ResponseEntity.ok(pessoaService.newPessoa(pessoa));
    }

    // READ ALL
    @GetMapping
    public ResponseEntity<List<PessoaEntity>> listPessoas() {
        return ResponseEntity.ok(pessoaService.listPessoas());
    }

    // READ BY ID
    @GetMapping("/{id}")
    public ResponseEntity<PessoaEntity> findPessoa(@PathVariable Long id) {
        return ResponseEntity.ok(pessoaService.findPessoa(id));
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<PessoaEntity> updatePessoa(
            @PathVariable Long id,
            @RequestBody PessoaEntity pessoa) {

        return ResponseEntity.ok(pessoaService.updatePessoa(id, pessoa));
    }

    // DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePessoa(@PathVariable Long id) {
        pessoaService.deletePessoa(id);
        return ResponseEntity.noContent().build();
    }
}