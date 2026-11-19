SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaTurnover]
(	
	@dataInicio DATE,
	@dataFim DATE,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	WITH HpSemDuplicados AS
	(
		SELECT *,
			   ROW_NUMBER() OVER (
				   PARTITION BY hp.no, hp.datafimcontrato
				   ORDER BY (SELECT NULL)
			   ) AS rn
		FROM hp (NOLOCK)
		WHERE hp.tipo = 1
		  AND hp.datafimcontrato IS NOT NULL
		  AND hp.datafimcontrato <> '19000101'
		  AND hp.datafimcontrato BETWEEN @dataInicio AND @dataFim
		  AND hp.CODMOTIVOSSAID <> 0
	),
	BaseCalculo AS
	(
		SELECT
			hp.no,
			hp.datafimcontrato,
			hp.descmotivossaid,
			hp.tpcontrato,
			pe.sexo,
			pe.nasc,
			pe.u_interno,

			-- Idade calculada uma única vez
			CASE 
				WHEN pe.nasc IS NULL THEN NULL
				ELSE 
					DATEDIFF(YEAR, pe.nasc, hp.datafimcontrato)
					- CASE 
						WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datafimcontrato), pe.nasc) 
							 > hp.datafimcontrato 
						THEN 1 ELSE 0 
					  END
			END AS Idade
		FROM HpSemDuplicados hp
		INNER JOIN pe (NOLOCK)
			ON pe.no = hp.no
		WHERE hp.rn = 1
		  AND ( (@Internos = 1 AND pe.u_interno = 1) 
		     OR (@Externos = 1 AND pe.u_interno = 0) )
	)

	SELECT
	BaseCalculo.no,
	(select nome from pe where pe.no=BaseCalculo.no) as 'Nome',
		YEAR(datafimcontrato) AS Ano_Saida,

		ISNULL(descmotivossaid, '') AS Motivo_Saida,

		ISNULL(tpcontrato, 'Sem Contrato') AS Tipo_Contrato,

		CASE
			WHEN sexo IS NULL OR sexo = '' THEN 'Não preenchido'
			ELSE sexo
		END AS Sexo,

		CASE 
			WHEN nasc IS NULL THEN 'Data nascimento desconhecida'
			WHEN Idade <= 20 THEN '20 ou Menos'
			WHEN Idade BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN Idade BETWEEN 31 AND 40 THEN '31 a 40'
			WHEN Idade BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN Idade BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END AS Faixa_Etaria,

		COUNT(*) AS Total_Trabalhadores

	FROM BaseCalculo

	GROUP BY
		YEAR(datafimcontrato),
		ISNULL(descmotivossaid, ''),
		ISNULL(tpcontrato, 'Sem Contrato'),
		CASE
			WHEN sexo IS NULL OR sexo = '' THEN 'Não preenchido'
			ELSE sexo
		END,
		CASE 
			WHEN nasc IS NULL THEN 'Data nascimento desconhecida'
			WHEN Idade <= 20 THEN '20 ou Menos'
			WHEN Idade BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN Idade BETWEEN 31 AND 40 THEN '31 a 40'
			WHEN Idade BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN Idade BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END,
		BaseCalculo.no
);
GO
