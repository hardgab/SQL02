CREATE DATABASE db1609_AlterProducao;
GO

USE db1609_AlterProducao;
GO

CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY, 
	nome_cliente VARCHAR (100),
	data_cadastro DATETIME);

INSERT INTO clientes (cliente_id, nome_cliente, data_cadastro) VALUES
(1,'Caio Ross', '2025-01-01'),
(2,'Gabriel Sousa', '2025-01-01'),
(3,'Jotael Genuino', '2025-01-01'),
(4,'Natalia Sales ', '2025-01-01');

--- PARA EFETUAR UMA ALTERA��O NO BANCO DE DADOS EM PRODU��O DEVEMOS CRIAR UMA NOVA TABELA E MIGRAR OS DADOS PARA ELA POR SEGURAN�A

--- PASSO 1: PRIMEIRO CRIAMOS A TABELA TEMPOR�RIA
CREATE TABLE cliente_temp(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	data_cadastro DATETIME,
	email_cliente VARCHAR (100));

--- PASSO 2: AQUI VAMOS MIGRAR A TABELA ORIGINAL � NOVA TABELA TEMPOR�RIA
INSERT INTO cliente_temp (cliente_id, nome_cliente, data_cadastro) SELECT cliente_id, nome_cliente, data_cadastro FROM clientes; 
--- VOC� PODE USAR O BLOQUEIO EXPLICITO DE TRANSA��O (TRANSACTION)
BEGIN TRANSACTION;
	DROP TABLE clientes; ---- ELIMINA A TABELA ORIGINAL
	EXEC sp_rename 'cliente_temp', 'clientes'; --- RENOMEAR A TABELA TEMPOR�RIA, DESSA FORMA EXCLUIMOS A TABELA ANTERIROR E TORNAMOS A TEMPOR�RIA COM A MESMA NOMENCLATURA
COMMIT TRANSACTION;

SELECT * FROM clientes