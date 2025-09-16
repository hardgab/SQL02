CREATE DATABASE db1609_empresa_muito_legal;

USE db1609_vendas
USE db1609_empresa_muito_legal
GO

CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	email_cliente VARCHAR (100),
	data_inicio DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN, --- DATA E HORA DO INICIO DA VALIDADE DO REGISTRO
	data_fim DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN, --- DATA E HORA DO INICIO DA VALIDADE DO REGISTRO 
	PERIOD FOR SYSTEM_TIME (data_inicio, data_fim))--- DEFINIR PERÍODO DE TEMPO EM QUELA O REGISTRO É VALIDO
WITH (SYSTEM_VERSIONING = on (HISTORY_TABLE = dbo.cliente_historico)); --- ATIVANDO O VERSIONAMENTO E CRIANDO UMA TABELA DE HISTORICO


--- CRIANDO TABELA DE HISTORICO QUE VAI ARMAZENAR AS VERSÕES ANTERIORES DOS DADOS, 
--POR PADRÃO O SLQ SERVER CRIA ESSA TABELA AUTOMATICAMENTE QUANDO O VERSIONAMENTO É HABILITADO. 
-- MAS PODEMOS CRIAR QUANDO DESEJAMOS
CREATE TABLE  cliente_historico (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	email_cliente VARCHAR (100),
	data_inicio DATETIME2,
	data_fim DATETIME2);

INSERT INTO clientes (cliente_id, nome_cliente, email_cliente) VALUES
(1,'Caio Ross', 'kio199@gmail.com'),
(2,'Gabriel Sousa', 'gabriel@gmail.com'),
(3,'Jotael Genuino', 'jotael@gmail.com'),
(4,'Natalia Sales ', 'natalia@gmail.com');

SELECT * FROM clientes;

UPDATE clientes SET nome_cliente = 'Caio Rossi' , email_cliente = 'sem.email@gmail.com'
WHERE cliente_id = 1;

SELECT * FROM cliente_historico;
--- INSERINDO DADOS EM UMA TABELA TEMPORÁRIA, UTEIS PARA ARMAZENAMENTO DE DADOS TEMPORARIOS QUE NÃO PRECISAM PERSISTIR NO BANCO DE DADOS
CREATE TABLE #clientes_temporarios (
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100),
	email_cliente VARCHAR (100)
);

INSERT INTO #clientes_temporarios (cliente_id, nome_cliente, email_cliente) VALUES 
(5,'Stephen Hawking', 'hipervoid@gmail.com'),
(6,'Albert Einstein', 'linguinha@gmail.com');

SELECT * FROM #clientes_temporarios;
DROP TABLE #clientes_temporarios