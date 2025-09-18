CREATE DATABASE db1609_TransacoesComplexas;
GO

USE db1609_TransacoesComplexas;
GO

CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY, 
	nome_cliente VARCHAR (100),
	saldo DECIMAL (10, 2) DEFAULT 0.00);

CREATE TABLE pedidos (
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	valor DECIMAL (10, 2),
	data_pedido DATETIME,
	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id));

INSERT INTO clientes (cliente_id, nome_cliente, saldo) VALUES
(1,'Mozart Frans Herald', 1000.00),
(2,'Bethovem da Silva', 2000.00);

INSERT INTO pedidos (pedido_id, cliente_id, valor, data_pedido) VALUES
(1, 1, 300.00, '2025-03-10'),
(2, 2, 150.00, '2025-03-11');

--- INICIANDO A TRANSAÇÃO
BEGIN TRANSACTION
	---ATUALIZANDO O SALDO DO CLIENTE APÓS O PEDIDO
	UPDATE clientes
	SET saldo = saldo - 300
	WHERE cliente_id = 1;
	SAVE TRANSACTION SaldoAtualizado
		--- INSERINDO O NOVO PEDIDO E SIMULAR UM ERRO FORÇANDO A FALHA PARA TESTAR O ROOLBACK
		BEGIN TRY
			INSERT INTO pedidos (pedido_id, cliente_id, valor, data_pedido) VALUES (3, 1, 500, '2025-03-12'); -- inserindo um novo cliente
			UPDATE clientes SET saldo = saldo - 500 WHERE cliente_id = 1; ---- Forçando o erro com saldo do cliente
COMMIT TRANSACTION
		END TRY
BEGIN CATCH
	PRINT 'Erro detectado: ' + ERROR_MESSAGE();
	ROLLBACK TRANSACTION SaldoAtualizado;  --- REVERTE TODA A TRANSAÇÃO CASO DÊ ERRO 
	PRINT 'Transação revertida parcialmente. O saldo do cliente não foi alterado, mas o pedido foi adicionado'
END CATCH

SELECT * FROM clientes;
SELECT * FROM pedidos;

