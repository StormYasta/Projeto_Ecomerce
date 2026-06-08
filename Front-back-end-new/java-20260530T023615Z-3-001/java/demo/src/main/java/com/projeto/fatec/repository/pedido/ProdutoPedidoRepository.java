
package com.projeto.fatec.repository.pedido;

import com.projeto.fatec.entity.pedido.ProdutoPedidoEntity;
import com.projeto.fatec.entity.pedido.ProdutoPedidoIdEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProdutoPedidoRepository extends JpaRepository<ProdutoPedidoEntity, ProdutoPedidoIdEntity> {
}