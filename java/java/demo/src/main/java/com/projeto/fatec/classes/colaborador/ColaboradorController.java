package com.projeto.fatec.classes.colaborador;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/colaboradores")
@RequiredArgsConstructor
public class ColaboradorController {

    private final ColaboradorService service;

    // CREATE
    @PostMapping
    public ResponseEntity<String> criar(@RequestBody ColaboradorDTO.Insert dto) {
        service.criarColaborador(dto);
        return ResponseEntity.ok("Colaborador criado com sucesso");
    }

    // GET
    @GetMapping
    public List<ColaboradorViewProjection> listar() {
        return service.listarColaboradores();
    }

    @GetMapping("/{id}")
    public ColaboradorViewProjection find(@PathVariable Long id) {
        return service.findColaborador(id);
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<String> atualizar(@PathVariable Long id, @RequestBody ColaboradorDTO.Update dto) {
        service.atualizarColaborador(dto);
        return ResponseEntity.ok("Colaborador atualizado com sucesso");
    }

    // SOFT DELETE (INATIVAR)
    @DeleteMapping("/{id}")
    public ResponseEntity<String> inativar(@PathVariable Long id) {
        service.inativarColaborador(id);
        return ResponseEntity.ok("Colaborador inativado com sucesso");
    }
}