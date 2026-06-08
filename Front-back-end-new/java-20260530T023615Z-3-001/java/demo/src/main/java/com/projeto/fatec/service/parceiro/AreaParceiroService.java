package com.projeto.fatec.service.parceiro;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.parceiro.AreaParceiroEntity;
import com.projeto.fatec.repository.parceiro.AreaParceiroRepository;

import jakarta.transaction.Transactional;

@Service
public class AreaParceiroService {

    private final AreaParceiroRepository areaParceiroRepository;

    public AreaParceiroService(AreaParceiroRepository areaParceiroRepository) {
        this.areaParceiroRepository = areaParceiroRepository;
    }

    @Transactional
    public AreaParceiroEntity newAreaParceiro(AreaParceiroEntity areaParceiro) {

        if (areaParceiro == null) {
            throw new IllegalArgumentException("Argumento area parceiro passado como null");
        }

        return areaParceiroRepository.save(areaParceiro);
    }
}
