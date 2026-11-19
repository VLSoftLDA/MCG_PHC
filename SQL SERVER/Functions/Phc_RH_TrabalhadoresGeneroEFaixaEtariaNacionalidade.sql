SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Nº total trabalhadores MI por nacionalidade em 31/12/2024
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaNacionalidade]
(	
	@dataFimAno as Date,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
	ISNULL(NULLIF(nacnat, ''), '') as 'Nacionalidade',
    CASE
        WHEN sexo = '' THEN 'Não preechido'
        ELSE sexo
	END AS sexo,
    CASE 
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) <= 20 THEN '20 ou Menos'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 21 AND 30 THEN '21 a 30'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 31 AND 40 THEN '31 a 40'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 41 AND 50 THEN '41 a 50'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 51 AND 60 THEN '51 a 60'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) > 60 THEN 'Mais de 60'
    END AS faixa_etaria,
    COUNT(*) AS 'Recibos de Vencimento nesse Mês'
FROM
    pe
WHERE
    pe.no in (select distinct pr.no from pr
					where year(data)= year(@dataFimAno) and month(data)=month(@dataFimAno)
					) --registos recibos de vencimento nesse mês
	and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )
GROUP BY
    CASE
        WHEN sexo = '' THEN 'Não preechido'
        ELSE sexo
    END, 
    CASE 
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) <= 20 THEN '20 ou Menos'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 21 AND 30 THEN '21 a 30'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 31 AND 40 THEN '31 a 40'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 41 AND 50 THEN '41 a 50'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) BETWEEN 51 AND 60 THEN '51 a 60'
        WHEN DATEDIFF(YEAR, nasc, @dataFimAno) > 60 THEN 'Mais de 60'
    END,
	nacnat
)
GO
