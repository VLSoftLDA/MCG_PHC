SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaVoltaramAposLicencaParental]
(	
	 @DataInicial DATE,
	 @DataFinal   DATE,
	 @Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		CASE
			WHEN pe.sexo IS NULL OR pe.sexo = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END AS Sexo,

		CASE 
			WHEN pe.nasc IS NULL THEN 'Data nascimento desconhecida'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END <= 20 THEN '20 ou Menos'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 21 AND 30 THEN '21 a 30'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 31 AND 40 THEN '31 a 40'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 41 AND 50 THEN '41 a 50'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 51 AND 60 THEN '51 a 60'

			ELSE 'Mais de 60'
		END AS Faixa_Etaria,

		COUNT(*) AS Total_Trabalhadores

	FROM pe (NOLOCK)

	WHERE EXISTS (

		SELECT 1
		FROM pr pr2

		CROSS APPLY (
			-- Recibo imediatamente anterior
			SELECT TOP 1 pr1.prstamp, pr1.data
			FROM pr pr1
			WHERE pr1.no = pr2.no
			  AND pr1.data < pr2.data
			ORDER BY pr1.data DESC
		) prev

		WHERE pr2.no = pe.no

		  -- Recibo de regresso no período
		  AND pr2.data BETWEEN @DataInicial AND @DataFinal

		  -- Recibo atual NÃO tem licença
		  AND NOT EXISTS (
				SELECT 1
				FROM prf f2
				WHERE f2.prstamp = pr2.prstamp
				  AND f2.thf IN (6,7)
		  )

		  -- Recibo anterior TEM licença
		  AND EXISTS (
				SELECT 1
				FROM prf f1
				WHERE f1.prstamp = prev.prstamp
				  AND f1.thf IN (6,7)
		  )
	)

		AND (
			   (@Internos = 1 AND pe.u_interno = 1)
			OR (@Externos = 1 AND pe.u_interno = 0)
		)

	GROUP BY
		CASE
			WHEN pe.sexo IS NULL OR pe.sexo = '' THEN 'Não preenchido'
			ELSE pe.sexo
		END,

		CASE 
			WHEN pe.nasc IS NULL THEN 'Data nascimento desconhecida'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END <= 20 THEN '20 ou Menos'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 21 AND 30 THEN '21 a 30'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 31 AND 40 THEN '31 a 40'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 41 AND 50 THEN '41 a 50'

			WHEN 
				DATEDIFF(YEAR, pe.nasc, @DataFinal)
				- CASE 
					WHEN DATEADD(YEAR, DATEDIFF(YEAR, pe.nasc, @DataFinal), pe.nasc) 
					     > @DataFinal 
					THEN 1 ELSE 0 
				  END BETWEEN 51 AND 60 THEN '51 a 60'

			ELSE 'Mais de 60'
		END
);
GO
