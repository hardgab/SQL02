
--- incluindo coluna que faltou na tabela de vendas
ALTER TABLE vendas
ADD valor_total DECIMAL (10, 2);

USE db1609_vendas
GO


--- REALIZAR MULTIPAS INSER��ES CONTROLADAS COM VARI�VEIS PARA ARMAZENAR DADOS
--- INICIAR TRANSA��O
BEGIN TRANSACTION;
----DECLARAR VARIAVEL
DECLARE @cliente_id INT = 1; -- CLIENTE PARA O PEDIDO
DECLARE @produto_id INT = 2; ----- produto comprado
DECLARE @quantidade INT = 3; ---- quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL (10, 2); --- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); --- DATA ATUAL DA VENDA
DECLARE @status_transacao VARCHAR (50);

--- calcular o valor total de venda
SELECT @valor_total = p.pre�o_produto * @quantidade
FROM produtos p 
WHERE p.produto_id = @produto_id;

--- VALIDA��O PARA GARANTIR QUE A QUANTIDADE SEJA VALIDA
IF @quantidade <= 0 
BEGIN
	SET @status_transacao = 'Falha Quantidade inv�lida';
	ROLLBACK TRANSACTION; ---- reverte a transa��o se a quantidade for inv�lida
	PRINT @status_transacao;
	RETURN;
END 

--- inserindo vendo com 'metodo' declare
INSERT INTO vendas ( cliente_id, produto_id, quantidade, valor_total, data_venda) VALUES
(@cliente_id, @produto_id,@quantidade,@valor_total,@data_venda);

---- VALIDANDO SUCESSO DA INSER��O
IF @@ERROR <> 0 
BEGIN 
	SET @status_transacao = 'Falha  erro na inser��o da venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN;

END
---- PROCESSO DE CONFIRMA��O DAS TRANSA��ES
SET @status_transacao = 'Sucesso: Vendas Inseridas Com Sucesso';
COMMIT TRANSACTION; --- CONFIRMA��O DA TRANSA��O

--- verificando status da transa��o
PRINT @status_transacao 
---verificando dados inseridos
SELECT * FROM vendas;

-------------- CASO FALHA ---------------
BEGIN TRANSACTION

DECLARE @cliente_id INT = 1; -- CLIENTE PARA O PEDIDO
DECLARE @produto_id INT = 2; ----- produto comprado
DECLARE @quantidade INT = 3; ---- quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL (10, 2); --- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); --- DATA ATUAL DA VENDA
DECLARE @status_transacao VARCHAR (50);

	SET @quantidade = -1;
	SET @cliente_id = 1;
	SET @produto_id = 1;
	SET @data_venda = GETDATE();

SELECT @valor_total = p.pre�o_produto * @quantidade
FROM produtos p 
WHERE p.produto_id = @produto_id;

IF @quantidade <= 0 
BEGIN
	SET @status_transacao = 'Falha Quantidade inv�lida';
	ROLLBACK TRANSACTION; ---- reverte a transa��o se a quantidade for inv�lida
	PRINT @status_transacao;
	RETURN;
END 

--- inserindo vendo com 'metodo' declare
INSERT INTO vendas ( cliente_id, produto_id, quantidade, valor_total, data_venda) VALUES
(@cliente_id, @produto_id,@quantidade,@valor_total,@data_venda);

COMMIT TRANSACTION;