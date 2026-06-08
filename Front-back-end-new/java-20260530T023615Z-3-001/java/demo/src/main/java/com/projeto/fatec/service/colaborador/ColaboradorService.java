package com.projeto.fatec.service.colaborador;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.colaborador.ColaboradorEntity;
import com.projeto.fatec.repository.colaborador.ColaboradorRepository;

import io.micrometer.common.lang.NonNull;
import jakarta.transaction.Transactional;

@Service
public class ColaboradorService {

    private final ColaboradorRepository colaboradorRepository;

    public ColaboradorService(ColaboradorRepository colaboradorRepository) {
        this.colaboradorRepository = colaboradorRepository;
    }

    @SuppressWarnings("null")
    @Transactional
    public ColaboradorEntity newColaborador(@NonNull ColaboradorEntity colaborador) {
    
        return colaboradorRepository.save(colaborador);
    }
      
}
