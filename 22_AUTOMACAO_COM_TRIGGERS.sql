
IF NOT EXISTS (SELECT 1 FROM SYS.databases WHERE name = 'db1609_automacaotriggers')
CREATE DATABASE db1609_automacaotriggers;
GO
USE db1609_automacaotriggers;
GO
--- IDEPENDECIA, OU SEJA RODAR VARIAS VEZES SEM QUEBRAR
IF OBJECT_ID ('trg_AuditoriaInsercao', 'TR') IS NOT NULL
	DROP TRIGGER trg_auditoriaInsercao;
GO

IF OBJECT_ID ('trg_AuditoriaExclusao', 'TR') IS NOT NULL
	DROP TRIGGER trg_AuditoriaExclusao;
GO

IF OBJECT_ID ('trg_AuditoriaAtualizacao', 'TR') IS NOT NULL
	DROP TRIGGER trg_AuditoriaAtualizacao;
GO

IF OBJECT_ID ('auditoria_vendas', 'U') IS NOT NULL
	DROP TABLE auditoria_vendas;
GO

IF OBJECT_ID ('vendas', 'U') IS NOT NULL
	DROP TABLE vendas;
GO

CREATE TABLE auditoria_vendas(
	id_auditoria INT IDENTITY (1,1) PRIMARY KEY,
	id_vendas INT,
	valor_venda DECIMAL (10, 2),
	data_venda DATE,
	operacao NVARCHAR (50),
	data_operacao DATETIME,
	usuario NVARCHAR (50)); --- N VARCHAR PERMITE ALOCAR NUMEROS DENTRO DO CAMPO


--- CRIANDO TABELA DE VENDAS COMPLEMENTAR
CREATE TABLE vendas (
	id_vendas INT PRIMARY KEY,
	valor_venda DECIMAL (10, 2),
	data_venda DATE);
GO


--- CRIAÇÃO DA TRIGGER PARA AUDITORIA APÓS INSERÇÃO DA TABELA VENDAS
CREATE TRIGGER trg_AuditoriaInsercao 
	ON vendas
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO auditoria_vendas ( id_vendas, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_vendas, valor_venda, data_venda, 'INSERT', GETDATE(), SYSTEM_USER
		FROM inserted; --- "INSERTED" CONTÉM OS DADOS DA LINHA
		PRINT 'Dados inseridos na tabela de auditória após a inserção na tabela de vendas';
	END;
GO

	--- CRIAÇÃO DA TRIGGER PARA AUDITORIA APÓS EXCLUSÃO DA TABELA VENDAS
CREATE TRIGGER trg_AuditoriaExclusao
	ON vendas
	AFTER DELETE
	AS
	BEGIN;
	INSERT INTO auditoria_vendas ( id_vendas, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_vendas, valor_venda, data_venda, 'DELETE', GETDATE(), SYSTEM_USER
		FROM deleted;
		PRINT 'Dados inseridos na tabela de auditória após a exclusao na tabela de vendas';
	END;
GO

		--- CRIAÇÃO DA TRIGGER PARA AUDITORIA APÓS ATUALIZAÇÃO DA TABELA VENDAS
CREATE TRIGGER trg_AuditoriaAtualizacao
	ON vendas
	AFTER UPDATE
	AS
	BEGIN;
	INSERT INTO auditoria_vendas ( id_vendas, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_vendas, valor_venda, data_venda, 'UPDATE', GETDATE(), SYSTEM_USER
		FROM inserted;
		PRINT 'Dados inseridos na tabela de auditória após a atualização na tabela de vendas';
	END;
GO

--- INSERINDO DADOS NA TABELA PARA TESTA O PRIMEIRO TRIGGER
INSERT INTO vendas (id_vendas, valor_venda, data_venda) VALUES
(1, 150.00, '2025-01-01');

--- ATUALIZANDO DADOS NA TABELA PARA TESTA O ÚLTIMO TRIGGER
UPDATE vendas SET valor_venda = 200.00 WHERE id_vendas = 1;

--- DELETANDO DADOS NA TABELA PARA TESTA O PENÚLTIMO TRIGGER
DELETE FROM vendas WHERE id_vendas = 1;

--- VENDO A TABELA DE AUDITORIA
SELECT * FROM auditoria_vendas;
