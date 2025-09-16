-- cria��o do DATA BASE
CREATE DATABASE db1609_vendas;
GO --- Comando de execu��o da cria��o

--- Sinaliza��o de uso da Base criada anteriormente
USE db1609_vendas
GO

---- Cria��o das tabelas de utiliza��o nos exerc�cios
---- tabela de clientes
CREATE TABLE clientes (
	cliente_id INT PRIMARY KEY IDENTITY (1,1), --- tipo de dados chave primaria, com lan�amento pelo identificador de 1, por 1. Ou seja cada novo lan�amento tem um c�digo �nico distinto partindo do n�mero 1
	nome_cliente VARCHAR (100), --- tipo de dados texto at� 100 caracteres
	email_cliente VARCHAR (100)); --- tipo de dados texto at� 100 caracteres

---- tabela de produtos
CREATE TABLE produtos ( 
	produto_id INT PRIMARY KEY IDENTITY (1,1), --- tipo de dados chave primaria
	nome_produto VARCHAR (100), --- tipo de dados texto at� 100 caracteres
	pre�o_produto DECIMAL (10, 2)); --- tipo de dados numero com decimal de at� 2

----- tabela de vendas
CREATE TABLE vendas (
venda_id INT PRIMARY KEY IDENTITY (1,1), --- tipo de dados chave primaria
	cliente_id INT, --- tipo de dados numero inteiro
	produto_id INT, --- tipo de dados numero inteiro
	quantidade INT, --- tipo de dados numero inteiro
	data_venda DATE,  --- tipo de dados data

	FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id), -- Especificando que a minha coluna de cliente_id, deve ser uma referencia da coluna de primary key da tabela de clientes
	FOREIGN KEY (produto_id) REFERENCES produtos (produto_id)); -- Especificando que a minha coluna de produto_id, deve ser uma referencia da coluna de primary key da tabela de produtos

--- inser��o de dados
INSERT INTO clientes (nome_cliente, email_cliente) VALUES ---- INSERIR NA TABELA CLIENTES, NAS COLUNAS ESPECIFICAS OS VALORES
('Jotael Genuino', 'jota@gmail.com'),
('Gabriel Sousa', 'gabriel@hotmail.com'),
('Natalia Sales', 'nath@outlook.com')

INSERT INTO produtos (nome_produto, pre�o_produto) VALUES --- INSERIR NA TABELA PRODUTOS, NAS COLUNAS ESPECIFICAS OS VALORES
('Laptop', 3600.00),
('Smartphone', 800.00),
('Cadeira Gamer', 1300.00)

INSERT INTO vendas (cliente_id,produto_id,quantidade,data_venda) VALUES --- INSERIR NA TABELA VENDAS, NAS COLUNAS ESPECIFICAS OS VALORES
(1,1,2,'2025-09-12'),
(2,2,1,'2025-06-10'),
(1,3,1,'2025-08-10'),
(3,3,3,'2025-01-01'),
(2,1,1,'2025-09-07');

--- atualizando a inser��o avan�ada com INSERT...SELECT, insert avan�ado para calcular o total de vendas para clientes agrupando resultados e inserindo em uma nova tabela
CREATE TABLE relatorio_vendas_clientes (
	cliente_id INT,
	nome_cliente VARCHAR (100),
	produto_id INT,
	nome_produto VARCHAR (100),
	total_gasto DECIMAL (10, 2));

INSERT INTO relatorio_vendas_clientes (cliente_id, nome_cliente, produto_id,nome_produto,total_gasto)SELECT
	c.cliente_id, -- IDENTIDICANDO AS COLUNAS PELA CHAVE DA TABELA "C." 
	c.nome_cliente, -- IDENTIDICANDO AS COLUNAS PELA CHAVE DA TABELA "C." 
	p.produto_id, -- IDENTIDICANDO AS COLUNAS PELA CHAVE DA TABELA "P." 
	p.nome_produto, -- IDENTIDICANDO AS COLUNAS PELA CHAVE DA TABELA "P." 
	SUM(v.quantidade * p.pre�o_produto) AS total_gasto ---- MULTIPLICANDO A QUANTIDADE PELO PRE�O DO PRODUTO E NOMEANDO A COLUNA COMO TOTAL GASTO

FROM vendas v --- NOMEANDO A TABELA DE VENDAS COMO V, COMO EST� NO FROM ELA � A REFERENCIA PARA O JOIN
	JOIN clientes c ON v.cliente_id = c.cliente_id ---NOMEANDO A TABELA DE CLIENTES COMO C E CONCETANDO A RELA��O ENTRE AS TABELAS DE VENDAS E CLIENTES
	JOIN produtos p ON v.produto_id = p.produto_id ---NOMEANDO A TABELA DE PRODUTOS COMO P E CONCETANDO A RELA��O ENTRE AS TABELAS DE VENDAS E PRODUTOS
GROUP BY
c.cliente_id, c.nome_cliente, p.produto_id, p.nome_produto

--- INSERINDO APENAS OS CLIENTES ACIMA DE 3000
INSERT INTO relatorio_vendas_clientes
(cliente_id,nome_cliente, produto_id, nome_produto, total_gasto) SELECT
	c.cliente_id,
	c.nome_cliente,
	p.produto_id,
	p.nome_produto,
	SUM(v.quantidade * p.pre�o_produto) AS total_gasto
FROM vendas v
	JOIN clientes c ON v.cliente_id = c.cliente_id
	JOIN produtos p ON v.produto_id = p.produto_id
GROUP BY
	c.cliente_id, c.nome_cliente, p.produto_id, p.nome_produto
HAVING SUM(v.quantidade * p.pre�o_produto) > 3000;

select * from relatorio_vendas_clientes


