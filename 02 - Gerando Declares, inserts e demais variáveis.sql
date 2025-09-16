
--- incluindo coluna que faltou na tabela de vendas
ALTER TABLE vendas
ADD valor_total DECIMAL (10, 2);

USE db1609_vendas
GO


--- REALIZAR MULTIPAS INSERÇÕES CONTROLADAS COM VARIÁVEIS PARA ARMAZENAR DADOS
--- INICIAR TRANSAÇÃO
BEGIN TRANSACTION;
----DECLARAR VARIAVEL
DECLARE @cliente_id INT = 1; -- CLIENTE PARA O PEDIDO
DECLARE @produto_id INT = 2; ----- produto comprado
DECLARE @quantidade INT = 3; ---- quantidade comprada (3 unidades)
DECLARE @valor_total DECIMAL (10, 2); --- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE(); --- DATA ATUAL DA VENDA
DECLARE @status_transacao VARCHAR (50);

--- calcular o valor total de venda
SELECT @valor_total = p.preço_produto * @quantidade
FROM produtos p 
WHERE p.produto_id = @produto_id;

--- VALIDAÇÃO PARA GARANTIR QUE A QUANTIDADE SEJA VALIDA
IF @quantidade <= 0 
BEGIN
	SET @status_transacao = 'Falha Quantidade inválida';
	ROLLBACK TRANSACTION; ---- reverte a transação se a quantidade for inválida
	PRINT @status_transacao;
	RETURN;
END 

--- inserindo vendo com 'metodo' declare
INSERT INTO vendas ( cliente_id, produto_id, quantidade, valor_total, data_venda) VALUES
(@cliente_id, @produto_id,@quantidade,@valor_total,@data_venda);

---- VALIDANDO SUCESSO DA INSERÇÃO
IF @@ERROR <> 0 
BEGIN 
	SET @status_transacao = 'Falha  erro na inserção da venda';
	ROLLBACK TRANSACTION;
	PRINT @status_transacao;
	RETURN;

END
---- PROCESSO DE CONFIRMAÇÃO DAS TRANSAÇÕES
SET @status_transacao = 'Sucesso: Vendas Inseridas Com Sucesso';
COMMIT TRANSACTION; --- CONFIRMAÇÃO DA TRANSAÇÃO

--- verificando status da transação
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

SELECT @valor_total = p.preço_produto * @quantidade
FROM produtos p 
WHERE p.produto_id = @produto_id;

IF @quantidade <= 0 
BEGIN
	SET @status_transacao = 'Falha Quantidade inválida';
	ROLLBACK TRANSACTION; ---- reverte a transação se a quantidade for inválida
	PRINT @status_transacao;
	RETURN;
END 

--- inserindo vendo com 'metodo' declare
INSERT INTO vendas ( cliente_id, produto_id, quantidade, valor_total, data_venda) VALUES
(@cliente_id, @produto_id,@quantidade,@valor_total,@data_venda);

COMMIT TRANSACTION;