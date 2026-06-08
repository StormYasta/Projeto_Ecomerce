package com.projeto.fatec.classes.cliente;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ClienteRepository extends JpaRepository<ClienteEntity, Long> {

        @Procedure(procedureName = "SP_insert_cliente")
        void inserirCliente(
                        @Param("Nome") String nome,
                        @Param("Sobrenome") String sobrenome,
                        @Param("CPF") String cpf,
                        @Param("Status_Id") Integer statusId,
                        @Param("Data_Nascimento") LocalDate dataNascimento,
                        @Param("Nome_Social") String nomeSocial,
                        @Param("Sobrenome_Social") String sobrenomeSocial,
                        @Param("Email") String email,
                        @Param("Telefone") String telefone,
                        @Param("CEP") String cep,
                        @Param("Numero") String numero,
                        @Param("Logradouro") String logradouro,
                        @Param("Bairro") String bairro,
                        @Param("Cidade") String cidade,
                        @Param("UF") String uf,
                        @Param("Complemento") String complemento,
                        @Param("Login") String login,
                        @Param("Hash_Senha") String hashSenha
                );

        @Query(value = "SELECT * FROM VW_clientes_completos", nativeQuery = true)
        List<ClienteViewProjection> listarClientes();

        @Query(value = "SELECT * FROM FN_Cliente_BYID(:id)", nativeQuery = true)
        ClienteViewProjection clienteById(@Param("id") Long id);

        @Procedure(procedureName = "SP_update_cliente")
        void updateCliente(
                        @Param("IdPessoa") Long idPessoa,
                        @Param("Nome") String nome,
                        @Param("Sobrenome") String sobrenome,
                        @Param("CPF") String cpf,
                        @Param("Status_Id") Integer statusId,
                        @Param("Data_Nascimento") LocalDate dataNascimento,
                        @Param("Nome_Social") String nomeSocial,
                        @Param("Sobrenome_Social") String sobrenomeSocial);

        @Procedure(procedureName = "SP_inactivate_pessoa")
        void inactivatePessoa(Long idPessoa);
}