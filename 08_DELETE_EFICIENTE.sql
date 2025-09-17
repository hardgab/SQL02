CREATE DATABASE db1609_eficiente02;
GO

USE db1609_eficiente02;
GO

CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY, 
	nome_cliente VARCHAR (100),
	data_cadastro DATETIME);

CREATE TABLE pedidos ( 
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	data_pedido DATETIME,
	valor_total DECIMAL (10,02));
	 
INSERT INTO clientes (cliente_id, nome_cliente, data_cadastro) SELECT TOP 1000000
/*
Gerar o valor sequencial de 1 à INF por cada linha, o OVER exige ordenar. Isso é um truque para dizer que não quero em ordem pré-definida.
*/
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), 
	'Cliente ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
	DATEADD(DAY, -(ROW_NUMBER() OVER (ORDER BY (SELECT NULL))% 3650), GETDATE())
FROM master.dbo.spt_values a, master.dbo.spt_values b;

INSERT INTO pedidos (pedido_id, cliente_id, data_pedido, valor_total) SELECT TOP 1000000
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), 
	(ABS(CHECKSUM(NEWID()))% 1000000) + 1, --- Atribuimos um cliente aleatório
	DATEADD(DAY, -(ROW_NUMBER() OVER (ORDER BY (SELECT NULL))% 3650), GETDATE()),
	CAST(RAND() * 1000 AS DECIMAL (10, 2))
FROM master.dbo.spt_values a, master.dbo.spt_values b;

SELECT * FROM clientes;
SELECT TOP 10 * FROM pedidos;

BEGIN TRY
	BEGIN TRANSACTION;
		--- EXCLUSÃO EFICIENTE
		DECLARE @BatchSize INT = 1000;
		DECLARE @RowCount INT;
			SET @RowCount = 1; --- inicio da variável de controle dos registros excluídos
			WHILE @RowCount > 0 --- LOOP para excluir os dados em lotes
			BEGIN 
				DELETE TOP (@BatchSize) --- excluindo os dados em lotes de 1000, o BatchSize anterior especificou a quantidade de dados que deveriam ser excluidos no processo
				FROM clientes WHERE data_cadastro < DATEADD(YEAR, -5, GETDATE());
				SET @RowCount = @@ROWCOUNT; --- Inserindo a contagem de resgistros na interação atual
				PRINT 'EXCLUÍDOS ' + CAST(@RowCount AS VARCHAR) + 'registro de clientes.';
				WAITFOR DELAY '00:00:01'; --- PAUSA DE 1 SEGUNDO ENTRE CADA LOTE
			END
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END
	PRINT ' W=Erro durante a exclusão ' + ERROR_MESSAGE();
END CATCH
SELECT COUNT (*) FROM clientes;
SELECT COUNT (*) FROM pedidos;