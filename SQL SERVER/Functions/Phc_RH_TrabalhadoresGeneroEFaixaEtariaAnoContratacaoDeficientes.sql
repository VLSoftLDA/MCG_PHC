SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaAnoContratacaoDeficientes]
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
	SELECT
		YEAR(hp.datainicontrato) AS Ano_Contratacao,
		ISNULL(tpcontrato.tpcontrato, 'Sem Contrato') AS Tipo_Contrato,
		iif(deficiente=1,'Com Incapacidade e/ou Deficiência','') as 'Deficiente',
		CASE
			WHEN pe.sexo IS NULL OR pe.sexo = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END AS Sexo,
		CASE 
			WHEN pe.nasc IS NULL THEN 'Data nascimento desconhecida'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END <= 20 THEN '20 ou Menos'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 31 AND 40 THEN '31 a 40'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END AS Faixa_Etaria,
		COUNT(*) AS Total_Trabalhadores

	FROM hp (NOLOCK)
	INNER JOIN pe (NOLOCK) ON pe.no = hp.no

	LEFT JOIN tpcontrato (NOLOCK) ON hp.contrato = tpcontrato.codcontrato
	WHERE 
		hp.tipo = 1
		AND hp.datainicontrato BETWEEN @dataInicio AND @dataFim
		and pe.deficiente=1
		and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )

	GROUP BY
		YEAR(hp.datainicontrato),
		iif(deficiente=1,'Com Incapacidade e/ou Deficiência',''),
		ISNULL(tpcontrato.tpcontrato, 'Sem Contrato'),
		CASE
			WHEN pe.sexo IS NULL OR pe.sexo = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END,
		CASE 
			WHEN pe.nasc IS NULL THEN 'Data nascimento desconhecida'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END <= 20 THEN '20 ou Menos'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 31 AND 40 THEN '31 a 40'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN 
				DATEDIFF(YEAR, pe.nasc, hp.datainicontrato) 
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, hp.datainicontrato), pe.nasc) 
					     > hp.datainicontrato 
					THEN 1 ELSE 0 
				  END BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END
);

--select top 10 * from tpcontrato
GO
