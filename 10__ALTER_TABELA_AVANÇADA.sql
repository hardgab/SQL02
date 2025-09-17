
CREATE DATABASE db1609_AlterAvancado02;
GO

USE db1609_AlterAvancado02;
GO

CREATE TABLE clientes (
	cliente_id INT, 
	nome_cliente VARCHAR (100),
	data_cadastro DATETIME
	CONSTRAINT PK_clientes_cliente_id PRIMARY KEY (cliente_id));

INSERT INTO clientes (cliente_id, nome_cliente, data_cadastro) VALUES
(1,'Caio Ross', '2025-01-01'),
(2,'Gabriel Sousa', '2025-01-01'),
(3,'Jotael Genuino', '2025-01-01'),
(4,'Natalia Sales ', '2025-01-01');

ALTER TABLE clientes --- Passo 1: Remover a chave primaria existente
DROP CONSTRAINT PK__clientes__cliente_id; 

ALTER TABLE clientes --- Passo 2: Atribuir uma nova chave primaria
ADD CONSTRAINT PK__clientes__nome_cliente PRIMARY KEY (nome_cliente);


CREATE NONCLUSTERED INDEX IX_clientes_data_cadastro ON clientes (data_cadastro); ---ADICIONANDO UM INDICE PARA OTIMIZAR A CONSULTA POR DATA


---- alterar tipo de dados
ALTER TABLE clientes
ALTER COLUMN nome_cliente TEXT;


--- adicionar e excluir
ALTER TABLE clientes
ADD email_cliente VARCHAR (150);

ALTER TABLE clientes
DROP COLUMN email_clientes;

---verificar se o indice existe na tabela
SELECT * FROM sys.indexes WHERE name = 'IX_clientes_data_cadastro';


ALTER TABLE clientes DROP CONSTRAINT PK_clientes_cliente_id;