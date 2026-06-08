package com.projeto.fatec.service.pessoa;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.pessoa.EmailPessoaEntity;
import com.projeto.fatec.repository.pessoa.EmailPessoaRepository;
import jakarta.transaction.Transactional;
import com.projeto.fatec.utils.EmailValidator;

@Service
public class EmailPessoaService {

    private final EmailPessoaRepository emailPessoaRepository;

    public EmailPessoaService(
            EmailPessoaRepository emailPessoaRepository) {
        this.emailPessoaRepository = emailPessoaRepository;
    }

    @Transactional
    public EmailPessoaEntity newEmailPessoa(EmailPessoaEntity emailPessoa) {

        if (!EmailValidator.isValid(emailPessoa.getEmail())) {
            throw new IllegalArgumentException(
                    "E-mail inválido: " + emailPessoa.getEmail());
        }

        return emailPessoaRepository.save(emailPessoa);
    }
}
