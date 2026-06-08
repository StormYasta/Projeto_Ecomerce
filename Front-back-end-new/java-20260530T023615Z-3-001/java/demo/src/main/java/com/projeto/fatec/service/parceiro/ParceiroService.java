package com.projeto.fatec.service.parceiro;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.parceiro.ParceiroEntity;
import com.projeto.fatec.repository.parceiro.ParceiroRepository;

import jakarta.transaction.Transactional;

@Service
public class ParceiroService {

    private final ParceiroRepository parceiroRepository;

    public ParceiroService(ParceiroRepository parceiroRepository) {
        this.parceiroRepository = parceiroRepository;
    }

    @Transactional
    public ParceiroEntity newParceiro(ParceiroEntity parceiro) {
        
        if (parceiro == null) {
            throw new IllegalArgumentException("Argumento area parceiro passado como null");
        }

        return parceiroRepository.save(parceiro);
    }
}
