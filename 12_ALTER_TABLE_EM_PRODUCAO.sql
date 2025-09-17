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

--- PARA EFETUAR UMA ALTERAÇÃO NO BANCO DE DADOS EM PRODUÇÃO DEVEMOS CRIAR UMA NOVA TABELA E MIGRAR OS DADOS PARA ELA POR SEGURANÇA

--- PASSO 1: PRIMEIRO CRIAMOS A TABELA TEMPORÁRIA
CREATE TABLE cliente_temp(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	data_cadastro DATETIME,
	email_cliente VARCHAR (100));

--- PASSO 2: AQUI VAMOS MIGRAR A TABELA ORIGINAL Á NOVA TABELA TEMPORÁRIA
INSERT INTO cliente_temp (cliente_id, nome_cliente, data_cadastro) SELECT cliente_id, nome_cliente, data_cadastro FROM clientes; 
--- VOCÊ PODE USAR O BLOQUEIO EXPLICITO DE TRANSAÇÃO (TRANSACTION)
BEGIN TRANSACTION;
	DROP TABLE clientes; ---- ELIMINA A TABELA ORIGINAL
	EXEC sp_rename 'cliente_temp', 'clientes'; --- RENOMEAR A TABELA TEMPORÁRIA, DESSA FORMA EXCLUIMOS A TABELA ANTERIROR E TORNAMOS A TEMPORÁRIA COM A MESMA NOMENCLATURA
COMMIT TRANSACTION;

SELECT * FROM clientes