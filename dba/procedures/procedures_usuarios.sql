USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS PROCEDURES PARA USUARIOS	-----------------
------------------------------------------------------------------------------------------------------
-- INSERT DE USUARIOS
CREATE PROCEDURE SP_insert_usuario (
	@Pessoa_Id			BIGINT,
	@Login 				VARCHAR(255),
	@Hash_Senha			VARCHAR(255),
	@Usuario_Role		INT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de Pessoa
		IF NOT EXISTS (
		SELECT 1
		FROM TB_pessoas
		WHERE id = @Pessoa_Id AND deleted_at IS NULL
		) THROW 50001, 'Pessoa associada ao usuário não existe ou está inativa.', 1;

		-- Validação de Role
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_roles_usuarios
		WHERE	id = @Usuario_Role AND ativo = 1
		) THROW 50001, 'Role de usuário inválida ou inativa.', 1;

		-- Validação de Login Único
		IF EXISTS (SELECT 1 FROM TB_usuarios WHERE usuario_login = @Login)
		THROW 50002, 'Login em uso', 1;

		-- Validação de Role/Pessoa
		IF EXISTS (	SELECT 1
					FROM TB_Pessoas AS Pessoa
					INNER JOIN TB_usuarios AS Usuario ON Pessoa.id = Usuario.pessoa_id

					WHERE Usuario.usuario_role = @Usuario_Role AND Pessoa.id = @Pessoa_Id
		) THROW 50002, 'A pessoa já possui um usuário com essa role.', 1;
		
		-- Insert do usuário
		INSERT INTO TB_usuarios 
			(pessoa_id, usuario_role, usuario_login, senha_hash)
		VALUES			
			(@Pessoa_Id, @Usuario_Role, @Login, @Hash_Senha)
			
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
-- VISUALIZAÇÃO DE USUÁRIOS
CREATE FUNCTION	FN_Usuario_BYID (
	@UsuarioId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM TB_usuarios WHERE id = @UsuarioId);
GO
-- VISUALIZAÇÃO DE USUÁRIOS POR PESSOA
CREATE FUNCTION	FN_Usuario_BYPESSOA (
	@PessoaId	BIGINT
)
RETURNS TABLE
AS
RETURN ( SELECT * FROM VW_usuarios WHERE PessoaId = @PessoaId );
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- UPDATE DE USUARIOS
CREATE PROCEDURE SP_update_usuario (
	@Id_Usuario			BIGINT,
	@Login 				VARCHAR(255),
	@Role				INT
)
AS
BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Captura do Id de Pessoa
		DECLARE @Pessoa_Id BIGINT
		SELECT @Pessoa_Id = pessoa_id FROM TB_usuarios WHERE id = @Id_Usuario

		-- Validação de Pessoa
		IF NOT EXISTS (SELECT 1 FROM TB_usuarios WHERE	id = @Id_Usuario) 
		THROW 50001, 'Login de usuario não encontrado.', 1;

		-- Validação de Role
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_roles_usuarios
		WHERE	id = @Role AND ativo = 1
		) THROW 50001, 'Role de usuário inválida ou inativa.', 1;

		-- Validação de Login Único
		IF EXISTS (SELECT 1 FROM TB_usuarios WHERE usuario_login = @Login AND id <> @Id_Usuario)
		THROW 50002, 'Login em uso', 1;

		-- Validação de Role/Pessoa
		IF EXISTS (	SELECT 1 
					
					FROM TB_Pessoas AS Pessoa
					INNER JOIN TB_usuarios AS Usuario ON Pessoa.id = Usuario.pessoa_id
					
					WHERE Usuario.usuario_role = @Role AND Pessoa.id = @Pessoa_Id

		) THROW 50002, 'A pessoa já possui um usuário com essa role.', 1;
		
		-- Update do usuário
		UPDATE	TB_usuarios
		SET		usuario_login	= @Login,
				usuario_role	= @Role,
				updated_at		= GETDATE()

		WHERE id = @Id_Usuario
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
-- SOFT DELETE DE USUARIOS
CREATE PROCEDURE SP_delete_usuario (
	@Id_Usuario	BIGINT
)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		-- Validação de Usuario
		IF NOT EXISTS (
		SELECT 1
		FROM	TB_usuarios
		WHERE	id = @Id_Usuario AND deleted_at IS NULL
		) THROW 50001, 'Usuario não encontrado ou já deletado.', 1;
		
		-- Soft delete do usuário
		UPDATE TB_usuarios
		SET deleted_at = GETDATE(),
			ativo = 0
		WHERE id = @Id_Usuario
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
GO