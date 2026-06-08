package com.projeto.fatec.classes.pedido;

import java.math.BigInteger;
import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PedidoRepository extends JpaRepository<PedidoEntity, Long> {

    @Procedure(procedureName = "SP_insert_pedido")
    void insertPedido(
        @Param("clienteId") BigInteger clienteId,
        @Param("produtoId") BigInteger produtoId,
        @Param("statusId") Integer statusId,
        @Param("dataPedido") LocalDate dataPedido
    );

    @Query(value = "SELECT * FROM VW_pedidos(:id)", nativeQuery = true)
    PedidoViewProjection pedidoById(@Param("id") Long id);

    @Procedure(procedureName = "SP_update_pedido")
    void updatePedido(
        @Param("id") Long id,
        @Param("clienteId") BigInteger clienteId,
        @Param("produtoId") BigInteger produtoId,
        @Param("statusId") Integer statusId
    );

    @Procedure(procedureName = "SP_cancel_pedido")
    void cancelPedido(@Param("id") Long id);

    @Query(value = "SELECT * FROM VW_pedidos", nativeQuery = true)
    List<PedidoViewProjection> listPedidos();
}
