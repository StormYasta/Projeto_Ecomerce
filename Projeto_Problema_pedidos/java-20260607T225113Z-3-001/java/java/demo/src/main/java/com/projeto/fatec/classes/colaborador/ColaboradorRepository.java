package com.projeto.fatec.classes.colaborador;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface ColaboradorRepository extends JpaRepository<ColaboradorEntity, Long> {

        @Procedure(procedureName = "SP_insert_colaborador")
        void insertColaborador(
                        @Param("Nome") String nome,
                        @Param("Sobrenome") String sobrenome,
                        @Param("CPF") String cpf,
                        @Param("Status_Id") Integer statusId,
                        @Param("Data_Nascimento") LocalDate dataNascimento,
                        @Param("Email") String email,
                        @Param("Telefone") String telefone,
                        @Param("CEP") String cep,
                        @Param("Numero") String numero,
                        @Param("Logradouro") String logradouro,
                        @Param("Bairro") String bairro,
                        @Param("Cidade") String cidade,
                        @Param("UF") String uf,
                        @Param("Complemento") String complemento,
                        @Param("Funcao") Integer funcao,
                        @Param("Salario_Inicial") BigDecimal salarioInicial,
                        @Param("Data_Registro") LocalDate dataResgistro,
                        @Param("Num_CTPS") String numeroCTPS,
                        @Param("Num_CNH") String numeroCNH,
                        @Param("Login") String login,
                        @Param("Hash_Senha") String hashSenha);

        @Query(value = "SELECT * FROM VW_colaboradores_completos", nativeQuery = true)
        List<ColaboradorViewProjection> listarColaboradores();

        @Query(value = "SELECT * FROM FN_Colaboarador_BYID(:id)", nativeQuery = true)
        ColaboradorViewProjection ColaboradorById(@Param("id") Long id);

        @Procedure(procedureName = "SP_update_colaborador")
        void updateColaborador(
                        @Param("IdPessoa") Long idPessoa,
                        @Param("Nome") String nome,
                        @Param("Sobrenome") String sobrenome,
                        @Param("CPF") String cpf,
                        @Param("Status_Id") Integer statusId,
                        @Param("Data_Nascimento") LocalDate dataNascimento,
                        @Param("Funcao") Integer funcao,
                        @Param("Salario_atual") BigDecimal salarioAtual,
                        @Param("Data_Registro") LocalDate dataRegistro,
                        @Param("Num_CTPS") String CTPS,
                        @Param("Num_CNH") String CNH);

        @Procedure(procedureName = "SP_inactivate_pessoa")
        void inactivatePessoa(Long idPessoa);
}
