package com.projeto.fatec.classes.pedido.item;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProdutoPedidoRepository extends JpaRepository<ProdutoPedidoEntity, ProdutoPedidoId> {

}
