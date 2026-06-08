package com.projeto.fatec.service.pessoa;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.projeto.fatec.entity.pessoa.EnderecoPessoaEntity;
import com.projeto.fatec.repository.pessoa.EnderecoPessoaRepository;
import com.projeto.fatec.utils.CepValidator;

import jakarta.transaction.Transactional;

import lombok.NonNull;

@Service
public class EnderecoPessoaService {

    private final EnderecoPessoaRepository enderecoPessoaRepository;
    private final CepValidator cepValidator;

    public EnderecoPessoaService(
            EnderecoPessoaRepository enderecoPessoaRepository,
            CepValidator cepValidator) {
        this.enderecoPessoaRepository = enderecoPessoaRepository;
        this.cepValidator = cepValidator;
    }

    @Transactional
    public EnderecoPessoaEntity newEnderecoPessoa(EnderecoPessoaEntity enderecoPessoa) {

        if (enderecoPessoa == null) {
            throw new IllegalArgumentException("Endereço não pode ser null");
        }

        if (enderecoPessoa.getPessoa() == null || enderecoPessoa.getPessoa().getId() == null) {
            throw new IllegalArgumentException("Pessoa é obrigatória");
        }

        if (!cepValidator.isValid(enderecoPessoa.getCep())) {
            throw new IllegalArgumentException(
                    "CEP informado não encontrado: " + enderecoPessoa.getCep());
        }
        EnderecoPessoaEntity salvo = enderecoPessoaRepository.save(enderecoPessoa);

        return salvo;
    }

    @Transactional
    public List<EnderecoPessoaEntity> listEnderecos() {
        return enderecoPessoaRepository.findAll();
    }

    @Transactional
    public EnderecoPessoaEntity findEndereco(@NonNull Long id) {
        return enderecoPessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Endereço não encontrado"));
    }

    @SuppressWarnings("null")
    @Transactional
    public void deleteEndereco(@NonNull Long id) {
        EnderecoPessoaEntity endereco = enderecoPessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Endereço não encontrado"));

        enderecoPessoaRepository.delete(endereco);
    }

    @SuppressWarnings("null")
    @Transactional
    public EnderecoPessoaEntity updateEndereco(@NonNull Long id, @NonNull EnderecoPessoaEntity dados) {

        EnderecoPessoaEntity endereco = enderecoPessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Endereço não encontrado"));

        if (dados.getCep() != null) {
            endereco.setCep(dados.getCep());
        }

        if (dados.getNumero() != null) {
            endereco.setNumero(dados.getNumero());
        }

        if (dados.getLogradouro() != null) {
            endereco.setLogradouro(dados.getLogradouro());
        }

        if (dados.getBairro() != null) {
            endereco.setBairro(dados.getBairro());
        }

        if (dados.getCidade() != null) {
            endereco.setCidade(dados.getCidade());
        }

        if (dados.getUf() != null) {
            endereco.setUf(dados.getUf());
        }

        if (dados.getComplemento() != null) {
            endereco.setComplemento(dados.getComplemento());
        }

        if (dados.getPrincipal() != null && dados.getPrincipal()) {

            List<EnderecoPessoaEntity> enderecosDaPessoa = enderecoPessoaRepository
                    .findByPessoa_Id(endereco.getPessoa().getId());

            for (EnderecoPessoaEntity e : enderecosDaPessoa) {
                e.setPrincipal(false);
            }

            endereco.setPrincipal(true);
        }

        return enderecoPessoaRepository.save(endereco);
    }
}