SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresTaxaAbsentismo]
(	
	@Ano as Integer,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
-- Total por Descrição de falta
SELECT 
    prf.thfdesc AS 'Funcionários Estrutura',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 1 THEN prf.horasf ELSE 0 END),0) AS 'Janeiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 2 THEN prf.horasf ELSE 0 END),0) AS 'Fevereiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 3 THEN prf.horasf ELSE 0 END),0) AS 'Março',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 4 THEN prf.horasf ELSE 0 END),0) AS 'Abril',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 5 THEN prf.horasf ELSE 0 END),0) AS 'Maio',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 6 THEN prf.horasf ELSE 0 END),0) AS 'Junho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 7 THEN prf.horasf ELSE 0 END),0) AS 'Julho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 8 THEN prf.horasf ELSE 0 END),0) AS 'Agosto',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 9 THEN prf.horasf ELSE 0 END),0) AS 'Setembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 10 THEN prf.horasf ELSE 0 END),0) AS 'Outubro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 11 THEN prf.horasf ELSE 0 END),0) AS 'Novembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 12 THEN prf.horasf ELSE 0 END),0) AS 'Dezembro',
    isnull(SUM(prf.horasf),0) AS '*TOTAL*'
FROM 
    prf
JOIN 
    pr ON pr.prstamp = prf.prstamp
WHERE 
    prf.fdia = 1 --unidade é dia
    AND YEAR(pr.data) = @Ano
	and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)) )
GROUP BY 
    prf.thfdesc

UNION ALL

-- Total de dias Mês
SELECT 
    '*Total de dias de faltas (mês)*' AS 'Funcionários Estrutura',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 1 THEN prf.horasf ELSE 0 END),0) AS 'Janeiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 2 THEN prf.horasf ELSE 0 END),0) AS 'Fevereiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 3 THEN prf.horasf ELSE 0 END),0) AS 'Março',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 4 THEN prf.horasf ELSE 0 END),0) AS 'Abril',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 5 THEN prf.horasf ELSE 0 END),0) AS 'Maio',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 6 THEN prf.horasf ELSE 0 END),0) AS 'Junho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 7 THEN prf.horasf ELSE 0 END),0) AS 'Julho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 8 THEN prf.horasf ELSE 0 END),0) AS 'Agosto',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 9 THEN prf.horasf ELSE 0 END),0) AS 'Setembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 10 THEN prf.horasf ELSE 0 END),0) AS 'Outubro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 11 THEN prf.horasf ELSE 0 END),0) AS 'Novembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 12 THEN prf.horasf ELSE 0 END),0) AS 'Dezembro',
    isnull(SUM(prf.horasf),0) AS 'TOTAL'
FROM 
    prf
JOIN 
    pr ON pr.prstamp = prf.prstamp
WHERE 
    prf.fdia = 1 --unidade é dia
    AND YEAR(pr.data) = @Ano
	and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))

UNION ALL

-- Total de Horas por Mês
SELECT 
    '*Total de HORAS de faltas/Ausências*' AS 'Funcionários Estrutura',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 1 THEN prf.horasf*8 ELSE 0 END),0) AS 'Janeiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 2 THEN prf.horasf*8 ELSE 0 END),0) AS 'Fevereiro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 3 THEN prf.horasf*8 ELSE 0 END),0) AS 'Março',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 4 THEN prf.horasf*8 ELSE 0 END),0) AS 'Abril',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 5 THEN prf.horasf*8 ELSE 0 END),0) AS 'Maio',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 6 THEN prf.horasf*8 ELSE 0 END),0) AS 'Junho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 7 THEN prf.horasf*8 ELSE 0 END),0) AS 'Julho',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 8 THEN prf.horasf*8 ELSE 0 END),0) AS 'Agosto',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 9 THEN prf.horasf*8 ELSE 0 END),0) AS 'Setembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 10 THEN prf.horasf*8 ELSE 0 END),0) AS 'Outubro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 11 THEN prf.horasf*8 ELSE 0 END),0) AS 'Novembro',
    isnull(SUM(CASE WHEN MONTH(pr.data) = 12 THEN prf.horasf*8 ELSE 0 END),0) AS 'Dezembro',
    isnull(SUM(prf.horasf)*8,0) AS 'TOTAL'
FROM 
    prf
JOIN 
    pr ON pr.prstamp = prf.prstamp
WHERE 
    prf.fdia = 1 --unidade é dia
	AND YEAR(pr.data) = @Ano
	and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))

UNION ALL

SELECT 
    '' AS 'Funcionários Estrutura',
    0 AS 'Janeiro',
    0 AS 'Fevereiro',
    0 AS 'Março',
    0 AS 'Abril',
    0 AS 'Maio',
    0 AS 'Junho',
    0 AS 'Julho',
    0 AS 'Agosto',
    0 AS 'Setembro',
    0 AS 'Outubro',
    0 AS 'Novembro',
    0 AS 'Dezembro',
    0 AS 'TOTAL'

UNION ALL

SELECT 
    'Nº Total de recibos de Vencimento' AS 'Funcionários Estrutura',
    (select count(*) from pr where month(data)=1 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) as 'Janeiro',
    (select count(*) from pr where month(data)=2 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Fevereiro',
    (select count(*) from pr where month(data)=3 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Março',
    (select count(*) from pr where month(data)=4 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Abril',
    (select count(*) from pr where month(data)=5 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Maio',
    (select count(*) from pr where month(data)=6 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Junho',
    (select count(*) from pr where month(data)=7 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Julho',
    (select count(*) from pr where month(data)=8 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Agosto',
    (select count(*) from pr where month(data)=9 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Setembro',
    (select count(*) from pr where month(data)=10 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Outubro',
    (select count(*) from pr where month(data)=11 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Novembro',
    (select count(*) from pr where month(data)=12 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Dezembro',
    (select count(*) from pr where year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'TOTAL'

UNION ALL

SELECT 
    'Nº Dias Úteis de trabalho/mês ' AS 'Funcionários Estrutura',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=1) as 'Janeiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=2) AS 'Fevereiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=3) AS 'Março',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=4) AS 'Abril',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=5) AS 'Maio',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=6) AS 'Junho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=7) AS 'Julho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=8) AS 'Agosto',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=9) AS 'Setembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=10) AS 'Outubro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=11) AS 'Novembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=12) AS 'Dezembro',
    (select isnull(sum(Workdays),0) from u_DiasUteisPorMes(@Ano)) AS 'TOTAL'

UNION ALL

SELECT 
    'Nº Horas Teóricas de trabalho/mês ' AS 'Funcionários Estrutura',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=1)*8 as 'Janeiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=2)*8 AS 'Fevereiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=3)*8 AS 'Março',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=4)*8 AS 'Abril',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=5)*8 AS 'Maio',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=6)*8 AS 'Junho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=7)*8 AS 'Julho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=8)*8 AS 'Agosto',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=9)*8 AS 'Setembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=10)*8 AS 'Outubro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=12)*8 AS 'Novembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=12)*8 AS 'Dezembro',
    (select isnull(sum(Workdays),0) from u_DiasUteisPorMes(@Ano))*8 AS 'TOTAL'

	UNION ALL

SELECT 
    'Nº Horas Teóricas Total ' AS 'Funcionários Estrutura',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=1)*8 * (select count(*) from pr where month(data)=1 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) as 'Janeiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=2)*8 * (select count(*) from pr where month(data)=2 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Fevereiro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=3)*8 * (select count(*) from pr where month(data)=3 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Março',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=4)*8 * (select count(*) from pr where month(data)=4 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Abril',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=5)*8 * (select count(*) from pr where month(data)=5 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Maio',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=6)*8 * (select count(*) from pr where month(data)=6 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Junho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=7)*8 * (select count(*) from pr where month(data)=7 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Julho',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=8)*8 * (select count(*) from pr where month(data)=8 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Agosto',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=9)*8 * (select count(*) from pr where month(data)=9 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Setembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=10)*8 * (select count(*) from pr where month(data)=10 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Outubro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=11)*8 * (select count(*) from pr where month(data)=11 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Novembro',
    (select Workdays from u_DiasUteisPorMes(@Ano) where [Month]=12)*8 * (select count(*) from pr where month(data)=12 and year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'Dezembro',
    (select isnull(sum(Workdays),0) from u_DiasUteisPorMes(@Ano))*8 * (select count(*) from pr where year(data)=@Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))) AS 'TOTAL'

UNION ALL


SELECT 
    'Taxa Absentismo (Horas Ausència/Horas Teóricas)' AS 'Funcionários Estrutura',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 1 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 1) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 1 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Janeiro',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 2 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 2) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 2 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Fevereiro',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 3 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 3) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 3 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Março',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 4 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 4) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 4 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Abril',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 5 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 5) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 5 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Maio',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 6 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 6) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 6 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Junho',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 7 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 7) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 7 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Julho',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 8 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 8) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 8 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Agosto',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 9 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 9) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 9 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Setembro',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 10 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 10) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 10 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Outubro',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 11 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 11) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 11 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Novembro',
    isnull((SUM(CASE WHEN MONTH(pr.data) = 12 THEN prf.horasf * 8 ELSE 0 END)) / 
        NULLIF((SELECT Workdays FROM u_DiasUteisPorMes(@Ano) WHERE [Month] = 12) * 8 * (SELECT COUNT(*) FROM pr WHERE MONTH(data) = 12 AND YEAR(data) = @Ano and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))), 0),0) * 100 AS 'Dezembro',
    0 AS 'TOTAL'

FROM 
    prf
JOIN 
    pr ON pr.prstamp = prf.prstamp
WHERE 
    prf.fdia = 1 --unidade é dia
    AND YEAR(pr.data) = @Ano
	and pr.no in (select pe.no from pe where ((@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0)))
)
GO
