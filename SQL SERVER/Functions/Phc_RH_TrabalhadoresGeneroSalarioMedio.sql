SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresGeneroSalarioMedio]
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

SELECT --Sem Isenção de Horário M
	'Trabalhadores Com Apenas Ordenado Base' as 'Remunerações',
	'M' as 'Sexo',
    ISNULL(AVG(prre.ere), 0) as 'Média Salarial'
FROM
    pr
LEFT JOIN prre ON pr.prstamp = prre.prstamp 
WHERE
    pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'M' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
    AND pr.prstamp IN (
            select prstamp 
            from prre 
            where prre.dtref BETWEEN @DataInicial AND @DataFinal
            and prre.cr = 1
        )
	AND pr.prstamp NOT IN (
            select prstamp 
            from prre 
            where prre.dtref BETWEEN @DataInicial AND @DataFinal
            and prre.cr = 4
        )
	and prre.cr = 1	 
    
UNION ALL

SELECT --Sem Isenção de Horário F
	'Trabalhadores Com Apenas Ordenado Base' as 'Remunerações',
	'F' as 'Sexo',
    ISNULL(AVG(prre.ere), 0) as 'Média Salarial'
FROM
    pr
LEFT JOIN prre ON pr.prstamp = prre.prstamp 
WHERE
    pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'F' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
    AND pr.prstamp IN (
            select prstamp 
            from prre 
            where prre.dtref BETWEEN @DataInicial AND @DataFinal
            and prre.cr = 1
        )
	AND pr.prstamp NOT IN (
            select prstamp 
            from prre 
            where prre.dtref BETWEEN @DataInicial AND @DataFinal
            and prre.cr = 4
        )
	and prre.cr = 1	

UNION ALL


SELECT 
	'Trabalhadores Com Ordenado Base + Isenção de Horário' as 'Remunerações',
	'M' as 'Sexo',
	( 
			(SELECT 
				ISNULL(AVG(prre.ere), 0)
			FROM
				pr
			LEFT JOIN prre ON pr.prstamp = prre.prstamp 
			WHERE
				pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'M' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 1
                    )
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 4
                    )
				and prre.cr = 1)
		+
			(SELECT 
				ISNULL(AVG(prre.ere), 0)
			FROM
				pr
			LEFT JOIN prre ON pr.prstamp = prre.prstamp 
			WHERE
				pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'M' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 1
                    )
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 4
                    )
				and prre.cr = 4)
		) as 'Média Salarial'

UNION ALL


SELECT
	'Trabalhadores Com Ordenado Base + Isenção de Horário' as 'Remunerações',
	'F' as 'Sexo',
	(
			(SELECT 
				ISNULL(AVG(prre.ere), 0)
			FROM
				pr
			LEFT JOIN prre ON pr.prstamp = prre.prstamp 
			WHERE
				pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'F' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 1
                    )
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 4
                    )
				and prre.cr = 1)
		+
			(SELECT 
				ISNULL(AVG(prre.ere), 0)
			FROM
				pr
			LEFT JOIN prre ON pr.prstamp = prre.prstamp 
			WHERE
				pr.no IN (SELECT DISTINCT pe.no FROM pe WHERE pe.sexo = 'F' and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ))
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 1
                    )
				AND pr.prstamp IN (
                        select prstamp 
                        from prre 
                        where prre.dtref BETWEEN @DataInicial AND @DataFinal
                        and prre.cr = 4
                    )
				and prre.cr = 4)
		) as 'Média Salarial'
);
GO
