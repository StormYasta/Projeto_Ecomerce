package com.projeto.fatec.classes.produto;

import java.util.List;

import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProdutoService {

    private final ProdutoRepository repository;
    
    @Transactional
    public void criarProduto(ProdutoDTO.Insert dto) {

        repository.inserirProduto(
                dto.nome(),
                dto.descricao(),
                dto.precoVenda(),
                dto.precoCusto(),
                dto.estoque(),
                dto.fornecedorId(),
                dto.imagemUrl());
    }

    @Transactional(readOnly = true)
    public ProdutoViewProjection findProduto(Long id) {
        return repository.produtoById(id);
    }

    @Transactional
    public void atualizarProduto(ProdutoDTO.Update dto) {

        repository.updateProduto(
                dto.id(),
                dto.nome(),
                dto.descricao(),
                dto.precoVenda(),
                dto.precoCusto(),
                dto.estoque(),
                dto.imagemUrl());
    }

    @Transactional (readOnly = true)
    public List<ProdutoViewProjection> listarProdutos() {
        return repository.listarProdutos();
    }

    @Transactional
    public void ativarProduto(@NonNull Long id) {
        repository.ativarProduto(id);
    }

    @Transactional
    public void inativarProduto(@NonNull Long id) {
        repository.inativarProduto(id);
    }
}
