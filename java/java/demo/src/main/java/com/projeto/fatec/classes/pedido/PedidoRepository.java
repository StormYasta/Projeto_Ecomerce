package com.projeto.fatec.classes.pedido;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface PedidoRepository extends JpaRepository<PedidoEntity, Long> {

        // ── PEDIDO ────────────────────────────────────────────────────────────────

        @Procedure(procedureName = "SP_insert_pedido")
        void insertPedido(
                        @Param("Cliente_Id") Long clienteId);

        @Query(value = "SELECT * FROM VW_pedidos", nativeQuery = true)
        List<PedidoViewProjection> listarPedidos();

        @Query(value = "SELECT * FROM FN_Pedido_BYID(:id)", nativeQuery = true)
        PedidoViewProjection pedidoById(@Param("id") Long id);

        @Procedure(procedureName = "SP_update_pedido")
        void updateStatusPedido(
                        @Param("IdPedido") Long idPedido,
                        @Param("Status_Id") Integer statusId);

        @Procedure(procedureName = "SP_delete_pedido")
        void cancelarPedido(
                        @Param("IdPedido") Long idPedido);

        // ── ITENS DO PEDIDO ───────────────────────────────────────────────────────

        @Query(value = "SELECT * FROM FN_view_produtos_pedido_BYID(:pedidoId)", nativeQuery = true)
        List<PedidoItemProjection> listarItensPedido(@Param("pedidoId") Long pedidoId);

        @Procedure(procedureName = "SP_add_produto_pedido")
        void addItemPedido(
                        @Param("Pedido_Id") Long pedidoId,
                        @Param("Produto_Id") Long produtoId,
                        @Param("Quantidade") Integer quantidade,
                        @Param("Valor_pago") BigDecimal valorPago);

        @Procedure(procedureName = "SP_update_produto_pedido")
        void updateItemPedido(
                        @Param("Pedido_Id") Long pedidoId,
                        @Param("Produto_Id") Long produtoId,
                        @Param("QuantidadeNova") Integer quantidadeNova);

        @Procedure(procedureName = "SP_remove_produto_pedido")
        void removeItemPedido(
                        @Param("Pedido_Id") Long pedidoId,
                        @Param("Produto_Id") Long produtoId);
}