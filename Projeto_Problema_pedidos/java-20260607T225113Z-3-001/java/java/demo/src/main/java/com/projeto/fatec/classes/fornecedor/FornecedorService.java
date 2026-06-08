package com.projeto.fatec.classes.fornecedor;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FornecedorService {

    private final FornecedorRepository repository;

    @Transactional
    public void criarFornecedor(FornecedorDTO.Insert dto) {
        repository.insertFornecedor(
                dto.nome(),
                dto.cnpj(),
                dto.email(),
                dto.telefone(),
                dto.descricao());
    }

    @Transactional(readOnly = true)
    public List<FornecedorViewProjection> listarFornecedores() {
        return repository.listarFornecedores();
    }

    @Transactional(readOnly = true)
    public List<FornecedorViewProjection> listarFornecedoresAtivos() {
        return repository.listarFornecedoresAtivos();
    }

    @Transactional(readOnly = true)
    public FornecedorViewProjection findFornecedor(Long id) {
        return repository.fornecedorById(id);
    }

    @Transactional
    public void atualizarFornecedor(FornecedorDTO.Update dto) {
        repository.updateFornecedor(
                dto.id(),
                dto.nome(),
                dto.cnpj(),
                dto.email(),
                dto.telefone(),
                dto.descricao());
    }

    @Transactional
    public void ativarFornecedor(Long id) {
        repository.activateFornecedor(id);
    }

    @Transactional
    public void inativarFornecedor(Long id) {
        repository.inactivateFornecedor(id);
    }
}