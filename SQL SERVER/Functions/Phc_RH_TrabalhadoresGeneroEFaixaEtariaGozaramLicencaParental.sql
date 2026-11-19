SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaGozaramLicencaParental]
(	
	@DataInicial date
    ,@DataFinal date,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	
SELECT
    CASE
        WHEN sexo = '' THEN 'Não preechido'
        ELSE sexo
	END AS sexo,
    CASE 
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) <= 20 THEN '20 ou Menos'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 21 AND 30 THEN '21 a 30'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 31 AND 40 THEN '31 a 40'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 41 AND 50 THEN '41 a 50'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 51 AND 60 THEN '51 a 60'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) > 60 THEN 'Mais de 60'
    END AS faixa_etaria,
    COUNT(*) AS total_trabalhadores
FROM
    pe
WHERE
	pe.no in (select distinct pr.no from prf
					left join pr on prf.prstamp=pr.prstamp 
					where thf in (7,6) and pr.data between @DataInicial and @DataFinal
					) --registos de licenças parentais nos recibos de vencimento
	and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )
GROUP BY
    CASE
        WHEN sexo = '' THEN 'Não preechido'
        ELSE sexo
    END, 
    CASE 
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) <= 20 THEN '20 ou Menos'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 21 AND 30 THEN '21 a 30'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 31 AND 40 THEN '31 a 40'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 41 AND 50 THEN '41 a 50'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) BETWEEN 51 AND 60 THEN '51 a 60'
        WHEN DATEDIFF(YEAR, nasc, @DataFinal) > 60 THEN 'Mais de 60'
    END
)
GO
