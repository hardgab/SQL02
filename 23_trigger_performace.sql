
IF NOT EXISTS (SELECT 1 FROM SYS.databases WHERE name = 'db1609_TriggersPerformance')
	CREATE DATABASE db1609_TriggersPerformance;
GO

USE db1609_TriggersPerformance;
GO

IF OBJECT_ID ('vendas', 'U') IS NOT NULL DROP TABLE vendas;
GO

IF OBJECT_ID ('auditoria_vendas', 'U') IS NOT NULL DROP TABLE auditoria_vendas;
GO

IF OBJECT_ID ('trg_AuditoriaInsercao', 'U') IS NOT NULL DROP TABLE trg_AuditoriaInsercao;
GO

IF OBJECT_ID ('trg_AuditoriaAtualizacao', 'U') IS NOT NULL DROP TABLE trg_AuditoriaAtualizacao;
GO

IF OBJECT_ID ('trg_AuditoriaExclusao', 'U') IS NOT NULL DROP TABLE trg_AuditoriaExclusao;
GO

CREATE TABLE vendas(
	id_venda INT PRIMARY KEY,
	valor_venda DECIMAL (10, 2),
	data_venda DATE,
	status NVARCHAR (20) DEFAULT 'Ativo');
GO

CREATE TABLE auditoria_vendas(
	id_auditoria INT IDENTITY (1,1) PRIMARY KEY,
	id_venda INT,
	operacao NVARCHAR(10),
	data_operacao DATETIME,
	usuario NVARCHAR (50));
GO

CREATE TRIGGER trg_AuditoriaInsercao
ON vendas AFTER INSERT 
AS
BEGIN
	INSERT INTO auditoria_vendas (id_venda, operacao, data_operacao, usuario)
	SELECT id_venda, 'INSERT', GETDATE (), SYSTEM_USER FROM inserted;
	PRINT 'OPERAÇÃO DA INSERÇÃO REALIZADA COM SUCESSO';
END;
GO

CREATE TRIGGER trg_AuditoriaAtualizacao
ON vendas AFTER UPDATE 
AS
BEGIN
	INSERT INTO auditoria_vendas (id_venda, operacao, data_operacao, usuario)
	SELECT id_venda, 'UPDATE', GETDATE (), SYSTEM_USER FROM inserted WHERE EXISTS( SELECT 1 FROM deleted WHERE deleted.id_venda = inserted.id_venda AND (deleted.valor_venda <> inserted.valor_venda OR deleted.status <> inserted.status));  --- O WHERE EXISTS SERVE PARA REGISTRAR APENAS QUANDO HOUVER MUDANÇAS REAIS NOS DADOSAND 
	PRINT 'OPERAÇÃO DA ATUALIZAÇÃO REALIZADA COM SUCESSO';
END;
GO

CREATE TRIGGER trg_AuditoriaExclusao
ON vendas AFTER DELETE 
AS
BEGIN
	INSERT INTO auditoria_vendas (id_venda, operacao, data_operacao, usuario)
	SELECT id_venda, 'DELETE', GETDATE (), SYSTEM_USER FROM deleted;
	PRINT 'OPERAÇÃO DA EXCLUSÃO REALIZADA COM SUCESSO';
END;
GO

INSERT INTO vendas (id_venda, valor_venda, data_venda) VALUES 
	(1, 150.00, '2025-01-01');

UPDATE vendas SET valor_venda = 200 WHERE id_venda = 1;

DELETE FROM vendas WHERE id_venda = 1;

SELECT * FROM auditoria_vendas;
SELECT * FROM vendas;