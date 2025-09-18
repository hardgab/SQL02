CREATE DATABASE db1609_AnalisePlanoExecucao;
GO

USE db1609_AnalisePlanoExecucao;
GO

CREATE TABLE clientes (id INT PRIMARY KEY, nome VARCHAR (100), cidade VARCHAR (100), endereco VARCHAR (100), uf VARCHAR (10));
	INSERT clientes ( id, nome, cidade, endereco, uf) VALUES (1, 'Caio', 'São Paulo', 'Rua dos instrutores', 'SP'), (2, 'jotael', 'Lisboa', 'Alameda dos Bancos', 'PT'), (3, 'Gabriel', 'Brasília', 'Quadra da Asa Sul', 'DF'), (4, 'Natalia', 'Londres', 'Avenida dos números', 'UK');

SELECT nome, endereco FROM clientes WHERE cidade = 'São Paulo'

---USANDO ATALHO "CTRL + L" para abrir o plano de execução do SMSS

SET STATISTICS PROFILE ON;
SELECT nome, endereco FROM clientes WHERE cidade = 'São Paulo';
SET STATISTICS PROFILE OFF;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT nome, endereco FROM clientes WHERE cidade = 'São Paulo';
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
