CREATE DATABASE db1609_DropOtimizado;
GO

USE db1609_DropOtimizado;
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

CREATE TABLE #cliente_temp(
	cliente_id INT, 
	nome_cliente VARCHAR (100));

INSERT INTO (cliente_id, nome_cliente) VALUES
	(4, 'Nicola Tesla'),
	(5, 'Heidy Lamar');

TRUNCATE TABLE clientes; -- EXCLUI TODO OS DADOS DA TABELA (DEIXANDO ELA VAZIA) DE CLIENTES E NÃO REGISTRA A EXCLUSÃO NO LOG. NÃO PODE SER REVERTIDO

DROP TABLE #cliente_temp; --- AQUI EXCLUIMOS A TABELA TEMPORÁRIA, NÃO APENAS LIMPANDO SEUS DADOS
