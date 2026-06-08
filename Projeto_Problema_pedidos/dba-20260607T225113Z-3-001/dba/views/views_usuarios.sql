USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO GERAL DE USUÁRIOS POR PESSOA
CREATE VIEW VW_usuarios AS

	SELECT	Pessoa.id				AS PessoaId,
			Pessoa.nome				AS Nome,
			Pessoa.sobrenome		AS Sobrenome,
			Pessoa.data_cadastro	AS DataCadastro,
		
			Status.descricao		AS StatusPessoa,
			
			Role.descricao			AS RoleDescricao,
			Usuario.usuario_login	AS UsuarioLogin,
			Usuario.created_at		AS CreatedAt,
			Usuario.updated_at		AS UpdatedAt,
			Usuario.deleted_at		AS DeletedAt,
			Usuario.ativo			AS Ativo,
			Usuario.id				AS UsuarioId

	FROM				dbo.TB_usuarios			AS Usuario
			INNER JOIN	dbo.TB_roles_usuarios	AS Role		ON Usuario.usuario_role = Role.id
			INNER JOIN	dbo.TB_pessoas			AS Pessoa	ON Usuario.pessoa_id = Pessoa.id
			INNER JOIN	dbo.TB_status_pessoa	AS Status	ON Pessoa.status_id = Status.id
	GO
	SELECT * FROM VW_usuarios;
GO