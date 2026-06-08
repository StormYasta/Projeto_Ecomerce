package com.projeto.fatec.service.fornecedor;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.fornecedor.FornecedorEntity;
import com.projeto.fatec.repository.fornecedor.FornecedorRepository;

import jakarta.transaction.Transactional;

@Service
public class FornecedorService {

    private final FornecedorRepository fornecedorRepository;

    public FornecedorService(FornecedorRepository fornecedorRepository) {
        this.fornecedorRepository = fornecedorRepository;
    }

    @Transactional
    public FornecedorEntity newFornecedor(FornecedorEntity fornecedor) {

        if (fornecedor == null) {
            throw new IllegalArgumentException("Fornecedor não pode ser null");
        }

        return fornecedorRepository.save(fornecedor);
    }
}
