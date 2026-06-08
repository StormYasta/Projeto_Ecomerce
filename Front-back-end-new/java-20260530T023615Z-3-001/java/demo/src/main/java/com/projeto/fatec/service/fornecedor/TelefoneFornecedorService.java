package com.projeto.fatec.service.fornecedor;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.fornecedor.TelefoneFornecedorEntity;
import com.projeto.fatec.repository.fornecedor.TelefoneFornecedorRepository;
import com.projeto.fatec.utils.TelefoneValidator;

import jakarta.transaction.Transactional;

@Service
public class TelefoneFornecedorService {

    private final TelefoneFornecedorRepository telefoneFornecedorRepository;

    public TelefoneFornecedorService(TelefoneFornecedorRepository telefoneFornecedorRepository) {
        this.telefoneFornecedorRepository = telefoneFornecedorRepository;
    }

    @Transactional
    public TelefoneFornecedorEntity newTelefoneFornecedor(TelefoneFornecedorEntity telefoneFornecedor) {
        if (telefoneFornecedor == null) {
            throw new IllegalArgumentException("Telefone do Fornecedor não pode ser null");
        }

        if (!TelefoneValidator.isValid(telefoneFornecedor.getTelefone())) {
            throw new IllegalArgumentException("Telefone do Fornecedor é inválido");
        }

        return telefoneFornecedorRepository.save(telefoneFornecedor);
    }
}
