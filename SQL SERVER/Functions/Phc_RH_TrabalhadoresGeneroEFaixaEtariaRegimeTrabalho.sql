SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Nº total trabalhadores com contrato MI a full time a em part time, a 31/12/2024, dividido por género e por faixa etária.
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtariaRegimeTrabalho] 
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
	rdtrab,
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
    COUNT(*) AS total_trabalhadores
FROM
    pe
		OUTER APPLY (
    SELECT TOP 1
        hp.tpcontrato,
        hp.datainicontrato,
        hp.datafimcontrato,
        hp.CODMOTIVOSENTR,
        hp.CODMOTIVOSSAID,
		hp.contrato
    FROM hp
    WHERE hp.tipo = 1
      AND hp.no = pe.no 
	  AND (
				(YEAR(hp.datainicontrato) < year(@dataFimAno)
				 OR (YEAR(hp.datainicontrato) = year(@dataFimAno) AND MONTH(hp.datainicontrato) <= month(@dataFimAno)))
			  )
		  AND (
				hp.datafimcontrato ='19000101'
				OR YEAR(hp.datafimcontrato) > year(@dataFimAno)
				OR (YEAR(hp.datafimcontrato) = year(@dataFimAno) AND MONTH(hp.datafimcontrato) >= month(@dataFimAno))
			  )
    ORDER BY hp.datainicontrato DESC, hp.usrhora desc, data desc
) hp_mes
	left join tpcontrato on pe.contrato=tpcontrato.codcontrato

WHERE
    hp_mes.datainicontrato <= @dataFimAno and 
    pe.no in (select distinct pr.no from pr
					where year(data)= year(@dataFimAno) and month(data)=month(@dataFimAno)
					) --registos recibos de vencimento nesse ano
	and (hp_mes.datafimcontrato >= @dataFimAno or hp_mes.datafimcontrato ='19000101')
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
	rdtrab
)
GO
