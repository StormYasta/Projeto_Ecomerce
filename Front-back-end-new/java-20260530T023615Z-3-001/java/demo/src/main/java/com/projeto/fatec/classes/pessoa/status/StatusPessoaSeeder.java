package com.projeto.fatec.classes.pessoa.status;

import java.util.Optional;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.projeto.fatec.classes.pessoa.status.StatusPessoEnum.StatusPessoa;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class StatusPessoaSeeder implements CommandLineRunner {

    private final StatusPessoaRepository repository;

    @Override
    public void run(String... args) {

        for (StatusPessoa statusEnum : StatusPessoa.values()) {

            Optional<StatusPessoaEntity> existente =
                repository.findById(statusEnum.getId());

            if (existente.isEmpty()) {

                StatusPessoaEntity novo = new StatusPessoaEntity();
                novo.setId(statusEnum.getId());
                novo.setDescricao(statusEnum.getDescricao());

                repository.save(novo);

            } else {

                StatusPessoaEntity atual = existente.get();

                if (!atual.getDescricao().equals(statusEnum.getDescricao())) {
                    atual.setDescricao(statusEnum.getDescricao());
                    repository.save(atual);
                }
            }
        }
    }
}