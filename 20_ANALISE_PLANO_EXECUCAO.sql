CREATE DATABASE db1609_AnalisePlanoExecucao;
GO

USE db1609_AnalisePlanoExecucao;
GO

CREATE TABLE clientes (id INT PRIMARY KEY, nome VARCHAR (100), cidade VARCHAR (100), endereco VARCHAR (100), uf VARCHAR (10));
	INSERT clientes ( id, nome, cidade, endereco, uf) VALUES (1, 'Caio', 'S�o Paulo', 'Rua dos instrutores', 'SP'), (2, 'jotael', 'Lisboa', 'Alameda dos Bancos', 'PT'), (3, 'Gabriel', 'Bras�lia', 'Quadra da Asa Sul', 'DF'), (4, 'Natalia', 'Londres', 'Avenida dos n�meros', 'UK');

SELECT nome, endereco FROM clientes WHERE cidade = 'S�o Paulo'

---USANDO ATALHO "CTRL + L" para abrir o plano de execu��o do SMSS

SET STATISTICS PROFILE ON;
SELECT nome, endereco FROM clientes WHERE cidade = 'S�o Paulo';
SET STATISTICS PROFILE OFF;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT nome, endereco FROM clientes WHERE cidade = 'S�o Paulo';
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
