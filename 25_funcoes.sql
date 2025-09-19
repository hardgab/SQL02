

--- GARANTIR QUE A FUNÇÃO EXISTENTE EXISTA SE NÃO EXISTIR CRIAMOS VIA EXEC (EVITA CONFLITOS)
IF OBJECT_ID ('dbo.fn_Media', 'FN') IS NULL
BEGIN
	EXEC ('CREATE FUNCTION dbo.fn_Media (@n1 DECIMAL (5,2), @n2 DECIMAL (5,2)) RETURNS DECIMAL (5,2)
	AS
	BEGIN
		RETURN (@n1 + @n2) / 2
	END;');
END;
GO

--- DADOS DE EXEMPLO - TABELA TEMPORÁRIA PARA NÃO AFETAR NOSSO ESQUEMA
IF OBJECT_ID ('tempdb..#Alunos') IS NOT NULL DROP TABLE #Alunos;

CREATE TABLE #Alunos (
	id INT IDENTITY PRIMARY KEY,
	nome VARCHAR (100),
	nota1 DECIMAL (5,2),
	nota2 DECIMAL (5,2));

--- INSERT  DE DADOS NA TABELA TEMPORÁRIA M
INSERT INTO #Alunos (nome,nota1,nota2) VALUES
('Caio', 8.5, 7.0),
('Gabriel', 6.0, 5.5),
('Jotael', 9.0, 9.5),
('Natalia', 4.0, 5.0);

--- CONSULTA USANDO A FUNÇÃO JÁ EXISTENTE
SELECT 
	nome, 
	nota1, 
	nota2, 
	dbo.fn_Media (nota1, nota2) AS Media_Atual
FROM #Alunos
ORDER BY nome;
GO

IF OBJECT_ID ('dbo.fn_situacao2', 'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_situacao2;
GO

CREATE FUNCTION dbo.fn_situacao2 (
	@n1 DECIMAL (5,2),
	@n2 DECIMAL (5,2))
	RETURNS VARCHAR (20)
	AS
	BEGIN
		DECLARE @media DECIMAL (5,2) SET @media =  dbo.fn_Media (@n1,@n2)
		RETURN CASE 
			WHEN @media >= 6 THEN 'Aprovado'
			ELSE 'Reprovado'
		END;
	END;
	GO

--- CONSULTA FINAL USANDO AS DDUAS CONSULTAS
SELECT 
	a.nome,
	a.nota1,
	a.nota2,
	dbo.fn_media (a.nota1, a.nota2) AS Media,
	dbo.fn_situacao2 (a.nota1, a.nota2) AS Situacao
FROM #Alunos a
ORDER BY Media DESC, nome;
