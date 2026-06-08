package com.projeto.fatec.service.pessoa;

import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

import com.projeto.fatec.entity.pessoa.StatusPessoaEntity;
import com.projeto.fatec.repository.pessoa.StatusPessoaRepository;

@Service
public class StatusPessoaService {

    private final StatusPessoaRepository statusPessoaRepository;

    public StatusPessoaService(StatusPessoaRepository statusPessoaRepository) {
        this.statusPessoaRepository = statusPessoaRepository;
    }

    @Transactional
    public StatusPessoaEntity newStatusPessoa(StatusPessoaEntity statusPessoa) {
        if (statusPessoa == null) {
            throw new IllegalArgumentException("Argumento StatusPessoa passado como null");
        }

        if (statusPessoa.getDescricao() == null || statusPessoa.getDescricao().isEmpty()) {
            throw new IllegalArgumentException("Argumento Descrição passado como null");
        }

        if (statusPessoa.getDescricao().length() < 3) {
            throw new IllegalArgumentException(
                    "A descrição deve conter pelo menos 3 caracteres: " + statusPessoa.getDescricao());
        }

        return statusPessoaRepository.save(statusPessoa);
    }
}
