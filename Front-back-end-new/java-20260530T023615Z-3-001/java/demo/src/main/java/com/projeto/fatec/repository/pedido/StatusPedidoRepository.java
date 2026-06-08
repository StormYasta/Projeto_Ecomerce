
package com.projeto.fatec.repository.pedido;

import com.projeto.fatec.entity.pedido.StatusPedidoEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StatusPedidoRepository extends JpaRepository<StatusPedidoEntity, Integer> {
}