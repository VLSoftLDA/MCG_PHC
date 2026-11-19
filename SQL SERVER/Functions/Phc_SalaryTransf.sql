SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Phc_SalaryTransf]
(
	@DataI Date
	,@DataF Date
)

RETURNS TABLE 
AS
RETURN 
(

	WITH sq_dr AS (
		SELECT 
			'Transf'= tb.cheque
			,'Data' = tb.data
			,fr.nome
			,pe.codigo
			,'SAPE' = pe2.cval6
			,fr.tipo
			,'ValorDR'=cast(fr.evalor as decimal(10,2))
		FROM fr 
			inner join tb on fr.tbstamp=tb.tbstamp
			inner join pe on fr.no=pe.no
			inner join pe2 on pe.pestamp=pe2.pe2stamp
		WHERE tb.data >=@DataI and tb.data <=@DataF
	),
	sq_pr AS (
		SELECT
			'Transf'= tb.cheque
			,'Data' = tb.data
			,pr.nome 
			,pe.codigo
			,'SAPE' = pe2.cval6
			,'ValorPR' = pr.eliquido
			,pr.prstamp
			,tb.sr
		FROM pr (nolock)
			inner join pe (nolock) on pr.no = pe.no
			inner join pe2 on pe.pestamp=pe2.pe2stamp
			inner join tb (nolock) on pr.tbstamp = tb.tbstamp
		WHERE tb.data >=@DataI and tb.data <=@DataF

	),
	sq_src AS (
		SELECT 
			prstamp
			,tbstamp
			,'ValorSRC' = sum(prre.ere)
		FROM prre (nolock)
			INNER JOIN cm6 (nolock) ON cm6.cm = prre.cr and cm6.sr = 1 and cm6.genero = 1
		GROUP BY prstamp,tbstamp
	),

	sq_movs AS 
	(
		SELECT Transf,Data,Nome,Codigo,SAPE,Tipo, 'Debito' = ValorDR, 'Credito'=0 
		FROM sq_dr
	UNION ALL 
		SELECT Transf,Data,Nome,Codigo,SAPE,Tipo, 'Debito' = 0, 'Credito'=ValorDR 
		FROM sq_dr
	UNION ALL 
		SELECT Transf,Data,Nome,Codigo,SAPE,Tipo='SALÁRIOS', 'Debito' = (ValorPR-isnull(ValorSRC,0)), 'Credito'=0
		FROM sq_pr 
			LEFT JOIN sq_src ON sq_pr.prstamp=sq_src.prstamp
	UNION ALL 
		SELECT Transf,Data,Nome,Codigo,SAPE,Tipo='SALÁRIOS', 'Debito' = 0, 'Credito'=(ValorPR-isnull(ValorSRC,0))
		FROM sq_pr 
			LEFT JOIN sq_src ON sq_pr.prstamp=sq_src.prstamp
	UNION ALL 
		SELECT 'Transf'=tb.cheque,sq_pr.Data,Nome,Codigo,SAPE,'Tipo'='SALÁRIOS - SR. CARTÃO', 'Debito' = isnull(ValorSRC,0), 'Credito'=0
		FROM sq_pr 
			LEFT JOIN sq_src ON sq_pr.prstamp=sq_src.prstamp 
			INNER JOIN tb ON sq_src.tbstamp=tb.tbstamp and tb.sr=1
		WHERE isnull(ValorSRC,0)<>0 
	UNION ALL 
		SELECT 'Transf'=tb.cheque,sq_pr.Data,Nome,Codigo,SAPE,'Tipo'='SALÁRIOS - SR. CARTÃO', 'Debito' = 0, 'Credito'=isnull(ValorSRC,0)
		FROM sq_pr 
			LEFT JOIN sq_src ON sq_pr.prstamp=sq_src.prstamp 
			INNER JOIN tb ON sq_src.tbstamp=tb.tbstamp and tb.sr=1
		WHERE isnull(ValorSRC,0)<>0 
	),

	sq_lin AS (
	SELECT
		T0.Transf
		,T0.Data
		,T0.Nome
		,T0.Tipo
		,T0.Debito
		,T0.Credito
		,'Conta' = (
			case when T0.Codigo=1 
				then (case when T0.Debito<>0 then T1.os_debit_account else T1.os_credit_account end)
				else (case when T0.Debito<>0 then T1.pe_debit_account else T1.pe_credit_account end)
			end
		)
		,'BP' = (case when T1.os_emp='ENNNNN' 
					then SAPE 
					else (case when T0.Codigo=1 
								then T1.os_emp 
								else T1.pe_emp 
						end) 
				end)
		,'Banco' = T1.Bank
	FROM sq_movs T0
		INNER JOIN aa_transf_config T1 ON T0.Tipo = T1.TType
	)

	-- Débitos: detalhe por linha (o agrupamento por BP/Conta/Tipo é feito na query de consumo)
	SELECT Transf, Data, Nome, Tipo, Debito, Credito, Conta, BP, Banco
	FROM sq_lin
	WHERE Debito <> 0

	UNION ALL

	-- Créditos: uma única linha por transferência e banco, com o total da transferência
	SELECT
		Transf
		,Data
		,'Nome' = NULL
		,'Tipo' = CASE WHEN MIN(Tipo) = MAX(Tipo) THEN MIN(Tipo) ELSE 'TOTAL TRANSFERÊNCIA' END
		,'Debito' = 0
		,'Credito' = SUM(Credito)
		,'Conta' = Banco
		,'BP' = Banco
		,Banco
	FROM sq_lin
	WHERE Credito <> 0
	GROUP BY Transf, Data, Banco

)
GO
