CREATE DATABASE db1609_UpdateMerge;
GO

USE db1609_UpdateMerge;
GO

CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY, 
	nome_cliente VARCHAR (100),
	total_pedidos DECIMAL (10, 2) DEFAULT 0.00,
	status_cliente VARCHAR (50) DEFAULT 'Ativo');

CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	valor_pedido DECIMAL (10, 2),
	data_pedido DATETIME,
	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id));

INSERT INTO clientes (cliente_id, nome_cliente) VALUES
(1,'Caio Ross'),
(2,'Gabriel Sousa'),
(3,'Jotael Genuino'),
(4,'Natalia Sales ');

INSERT INTO pedidos (pedido_id, cliente_id, valor_pedido, data_pedido) VALUES
(1, 1, 100.00, '2025-01-10'),
(2, 1, 150.00, '2025-02-10'),
(3, 2, 200.00, '2025-02-05'),
(4, 3, 50.00, '2025-01-10'),
(5, 3, 75.00, '2025-01-12');

---- A IDEIA AQUI É COMPARAR OS DADOS DESSA TABELA COM A TABELA DO PEDIDOS, ATUALIZANDO OS PEDIDOS EXISTENTES, INSERIDNDO NOVOS PEDIDOS E EXCLUINDO PEDIDOS QUE NÃO SÃO MAIS NECESSÁRIOS
CREATE TABLE novos_pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	valor_pedido DECIMAL (10, 2),
	data_pedido DATETIME);

INSERT INTO novos_pedidos (pedido_id, cliente_id, valor_pedido, data_pedido) VALUES
(2, 1, 160.00, '2025-01-01'), ---- PEDIDO EXISTENTE
(5, 2, 300.00, '2025-01-02'), --- PEDIDO NOVO
(7, 3, 80.00, '2025-01-03'); --- PEDIDO NOVO

---- USAMOS O MERGE PARA SINCRONIZAR A TABELA DE PEDIDOS COM A TABELA DE NOVOS PEDIDOS
MERGE INTO pedidos AS target USING novos_pedidos AS source ON target.pedido_id = source.pedido_id

---- QUANDO HOUVER A CORRESPONDENCIA DE PEDIDOS FAZER O UPDATE
WHEN MATCHED  THEN 
	UPDATE SET target.valor_pedido = source.valor_pedido, target.data_pedido = source.data_pedido

---- QUANDO NÃO HOUVER A CORRESPONDENCIA DE PEDIDOS FAZER O INSERT
WHEN NOT MATCHED BY TARGET THEN
	INSERT (pedido_id, cliente_id, valor_pedido, data_pedido) VALUES (source..pedido_id, source..cliente_id, source..valor_pedido, source..data_pedido)

---- QUANDO HOUVER CORRESPONDENCIA EM PEDIDOS MAIS NÃO EM NOVOS PEDIDOS, FAZER DELETE
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT * FROM pedidos