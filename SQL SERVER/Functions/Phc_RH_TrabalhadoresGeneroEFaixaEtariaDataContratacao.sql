SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaDataContratacao]
(	
	@dataInicio DATE,
	@dataFim DATE,
	@Internos BIT,
	@Externos BIT
)
RETURNS TABLE 
AS
RETURN 
(
	WITH HpContratacoes AS
	(
		SELECT *
		FROM hp (NOLOCK)
		WHERE hp.tipo = 1
		  AND ISNULL(hp.renova,0) = 0   -- Apenas contratações
		  AND hp.datainicontrato BETWEEN @dataInicio AND @dataFim
	),

	BaseCalculo AS
	(
		SELECT
			hp.no,
			hp.datainicontrato,
			hp.contrato,
			pe.sexo,
			pe.nasc,
			pe.u_interno,

			-- Idade correta na data da contratação
			CASE 
				WHEN pe.nasc IS NULL THEN NULL
				ELSE 
					DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
					- CASE 
						WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
							 > hp.datainicontrato 
						THEN 1 ELSE 0 
					  END
			END AS Idade

		FROM HpContratacoes hp
		INNER JOIN pe (NOLOCK) 
			ON pe.no = hp.no

		WHERE 
			(@Internos = 1 AND pe.u_interno = 1) 
			OR 
			(@Externos = 1 AND pe.u_interno = 0)
	)

	SELECT

		YEAR(datainicontrato) AS Ano_Contratacao,

		ISNULL(tpcontrato.tpcontrato, 'Sem Contrato') AS Tipo_Contrato,

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

		COUNT(DISTINCT no) AS Total_Trabalhadores

	FROM BaseCalculo bc

	LEFT JOIN tpcontrato (NOLOCK) 
		ON bc.contrato = tpcontrato.codcontrato

	GROUP BY
		YEAR(datainicontrato),
		ISNULL(tpcontrato.tpcontrato, 'Sem Contrato'),
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
		END
);
GO
