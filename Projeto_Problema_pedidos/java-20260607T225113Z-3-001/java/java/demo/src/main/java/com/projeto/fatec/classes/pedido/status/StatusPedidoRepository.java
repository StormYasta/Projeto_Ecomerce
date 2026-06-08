package com.projeto.fatec.classes.pedido.status;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StatusPedidoRepository extends JpaRepository<StatusPedidoEntity, Integer> {

    Optional<StatusPedidoEntity> findByDescricao(String descricao);

    boolean existsByDescricao(String descricao);
}
