package com.projeto.fatec.service.pessoa;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.projeto.fatec.entity.pessoa.PessoaEntity;
import com.projeto.fatec.entity.pessoa.StatusPessoaEntity;
import com.projeto.fatec.repository.pessoa.PessoaRepository;
import com.projeto.fatec.repository.pessoa.StatusPessoaRepository;
import com.projeto.fatec.utils.CpfValidator;
import com.projeto.fatec.utils.NascimentoValidator;

import jakarta.transaction.Transactional;

import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PessoaService {

    private final PessoaRepository pessoaRepository;
    private final StatusPessoaRepository statusPessoaRepository;

    @SuppressWarnings("null")
    @Transactional
    public PessoaEntity newPessoa(@NonNull PessoaEntity pessoa) {

        if (!CpfValidator.isValid(pessoa.getCpf())) {
            throw new IllegalArgumentException("CPF inválido: " + pessoa.getCpf());
        }

        if (!NascimentoValidator.isValid(pessoa.getDataNascimento())) {
            throw new IllegalArgumentException(
                    "Data de nascimento inválida: " + pessoa.getDataNascimento());
        }

        if (pessoa.getNome() == null || pessoa.getNome().length() < 3) {
            throw new IllegalArgumentException(
                    "O nome deve conter pelo menos 3 caracteres: " + pessoa.getNome());
        }

        if (pessoa.getSobrenome() == null || pessoa.getSobrenome().length() < 1) {
            throw new IllegalArgumentException(
                    "O sobrenome deve conter pelo menos 1 caracter: " + pessoa.getSobrenome());
        }

        StatusPessoaEntity status = statusPessoaRepository.getReferenceById(
                pessoa.getStatus().getId());

        pessoa.setStatus(status);

        return pessoaRepository.save(pessoa);
    }

    @Transactional
    public List<PessoaEntity> listPessoas() {
        return pessoaRepository.findAll();
    }

    @Transactional
    public PessoaEntity findPessoa(@NonNull Long id) {
        return pessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pessoa não encontrada"));
    }

    @SuppressWarnings("null")
    @Transactional
    public void deletePessoa(@NonNull Long id) {
        PessoaEntity pessoa = pessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pessoa não encontrada"));

        pessoaRepository.delete(pessoa);
    }

    @SuppressWarnings("null")
    @Transactional
    public PessoaEntity updatePessoa(@NonNull Long id, @NonNull PessoaEntity dados) {

        PessoaEntity pessoa = pessoaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pessoa não encontrada"));

        if (dados.getCpf() != null && !CpfValidator.isValid(dados.getCpf())) {
            throw new IllegalArgumentException("CPF inválido: " + dados.getCpf());
        }

        if (dados.getDataNascimento() != null && !NascimentoValidator.isValid(dados.getDataNascimento())) {
            throw new IllegalArgumentException("Data de nascimento inválida: " + dados.getDataNascimento());
        }

        if (dados.getNome() != null && dados.getNome().length() < 3) {
            throw new IllegalArgumentException("Nome inválido");
        }

        if (dados.getSobrenome() != null && dados.getSobrenome().length() < 1) {
            throw new IllegalArgumentException("Sobrenome inválido");
        }

        if (dados.getCpf() != null) {
            pessoa.setCpf(dados.getCpf());
        }

        if (dados.getDataNascimento() != null) {
            pessoa.setDataNascimento(dados.getDataNascimento());
        }

        if (dados.getNomeSocial() != null) {
            pessoa.setNomeSocial(dados.getNomeSocial());
        }

        if (dados.getSobrenomeSocial() != null) {
            pessoa.setSobrenomeSocial(dados.getSobrenomeSocial());
        }

        if (dados.getStatus() != null && dados.getStatus().getId() != null) {
            StatusPessoaEntity status = statusPessoaRepository.getReferenceById(
                    dados.getStatus().getId());
            pessoa.setStatus(status);
        }
        
        if (dados.getEnderecos() != null) {
            dados.getEnderecos().forEach(e -> e.setPessoa(pessoa));

            pessoa.getEnderecos().clear();
            pessoa.getEnderecos().addAll(dados.getEnderecos());
        }

        return pessoaRepository.save(pessoa);
    }
}