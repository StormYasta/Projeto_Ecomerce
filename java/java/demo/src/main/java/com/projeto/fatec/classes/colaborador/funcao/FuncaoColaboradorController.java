package com.projeto.fatec.classes.colaborador.funcao;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/funccolaboradores")
@RequiredArgsConstructor
public class FuncaoColaboradorController {

    private final FuncaoColaboradorService service;

      // GET
    @GetMapping
    public List<FuncaoColaboradorEntity> listar() {
        return service.listarFuncoes();
    }
}
