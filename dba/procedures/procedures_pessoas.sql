USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA PESSOAS	-----------------
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_insert_cliente (

	-- Pessoa
	@Nome				VARCHAR(55),
	@Sobrenome			VARCHAR(55),
	@CPF				VARCHAR(11),
	@Status_Id			INT,
	@Data_Nascimento	DATE,

	-- Email
	@Email				VARCHAR(55),

	-- Telefone
	@Telefone			VARCHAR(55),

	-- Endereco
	@CEP				VARCHAR(8),
	@Numero				VARCHAR(5),
	@Logradouro			VARCHAR(255),
	@Bairro				VARCHAR(255),
	@Cidade				VARCHAR(255),
	@UF					VARCHAR(2),
	@Complemento		VARCHAR(255),

	-- Atributos de Usuario
	@Login				VARCHAR(255),
	@Hash_Senha			VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação do STATUS
		IF NOT EXISTS (
			SELECT 1
			FROM TB_status_pessoa
			WHERE id = @Status_Id
		)
			THROW 50001, 'Status de Pessoa inválido', 1;

		-- Validação de CPF único
		IF EXISTS (
			SELECT 1
			FROM TB_pessoas
			WHERE cpf = @CPF
		)
			THROW 50002, 'CPF já cadastrado', 1;

		-- INSERT de Pessoa
		INSERT INTO TB_pessoas
			(nome, sobrenome, cpf, status_id,
			 data_cadastro, data_nascimento,
			 created_at, updated_at)

		VALUES
			(@Nome, @Sobrenome, @CPF, @Status_Id,
			 GETDATE(), @Data_Nascimento,
			 GETDATE(), GETDATE());

		-- Captura Id_pessoa
		DECLARE @IdPessoa BIGINT;

		SET @IdPessoa = SCOPE_IDENTITY();

		-- INSERT de Email
		INSERT INTO TB_emails_pessoas
			(pessoa_id, email, principal)

		VALUES
			(@IdPessoa, @Email, 1);

		-- INSERT de Telefone
		INSERT INTO TB_telefones_pessoas
			(pessoa_id, telefone, principal)

		VALUES
			(@IdPessoa, @Telefone, 1);

		-- INSERT de Endereco
		INSERT INTO TB_enderecos_pessoas
			(pessoa_id, cep, numero,
			 logradouro, bairro,
			 cidade, uf, complemento,
			 principal)

		VALUES
			(@IdPessoa, @CEP, @Numero,
			 @Logradouro, @Bairro,
			 @Cidade, @UF, @Complemento,
			 1);

		-- INSERT de Cliente
		INSERT INTO TB_clientes
			(pessoa_id)

		VALUES
			(@IdPessoa);

		-- INSERT de Usuario
		INSERT INTO TB_usuarios
			(pessoa_id, usuario_role,
			 usuario_login, senha_hash,
			 created_at, updated_at)

		VALUES
			(@IdPessoa, 3,
			 @Login, @Hash_Senha,
			 GETDATE(), GETDATE());

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- CADASTRO DE COLABORADOR
CREATE PROCEDURE SP_insert_colaborador (
	
	-- Pessoa
	@Nome				VARCHAR(55),
	@Sobrenome			VARCHAR(55),
	@CPF				VARCHAR(11),
	@Status_Id			INT,
	@Data_Nascimento	DATE,

	-- Email
	@Email				VARCHAR(55),
	
	-- Telefone
	@Telefone			VARCHAR(55),
	
	-- Endereco
	@CEP				VARCHAR(8),
	@Numero				VARCHAR(5),
	@Logradouro			VARCHAR(255),
	@Bairro				VARCHAR(255),
	@Cidade				VARCHAR(255),
	@UF					VARCHAR(2),
	@Complemento		VARCHAR(255),

	-- Atributos específicos de Colaborador
	@Funcao             INT,
	@Salario_Inicial    DECIMAL(18,2),
	@Data_Registro		DATE,
	@Num_CTPS           VARCHAR(11),
	@Num_CNH            VARCHAR(11),
	
	-- Atributos de Usuario
	@Login				VARCHAR(255),
	@Hash_Senha			VARCHAR(255)
)
AS 
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			BEGIN TRANSACTION;

			-- Validação do STATUS
			IF NOT EXISTS (
				SELECT 1
				FROM TB_status_pessoa
				WHERE id = @Status_Id
			)	THROW 50001, 'Status de Pessoa inválido', 1;

			-- Validação da FUNÇÃO
			IF NOT EXISTS (
				SELECT 1
				FROM TB_funcoes_colaboradores
				WHERE id = @Funcao
			)	THROW 50001, 'Função do Colaborador inválida', 1;

			-- Validação de CPF único
			IF EXISTS (SELECT 1 FROM TB_pessoas WHERE cpf = @CPF)
			THROW 50002, 'CPF já cadastrado', 1;

			-- validação do Salário/Função
			DECLARE @SalarioFuncao DECIMAL(12, 2)
			SET @SalarioFuncao = (SELECT salario_base FROM TB_funcoes_colaboradores WHERE id = @Funcao)
			IF @Salario_Inicial < @SalarioFuncao
			THROW 50003, 'Salário inicial não pode ser inferior ao salário base da função', 1;
			
			-- Normalização de campos opcionais
			SET @Num_CNH = NULLIF(LTRIM(RTRIM(@Num_CNH)), '')
			
			-- INSERT de Pessoa
			INSERT INTO TB_pessoas 
				(nome, sobrenome, cpf, status_id, data_cadastro, data_nascimento, created_at, updated_at)
			VALUES	
				(@Nome, @Sobrenome, @CPF, @Status_Id, GETDATE(), @Data_Nascimento,GETDATE(), GETDATE())

			-- Captura Id_pessoa
			DECLARE @IdPessoa BIGINT
			SET @IdPessoa = SCOPE_IDENTITY()

			-- INSERT de Email
			INSERT INTO TB_emails_pessoas 
				(pessoa_id, email, principal)
			VALUES
				(@IdPessoa, @Email, 1)		

			-- INSERT de Telefone
			INSERT INTO TB_telefones_pessoas 
				(pessoa_id, telefone, principal)
			VALUES
				(@IdPessoa, @Telefone, 1)

			-- INSERT de Endereco
			INSERT INTO TB_enderecos_pessoas 
				(pessoa_id, cep, numero, logradouro, bairro, cidade, uf, complemento, principal)
			VALUES
				(@IdPessoa, @CEP, @Numero, @Logradouro, @Bairro, @Cidade, @UF, @Complemento, 1)

			-- INSERT de Colaborador
			INSERT INTO TB_colaboradores 
				(pessoa_id, funcao, salario_inicial, salario_atual, data_registro, num_carteira_trabalho, num_cnh)
			VALUES
				(@IdPessoa, @Funcao, @Salario_Inicial, @Salario_Inicial, @Data_Registro, @Num_CTPS, @Num_CNH)
				
			-- INSERET de Usuario
			INSERT INTO TB_usuarios
				(pessoa_id, usuario_role, usuario_login, senha_hash, created_at, updated_at)
			VALUES
				(@IdPessoa, 2, @Login, @Hash_Senha, GETDATE(), GETDATE())			
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO 
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA VISUALIZAÇÃO DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
-- VER PESSOA POR ID
CREATE FUNCTION	FN_Pessoa_BYID (
	@PessoaId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pessoas WHERE idPessoa = @PessoaId );
GO
------------------------------------------------------------------------------------------------------
-- VER PESSOA POR CPF
CREATE FUNCTION	FN_Pessoa_BYCPF (
	@PessoaCPF	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_pessoas WHERE CPF = @PessoaCPF );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VER CLIENTE POR ID
CREATE FUNCTION	FN_Cliente_BYID (
	@ClienteId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_clientes_completos WHERE IdCliente = @ClienteId);
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VER COLABORADOR POR ID
CREATE FUNCTION	FN_Colaboarador_BYID (
	@ColaboradorId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_colaboradores_completos WHERE IdColaborador = @ColaboradorId);
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA UPDATE DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE CLIENTE
CREATE PROCEDURE SP_update_cliente
(

	-- Atributos obrigatórios Pessoa
    @IdPessoa           BIGINT,
    @Nome               VARCHAR(55),
    @Sobrenome          VARCHAR(55),
    @CPF                VARCHAR(11),
    @Status_Id          INT,
    @Data_Nascimento    DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @Deleted_at DATETIME = NULL;
		DECLARE @StatusDescricao VARCHAR(55);

        -- validação de pessoa
        IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
            THROW 50001, 'Pessoa não encontrada', 1;

        -- validação de status
        IF NOT EXISTS (SELECT 1 FROM TB_status_pessoa WHERE id = @Status_Id)
            THROW 50001, 'Status inválido', 1;

		-- Validação de soft exclusão de pessoa
		SELECT @StatusDescricao = descricao
		FROM tb_status_pessoa
		WHERE id = @Status_Id;

		IF @StatusDescricao = 'INATIVO' OR @StatusDescricao = 'BLOQUEADO'
		BEGIN
			SET @Deleted_at = GETDATE();
		END
		
        -- atualiza pessoa
        UPDATE TB_pessoas
        SET nome				= @Nome,
            sobrenome			= @Sobrenome,
            cpf					= @CPF,
            status_id			= @Status_Id,
            data_nascimento		= @Data_Nascimento,
            updated_at			= GETDATE(),
			deleted_at			= @Deleted_at

        WHERE id = @IdPessoa;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO
------------------------------------------------------------------------------------------------------
-- UPDATE DE COLABORADOR
CREATE PROCEDURE SP_update_colaborador
(
	-- Atributos obrigatórios Pessoa
    @IdPessoa           BIGINT,
    @Nome               VARCHAR(55),
    @Sobrenome          VARCHAR(55),
    @CPF                VARCHAR(11),
    @Status_Id          INT,
    @Data_Nascimento    DATE,
	-- Atributos específicos de Colaborador
	@Funcao             INT,
	@Salario_Atual	    DECIMAL(18,2),
	@Num_CTPS           VARCHAR(11),
	@Num_CNH            VARCHAR(11), -- Opcional
	@Data_Registro		DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @Deleted_at DATETIME = NULL;
		DECLARE @StatusDescricao VARCHAR(55);

        -- validação de pessoa
        IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
            THROW 50001, 'Pessoa não encontrada', 1;

        -- validação de status
        IF NOT EXISTS (SELECT 1 FROM TB_status_pessoa WHERE id = @Status_Id)
            THROW 50001, 'Status inválido', 1;

		-- Validação de soft exclusão de pessoa
		SELECT @StatusDescricao = descricao
		FROM tb_status_pessoa
		WHERE id = @Status_Id;

		IF @StatusDescricao = 'INATIVO' OR @StatusDescricao = 'BLOQUEADO'
		BEGIN
			SET @Deleted_at = GETDATE();
		END

		-- validação do Salário/Função
		DECLARE @SalarioFuncao DECIMAL(12, 2)
		SET @SalarioFuncao = (SELECT salario_base FROM TB_funcoes_colaboradores WHERE id = @Funcao)
		IF @Salario_Atual < @SalarioFuncao
		THROW 50003, 'Salário atual não pode ser inferior ao salário base da função', 1;
			
		-- Normalização de campos opcionais
		SET @Num_CNH = NULLIF(LTRIM(RTRIM(@Num_CNH)), '')

        -- atualiza pessoa
        UPDATE TB_pessoas
        SET nome				= @Nome,
            sobrenome			= @Sobrenome,
            cpf					= @CPF,
            status_id			= @Status_Id,
            data_nascimento		= @Data_Nascimento,
            updated_at			= GETDATE(),
			deleted_at			= @Deleted_at

        WHERE id = @IdPessoa;

		-- atualiza colaborador
		UPDATE TB_colaboradores
		SET funcao					= @Funcao,
			salario_atual			= @Salario_Atual,
			num_carteira_trabalho	= @Num_CTPS,
			num_cnh					= @Num_CNH,
			data_registro			= @Data_Registro

		WHERE pessoa_id = @IdPessoa;

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
    END CATCH
END
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA SOFT DELETE DAS ENTIDADES	-----------------
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_inactivate_pessoa
	@IdPessoa BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @StatusInativoId INT
		SELECT @StatusInativoId = id FROM TB_status_pessoa WHERE descricao = 'INATIVO'

		-- validação de pessoa
		IF NOT EXISTS (SELECT 1 FROM TB_pessoas WHERE id = @IdPessoa)
			THROW 50001, 'Pessoa não encontrada', 1;
		
		-- atualização do status para INATIVO
		UPDATE TB_pessoas 
		SET status_id = @StatusInativoId, deleted_at = GETDATE()
		WHERE id = @IdPessoa;
	
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO