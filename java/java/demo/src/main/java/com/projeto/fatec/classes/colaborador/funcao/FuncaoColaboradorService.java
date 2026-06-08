package com.projeto.fatec.classes.colaborador.funcao;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FuncaoColaboradorService {

    private final FuncaoColaboradorRepository repository;

    @Transactional
    public List<FuncaoColaboradorEntity> listarFuncoes() {
        return repository.findByAtivoTrue();
    }
}
