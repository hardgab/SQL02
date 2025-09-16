
USE db1609_empresa_muito_legal
GO

--- ESTE SCRIPT DEMONTRA COMO REALIZAR INSERÇÕES EM LOTES UTILIZANDO TRANSAÇÕES, OU SEJA, GRANDES VOLUMES DE DADOS
--- COM DIVISÃO DE INSERÇÃO EM PEQUENOS LOTES ('BATCHES' OU 'CHUNKS') AJUDA A EVITAR QUEBRAS E MELHORA O DESEMPENHO DO BANCO

--- 01 CRIAR TABELA 
CREATE TABLE vendas (
	venda_id INT IDENTITY (1,1) PRIMARY KEY,
	cliente_id INT,
	poduto_id INT,
	quantidade INT,
	valor_total DECIMAL (10, 2),
	data_venda DATETIME);

--- 02 VARIAVEIS PARA CONTROLE DOS LOTES
DECLARE @batch_size INT = 1000; --- TAMANHO DO LOTE
DECLARE @total_registros INT = 10000; --- TOTAL DE REGISTROS DO LOTE QUE DESEJAMOS
DECLARE @contador INT = 0; --- CONTADOR DE INSERÇÕES REALIZADAS

BEGIN TRY 
--- INICIAR A TRANSAÇÃO PARA GARANTIR QUE AS INSERÇÕES DE CADA LOTE SEJAM UNICAS (ATOMICAS)
	WHILE @contador < @total_registros
		BEGIN 
			--- INICIO DA TRANSAÇÃO DENTRO DO BEGIN
			BEGIN TRANSACTION
				--- INSERINDO LOTE DE REGISTRO NA TABELA DE VENDAS
				INSERT INTO vendas(cliente_id, poduto_id, quantidade, valor_total, data_venda) SELECT 
				ABS(CHECKSUM(NEWID())) % 1000 + 1,--- gerando um cliente_id aleatório entre 1 e 1000
				ABS(CHECKSUM(NEWID())) % 100 + 1,--- gerando um produto_id aleatório entre 1 e 1000
				ABS(CHECKSUM(NEWID())) % 10 + 1,--- gerando um quantidade aleatório entre 1 e 1000
				(ABS(CHECKSUM(NEWID())) % 1000 + 1) * 10,--- gerando um valor_total aleatório entre 1 e 1000
				GETDATE() --- DATA DE VENDA SER A DATA E HORA ATUAL
					FROM master.dbo.spt_values t1
					CROSS JOIN master.dbo.spt_values t2
					WHERE t1.type = 'P' AND t2.type = 'P'
					ORDER BY NEWID()
						OFFSET @contador ROWS FETCH NEXT @batch_size ROWS ONLY; --- inserção de apenas um lote
						SET @contador = @contador + @batch_size; --- ATUALIZAR O CONTADOR DE RESGITROS INSERIDOS
							COMMIT TRANSACTION
							PRINT 'Lote: '+ CAST(@contador / @batch_size AS VARCHAR) + ' inseridos com sucesso!'
		END
END TRY
BEGIN CATCH --- SÓ FUNCIONA APÓS O END TRY, NÃO FUNCIONA SEM O END TRY
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT 'Erro: ' + ERROR_MESSAGE();
END CATCH

SELECT COUNT (*) AS total_vendas FROM vendas;
