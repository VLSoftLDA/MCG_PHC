SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Phc_GetAccountingSalaryCodes]
    @Ano INT,
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DtBegin DATE;
    DECLARE @DtEnd DATE;
	DECLARE @Periodo CHAR(7);

	SET @Periodo =
		RIGHT('00' + CAST(@Mes AS VARCHAR(2)),2)
		+ '.'
		+ CAST(@Ano AS CHAR(4));

    -- Primeiro dia do mês
    SET @DtBegin = DATEFROMPARTS(@Ano, @Mes, 1);
    -- Último dia do mês
    SET @DtEnd = EOMONTH(@DtBegin);

	SELECT
		'Tipo' = CASE 
					WHEN pr.codigo = 1 THEN 'Gerência'
					ELSE 'Normal'
				END,
		'Descrição' = prre.rem,
		'Valor' = SUM(prre.ere),
		'Código Vencimento' = convert(varchar,cm6.cm),
		'Mapa de seguro' = CASE 
							WHEN ISNULL(cm6.MPSEG, 0) = 1 THEN 'Sim'
							ELSE 'Não'
						END,
		'Conta Debito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.debger
							ELSE cm6.debnor
						END, 
		'Conta Crédito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.creger
							ELSE cm6.crenor
						END
	FROM prre (NOLOCK)
		INNER JOIN pr (NOLOCK) ON prre.prstamp = pr.prstamp
		LEFT JOIN cm6 (NOLOCK) ON prre.cr = cm6.cm
	WHERE pr.data BETWEEN @DtBegin AND @DtEnd AND prre.rem <> ''
	GROUP BY prre.rem,pr.codigo,cm6.cm,cm6.MPSEG,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor

	UNION ALL

	SELECT
		'Tipo' = CASE 
					WHEN pr.codigo = 1 THEN 'Gerência'
					ELSE 'Normal'
				END,
		'Descrição' = CASE 
						WHEN prde.TXEXTMIRS = 1 THEN 'IRS - Sobretaxa' 
						ELSE prde.des 
					END,
		'Valor' = SUM(prde.ede),
		'Código Vencimento' = convert(varchar,cm6.cm),
		'Mapa de seguro' = CASE 
							WHEN ISNULL(cm6.MPSEG, 0) = 1 THEN 'Sim'
							ELSE 'Não'
						END,
		'Conta Debito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.debger
							ELSE cm6.debnor
						END,
		'Conta Crédito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.creger
							ELSE cm6.crenor
						END
	FROM prde (NOLOCK)
		INNER JOIN pr (NOLOCK) ON prde.prstamp = pr.prstamp
		LEFT JOIN cm6 (NOLOCK) ON prde.cd = cm6.cm
	WHERE pr.data BETWEEN @DtBegin AND @DtEnd AND prde.des <> ''
	GROUP BY prde.des,prde.txextMirs,pr.codigo,cm6.cm,cm6.MPSEG,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor

	UNION ALL

	SELECT
		'Tipo' = CASE 
					WHEN pr.codigo = 1 THEN 'Gerência'
					ELSE 'Normal'
				END,
		'Descrição' = 'Segurança social paga pela empresa',
		'Valor' = SUM(pr.ESSEVALOR),
		'Código Vencimento' = convert(varchar,cm6.cm),
		'Mapa de seguro' =  CASE 
							WHEN ISNULL(cm6.MPSEG, 0) = 1 THEN 'Sim'
							ELSE 'Não'
						END,
		'Conta Debito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.debger
							ELSE cm6.debnor
						END,
		'Conta Crédito' = CASE 
							WHEN pr.codigo = 1 THEN cm6.creger
							ELSE cm6.crenor
						END
	FROM pr (NOLOCK)
		LEFT JOIN cm6 (NOLOCK) ON cm6.cm = 999
	WHERE pr.data BETWEEN @DtBegin AND @DtEnd 
	GROUP BY pr.codigo,cm6.cm,cm6.MPSEG,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor

	ORDER BY Tipo, Descrição

END;
GO
