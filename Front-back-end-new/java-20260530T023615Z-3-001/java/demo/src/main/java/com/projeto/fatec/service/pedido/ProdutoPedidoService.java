package com.projeto.fatec.service.pedido;

import com.projeto.fatec.entity.pedido.ProdutoPedidoEntity;
import com.projeto.fatec.repository.pedido.ProdutoPedidoRepository;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class ProdutoPedidoService {

    private final ProdutoPedidoRepository produtoPedidoRepository;

    public ProdutoPedidoService(ProdutoPedidoRepository produtoPedidoRepository) {
        this.produtoPedidoRepository = produtoPedidoRepository;
    }

    @Transactional
    public ProdutoPedidoEntity newProdutoPedido(ProdutoPedidoEntity produtoPedido) {

         if (produtoPedido == null) {
            throw new IllegalArgumentException("Argumento produto pedido passado como null");
        }

        return produtoPedidoRepository.save(produtoPedido);
    }
}
