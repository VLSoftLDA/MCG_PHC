SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaComContrato]
(	
	@dataFimAno  DATE,
	@Internos    BIT,
	@Externos    BIT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		CASE
			WHEN ISNULL(pe.sexo,'') = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END AS sexo,

		CASE 
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) <= 20 THEN '20 ou Menos'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 31 AND 40 THEN '31 a 40'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END AS faixa_etaria,

		COUNT(DISTINCT pe.no) AS total_trabalhadores

	FROM pe

	OUTER APPLY (
		SELECT TOP 1
			hp.datainicontrato,
			hp.datafimcontrato,
			hp.contrato,
			hp.renova
		FROM hp
		WHERE hp.tipo = 1
			AND hp.no = pe.no
			AND hp.renova IN (0,1)
			-- contrato ativo na data final do ano
			AND hp.datainicontrato <= @dataFimAno
			AND (
					hp.datafimcontrato = '19000101'
					OR hp.datafimcontrato >= @dataFimAno
				)
		ORDER BY 
			hp.datainicontrato DESC,
			hp.data DESC,
			hp.usrhora DESC
	) hp_ativo

	WHERE
		hp_ativo.datainicontrato IS NOT NULL
		AND pe.no IN (
			SELECT DISTINCT pr.no 
			FROM pr
			WHERE YEAR(pr.data) = YEAR(@dataFimAno)
			AND MONTH(pr.data) = MONTH(@dataFimAno)
		)
		AND (
				(@Internos = 1 AND pe.u_interno = 1) 
				OR 
				(@Externos = 1 AND pe.u_interno = 0)
			)

	GROUP BY
		CASE
			WHEN ISNULL(pe.sexo,'') = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END,
		CASE 
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) <= 20 THEN '20 ou Menos'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 21 AND 30 THEN '21 a 30'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 31 AND 40 THEN '31 a 40'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 41 AND 50 THEN '41 a 50'
			WHEN DATEDIFF(YEAR, pe.nasc, @dataFimAno) BETWEEN 51 AND 60 THEN '51 a 60'
			ELSE 'Mais de 60'
		END
);
GO
