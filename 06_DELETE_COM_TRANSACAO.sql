
--- controlar quando fazemos alguma transação
USE db1609_empresa_muito_legal
GO

CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY, 
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10, 2),
	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id));

	INSERT INTO clientes (cliente_id, nome_cliente, email_cliente) VALUES
(10,'Caio Ross', 'kio199@gmail.com'),
(20,'Gabriel Sousa', 'gabriel@gmail.com'),
(30,'Jotael Genuino', 'jotael@gmail.com'),
(40,'Natalia Sales ', 'natalia@gmail.com');

INSERT INTO pedidos (pedido_id, cliente_id, data_pedido, valor_total) VALUES
(1, 1, '2025-01-01', 150.00),
(2, 1, '2025-02-03', 200.00),
(3, 2, '2025-01-05', 300.00),
(4, 3, '2025-02-06', 450.00);

SELECT * FROM clientes;
SELECT * FROM pedidos;

BEGIN TRY
	BEGIN TRANSACTION; --- INICIANDO A TRANSAÇÃO PARA GARANTIR AS EXCLUSÕES
		DELETE FROM pedidos WHERE cliente_id = 1;
		DELETE FROM clientes WHERE cliente_id = 10;
	COMMIT TRANSACTION; 
	PRINT 'Exclusões foram realizada com sucesso'
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN 
		ROLLBACK TRANSACTION--- CASO OCORRA UM ERRO O ROOLBACK GARANTE A NÃO QUEBRA
	END
	PRINT 'ERRO DURANTE A EXCLUSÃO: ' + ERROR_MESSAGE();
END CATCH

SELECT * FROM clientes;
SELECT * FROM pedidos;