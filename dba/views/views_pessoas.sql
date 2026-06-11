USE dev_projeto_fatec_ecomerce;
GO
------------------------------------------------------------------------------------------------------
----------------- CRIAÇÃO DAS VIEWS DE PESSOAS  -----------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO GENÉRICA DE PESSOAS DO SISTEMA COM INFORMAÇÕES PRINCIPAIS
CREATE VIEW VW_pessoas AS
SELECT
        pessoa.id               AS IdPessoa,
        pessoa.nome             AS Nome,
        pessoa.cpf              AS CPF,
        pessoa.data_nascimento  AS DataNascimento,
    
        endereco.cep            AS CEP,
        endereco.logradouro     AS Logradouro,
        endereco.numero         AS Numero,
        endereco.uf             AS UF,
    
        telefone.telefone       AS Telefone,
        email.email             AS Email,

        status.id               AS IdStatus,
        status.descricao        AS status

FROM            tb_pessoas          AS pessoa
    LEFT JOIN   tb_emails_pessoas   AS email        ON pessoa.id = email.pessoa_id      AND email.principal     = 1
    LEFT JOIN tb_enderecos_pessoas  AS endereco     ON pessoa.id = endereco.pessoa_id   AND endereco.principal  = 1
    LEFT JOIN tb_telefones_pessoas  AS telefone     ON pessoa.id = telefone.pessoa_id   AND telefone.principal  = 1
    INNER JOIN tb_status_pessoa     AS status       ON pessoa.status_id = status.id;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO COMPLETA DOS CLIENTES
CREATE VIEW VW_clientes_completos AS
	SELECT  
			Pessoa.id					AS IdCliente,
			Pessoa.nome					AS Nome,
			Pessoa.sobrenome			AS Sobrenome,
			Pessoa.cpf					AS CPF,
			Pessoa.data_nascimento		AS DataNascimento,
			Pessoa.data_cadastro		AS DataCadastro,
			
            Status.descricao			AS StatusDescricao,
		    
            Email.email					AS Email,
			Telefone.telefone           AS Telefone,
			
            Endereco.cep                AS CEP,
			Endereco.numero             AS Numero,
			Endereco.logradouro         AS Logradouro,
			Endereco.bairro             AS Bairro,
			Endereco.cidade             AS Cidade,
			Endereco.uf                 AS UF,
			Endereco.complemento        AS Complemento
	
	FROM	           dbo.tb_status_pessoa			AS Status
			INNER JOIN dbo.tb_pessoas				AS Pessoa	    ON Pessoa.status_id = Status.id
			INNER JOIN dbo.tb_clientes				AS Cliente	    ON Pessoa.id = Cliente.pessoa_id 
			INNER JOIN dbo.tb_emails_pessoas		AS Email	    ON Pessoa.id = Email.pessoa_id      AND Email.principal     = 1
			INNER JOIN dbo.tb_telefones_pessoas		AS Telefone	    ON Pessoa.id = Telefone.pessoa_id   AND Telefone.principal  = 1
			INNER JOIN dbo.tb_enderecos_pessoas		AS Endereco	    ON Pessoa.id = Endereco.pessoa_id   AND Endereco.principal  = 1
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- VISUALIZAÇÃO COMPLETA DOS COLABORADORES
CREATE VIEW VW_colaboradores_completos AS
    SELECT  
            Pessoa.id					AS IdColaborador,
            Pessoa.nome					AS Nome,
            Pessoa.sobrenome			AS Sobrenome,
            Pessoa.cpf					AS CPF,
            Pessoa.data_nascimento		AS DataNascimento,
            Pessoa.data_cadastro		AS DataCadastro,
            Status.descricao			AS StatusDescricao,
            
            Email.email					AS Email,
            Telefone.telefone           AS Telefone,
            
            Endereco.cep                AS CEP,
            Endereco.numero             AS Numero,
            Endereco.logradouro         AS Logradouro,
            Endereco.bairro             AS Bairro,
            Endereco.cidade             AS Cidade,
            Endereco.uf                 AS UF,
            Endereco.complemento        AS Complemento,

            Funcao.descricao                    AS FuncaoDescricao,
            Colaborador.salario_inicial         AS SalarioInicial,
            Colaborador.salario_atual           AS SalarioAtual,
            Colaborador.data_registro           AS DataRegistro,
            Colaborador.num_carteira_trabalho   AS NumCarteiraTrabalho,
            Colaborador.num_cnh                 AS NumCNH
    
    FROM	           dbo.tb_status_pessoa			AS Status
            INNER JOIN dbo.tb_pessoas				AS Pessoa	    ON Pessoa.status_id = Status.id
            INNER JOIN dbo.tb_colaboradores		    AS Colaborador	ON Pessoa.id = Colaborador.pessoa_id
            INNER JOIN dbo.tb_funcoes_colaboradores AS Funcao	    ON Colaborador.funcao = Funcao.id
			INNER JOIN dbo.tb_emails_pessoas		AS Email	    ON Pessoa.id = Email.pessoa_id      AND Email.principal     = 1
			INNER JOIN dbo.tb_telefones_pessoas		AS Telefone	    ON Pessoa.id = Telefone.pessoa_id   AND Telefone.principal  = 1
			INNER JOIN dbo.tb_enderecos_pessoas		AS Endereco	    ON Pessoa.id = Endereco.pessoa_id   AND Endereco.principal  = 1
GO