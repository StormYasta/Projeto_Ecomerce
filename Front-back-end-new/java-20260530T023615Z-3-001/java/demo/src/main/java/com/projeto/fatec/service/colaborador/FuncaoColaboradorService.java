package com.projeto.fatec.service.colaborador;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.colaborador.FuncaoColaboradorEntity;
import com.projeto.fatec.repository.colaborador.FuncaoColaboradorRepository;

import jakarta.transaction.Transactional;

@Service
public class FuncaoColaboradorService {

    private final FuncaoColaboradorRepository funcaoColaboradorRepository;

    public FuncaoColaboradorService(FuncaoColaboradorRepository funcaoColaboradorRepository) {
        this.funcaoColaboradorRepository = funcaoColaboradorRepository;
    }

    @Transactional
    public FuncaoColaboradorEntity newFuncaoColaborador(FuncaoColaboradorEntity funcaoColaborador) {
        if (funcaoColaborador == null) {
            throw new IllegalArgumentException("Função de colaborador não pode ser null");
        }
        return funcaoColaboradorRepository.save(funcaoColaborador);
    }
}
