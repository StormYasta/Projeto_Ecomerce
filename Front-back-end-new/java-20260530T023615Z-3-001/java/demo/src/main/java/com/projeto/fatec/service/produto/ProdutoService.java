package com.projeto.fatec.service.produto;

import com.projeto.fatec.entity.produto.ProdutoEntity;
import com.projeto.fatec.repository.produto.ProdutoRepository;

import jakarta.transaction.Transactional;

import org.springframework.stereotype.Service;

@Service
public class ProdutoService {

    private final ProdutoRepository produtoRepository;

    public ProdutoService(ProdutoRepository produtoRepository) {
        this.produtoRepository = produtoRepository;
    }

    @Transactional
    public ProdutoEntity newProduto(ProdutoEntity produto) {

        if (produto == null) {
            throw new IllegalArgumentException("Arumento Produto passado como null");
        }

        return produtoRepository.save(produto);
    }
}