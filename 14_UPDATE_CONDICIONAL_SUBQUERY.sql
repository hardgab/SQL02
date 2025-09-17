CREATE DATABASE db1609_UpdateSubquery;
GO

USE db1609_UpdateSubquery;
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

INSERT INTO pedidos (pedido_id, cliente_id, valor_pedido, data_pedido) VALUES
(1, 1, 100.00, '2025-01-10'),
(2, 1, 150.00, '2025-02-10'),
(3, 2, 200.00, '2025-02-05'),
(4, 3, 50.00, '2025-01-10'),
(5, 3, 75.00, '2025-01-12');


INSERT INTO clientes (cliente_id, nome_cliente) VALUES
(1,'Caio Ross'),
(2,'Gabriel Sousa'),
(3,'Jotael Genuino'),
(4,'Natalia Sales ');

---- CONDIÇÃO GARANTIR PARA ATUALIZAR APENAS CLIENTES COM PEDIDOS
UPDATE clientes SET total_pedidos = ( SELECT SUM(valor_pedido) FROM pedidos WHERE pedidos.cliente_id = clientes.cliente_id) WHERE cliente_id IN (SELECT cliente_id FROM pedidos)

SELECT * FROM clientes;

-------------- NEW UPDATE --------------
--   _______      ___      .______   .______       __   _______  __      
--  /  _____|    /   \     |   _  \  |   _  \     |  | |   ____||  |     
-- |  |  __     /  ^  \    |  |_)  | |  |_)  |    |  | |  |__   |  |     
-- |  | |_ |   /  /_\  \   |   _  <  |      /     |  | |   __|  |  |     
-- |  |__| |  /  _____  \  |  |_)  | |  |\  \----.|  | |  |____ |  `----.
--  \______| /__/     \__\ |______/  | _| `._____||__| |_______||_______|

--- EXEMPLO DE UPDATE COM CONDIÇÃO AVANÇADA
UPDATE clientes SET status_cliente = 'Inativo' WHERE total_pedidos < 100.00;
SELECT * FROM clientes;

UPDATE pedidos SET  valor_pedido = valor_pedido * 2 WHERE cliente_id = 3 AND data_pedido < '2025-12-12';
SELECT * FROM pedidos;
