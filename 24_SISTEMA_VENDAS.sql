IF NOT EXISTS (SELECT 1 FROM SYS.databases WHERE name = 'db1609_SistemaVendas')
	CREATE DATABASE db1609_SistemaVendas;
GO

USE db1609_SistemaVendas;
GO


IF OBJECT_ID ('trg_AuditoriaInsercao', 'TR') IS NOT NULL DROP TRIGGER trg_AuditoriaInsercao;
GO
IF OBJECT_ID ('trg_AuditoriaAtualizacao', 'TR') IS NOT NULL DROP TRIGGER trg_AuditoriaAtualizacao;
GO
IF OBJECT_ID ('trg_AuditoriaExclusao', 'TR') IS NOT NULL DROP TRIGGER trg_AuditoriaExclusao;

GO
IF OBJECT_ID ('vendas', 'U') IS NOT NULL DROP TABLE vendas;
GO
IF OBJECT_ID ('produtos', 'U') IS NOT NULL DROP TABLE produtos;
GO
IF OBJECT_ID ('Auditoria_vendas', 'U') IS NOT NULL DROP TABLE auditoria_vendas;
GO
IF OBJECT_ID ('clientes', 'U') IS NOT NULL DROP TABLE clientes;
GO
CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR (100) NOT NULL,
	email_cliente VARCHAR(100),
	data_cadastro DATETIME DEFAULT GETDATE());
GO 

CREATE TABLE produtos(
	produto_id INT PRIMARY KEY,
	nome_produto VARCHAR (50) NOT NULL,
	preco DECIMAL (10, 2) NOT NULL);
GO 

CREATE TABLE vendas(
	venda_id INT IDENTITY (1,1) PRIMARY KEY,
	cliente_id INT NOT NULL,
	produto_id INT NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL (10,2),
	data_venda DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id) ON DELETE CASCADE,
	FOREIGN KEY (produto_id) REFERENCES produtos (produto_id) ON DELETE CASCADE);
GO

CREATE TABLE Auditoria_vendas (
	id_auditoria INT IDENTITY (1,1) PRIMARY KEY,
	venda_id INT,
	produto_id INT,
	quantidade INT,
	valor_total DECIMAL (10, 2),
	data_venda DATETIME,
	operacao NVARCHAR(10),
	data_operacao DATETIME DEFAULT GETDATE(),
	usuario NVARCHAR (50) DEFAULT SYSTEM_USER);
GO

INSERT INTO clientes (cliente_id, nome_cliente, email_cliente, data_cadastro) VALUES
(1, 'GABRIEL', 'GABRIEL@GMAIL.COM', '2025-01-10'),
(2, 'JOAO', 'JOAO@GMAIL.COM', '2025-03-10'),
(3, 'JORGE', 'JORGE@GMAIL.COM', '2025-05-10'),
(4, 'AMANDA', 'AMANDA@GMAIL.COM', '2025-05-10');
GO

INSERT INTO produtos (produto_id, nome_produto, preco) VALUES
(1, 'Óculos', 500.00),
(2, 'Boné', 200.00),
(3, 'Blusa', 150.00),
(4, 'Calça', 250.00);
GO 

INSERT INTO vendas (cliente_id, produto_id, quantidade, data_venda) VALUES
(1, 3, 2,'2025-02-11'),
(2, 2, 1,'2025-05-11'),
(3, 1, 2,'2025-07-11');
GO


CREATE TRIGGER trg_AuditoriaInsercao
	ON vendas AFTER INSERT
	AS
	BEGIN
	INSERT INTO Auditoria_vendas (venda_id, produto_id, quantidade, valor_total, data_venda, operacao, data_operacao, usuario) SELECT venda_id, produto_id, quantidade, valor_total, data_venda, 'INSERT', GETDATE(), SYSTEM_USER FROM inserted;
	PRINT 'OPERAÇÃO DE INSERÇÃO CONCLUIDA NA TABELA DE AUDITORIA_VENDAS';
	END;
GO

CREATE TRIGGER trg_AuditoriaAtualizacao
	ON vendas AFTER UPDATE
	AS
	BEGIN
	INSERT INTO Auditoria_vendas (venda_id, produto_id, quantidade, valor_total, data_venda, operacao, data_operacao, usuario) SELECT venda_id, produto_id, quantidade, valor_total, data_venda, 'UPDATE', GETDATE(), SYSTEM_USER FROM inserted 
	WHERE EXISTS (SELECT 1 FROM deleted WHERE deleted.venda_id = inserted.venda_id AND (deleted.valor_total <> inserted.valor_total));
	PRINT 'OPERAÇÃO DE INSERÇÃO CONCLUIDA NA TABELA DE AUDITORIA_VENDAS';
	END;
GO

CREATE TRIGGER trg_AuditoriaExclusao
	ON vendas AFTER DELETE
	AS
	BEGIN
	INSERT INTO Auditoria_vendas (venda_id, produto_id, quantidade, valor_total, data_venda, operacao, data_operacao, usuario) SELECT venda_id, produto_id, quantidade, valor_total, data_venda, 'DELETE', GETDATE(), SYSTEM_USER FROM deleted;
	PRINT 'OPERAÇÃO DE INSERÇÃO CONCLUIDA NA TABELA DE AUDITORIA_VENDAS';
	END;
GO



------ ETAPA DA IMPUTE DOS DADOS PARA TRIGGER
INSERT INTO vendas (cliente_id, produto_id, quantidade, valor_total, data_venda) VALUES
(4, 3, 3, 400.00,GETDATE());

UPDATE vendas SET valor_total = 450 WHERE cliente_id = 4;

DELETE vendas WHERE cliente_id = 4 


------ CONSULTA DA ETAPA DE IMPUTE DOS DADOS PARA TRIGGER
SELECT * FROM Auditoria_vendas


--- VALOR TOTAL DE VENDAS POR CLIENTE
SELECT c.nome_cliente AS Cliente, 
	SUM(v.quantidade) AS Quantidade, 
	p.nome_produto,
	SUM(p.preco * v.quantidade) AS TotalGasto
FROM vendas v
JOIN produtos p ON v.produto_id = p.produto_id
JOIN clientes c ON v.cliente_id = c.cliente_id
GROUP BY C.nome_cliente, p.nome_produto
ORDER BY TotalGasto DESC;

--- QUAIS OS PRODUTOS COM MIOR QUANTIDADE MAIS VENDIDA
SELECT TOP 3 p.nome_produto AS produto, SUM(v.quantidade) AS QUANTIDADEVENDIDA
FROM Produtos p
JOIN vendas v ON p.produto_id = v.produto_id 
GROUP BY p.nome_produto
ORDER BY  QUANTIDADEVENDIDA DESC;
