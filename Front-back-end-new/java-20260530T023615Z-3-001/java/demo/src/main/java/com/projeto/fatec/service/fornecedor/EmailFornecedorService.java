package com.projeto.fatec.service.fornecedor;

import com.projeto.fatec.entity.fornecedor.EmailFornecedorEntity;
import com.projeto.fatec.repository.fornecedor.EmailFornecedorRepository;
import com.projeto.fatec.utils.EmailValidator;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class EmailFornecedorService {

    private final EmailFornecedorRepository emailFornecedorRepository;

    public EmailFornecedorService(EmailFornecedorRepository emailFornecedorRepository) {
        this.emailFornecedorRepository = emailFornecedorRepository;
    }

    @Transactional
    public EmailFornecedorEntity newEmailFornecedor(EmailFornecedorEntity emailFornecedor) {
        if (emailFornecedor == null) {
            throw new IllegalArgumentException("Email do Fornecedor não pode ser null");
        }

        if (!EmailValidator.isValid(emailFornecedor.getEmail())) {
            throw new IllegalArgumentException("Email do Fornecedor é inválido");
        }

        return emailFornecedorRepository.save(emailFornecedor);
    }
}