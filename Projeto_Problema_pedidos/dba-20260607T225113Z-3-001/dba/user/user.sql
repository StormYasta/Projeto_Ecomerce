-- CREATE LOGIN projeto_fatec
-- WITH PASSWORD = '##fatec##';
-- GO

USE dev_projeto_fatec_ecomerce;
CREATE USER usuario_fatec FOR LOGIN projeto_fatec;
GO

ALTER ROLE db_datareader ADD MEMBER usuario_fatec;
ALTER ROLE db_datawriter ADD MEMBER usuario_fatec;
GRANT EXECUTE TO usuario_fatec;
GRANT BACKUP DATABASE TO usuario_fatec;
GO


CREATE PROCEDURE dbo.SP_Create_Master_User
AS
BEGIN

    DECLARE @id BIGINT
	INSERT INTO TB_pessoas (nome, sobrenome, cpf, status_id, data_nascimento) VALUES ('MASTER', 'BOY', '99999999999', 1, '0001-01-01')
	SET @id = SCOPE_IDENTITY()

	INSERT INTO TB_usuarios (pessoa_id, usuario_role, usuario_login, senha_hash) VALUES (@id, 1, 'master', '##fatec##')
END
GO
EXEC dbo.SP_Create_Master_User
GO

-- BACKUP DATABASE [dev_projeto_fatec_ecomerce]
-- TO DISK = 'C:\Backup\bkp.bak'
-- WITH COMPRESSION;

-- RESTORE DATABASE dev_projeto_fatec_ecomerce
-- FROM DISK = 'C:\Backup\bkp.bak';

