package com.projeto.fatec.service.pessoa;

import org.springframework.stereotype.Service;

import com.projeto.fatec.entity.pessoa.TelefonePessoaEntity;
import com.projeto.fatec.repository.pessoa.TelefonePessoaRepository;
import com.projeto.fatec.utils.TelefoneValidator;

import jakarta.transaction.Transactional;

@Service
public class TelefonePessoaService {

    private final TelefonePessoaRepository TelefonePessoaRepository;

    public TelefonePessoaService(
            TelefonePessoaRepository TelefonePessoaRepository) {
        this.TelefonePessoaRepository = TelefonePessoaRepository;
    }

    @Transactional
    public TelefonePessoaEntity newTelefonePessoa(TelefonePessoaEntity telefonePessoa) {

        if (telefonePessoa == null || telefonePessoa.getTelefone() == null) {
            throw new IllegalArgumentException("TelefonePessoa ou número não pode ser nulo");
        }

        if (!TelefoneValidator.isValid(telefonePessoa.getTelefone())) {
            throw new IllegalArgumentException("Telefone inválido: " + telefonePessoa.getTelefone());
        }

        return TelefonePessoaRepository.save(telefonePessoa);
    }
}
