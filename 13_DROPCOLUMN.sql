CREATE DATABASE db1609_AddDropColuna;
GO

USE db1609_AddDropColuna;
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

---ADICIONAR UMA COLUNA COM UM VALOR DEFAULT (padrão) OU NULL, SE NECESSÁRIO PARA VEITAR IM´PACTO NOS DADOS EXISTENTES
ALTER TABLE clientes ADD email_cliente VARCHAR (150) NULL;

--- VERIFICAR SE A COLUNA E-MAIL TEM DADOS
SELECT COUNT (*) AS dados_email_cliente FROM clientes WHERE email_cliente IS NOT NULL;

BEGIN TRANSACTION;
	ALTER TABLE clientes DROP COLUMN email_cliente;
COMMIT TRANSACTION;

SELECT * FROM clientes