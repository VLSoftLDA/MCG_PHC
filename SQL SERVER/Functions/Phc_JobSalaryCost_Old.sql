SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_JobSalaryCost_Old]
(
	@Mes Integer
	,@Ano Integer
)

RETURNS TABLE 
AS
RETURN 
(
	SELECT
		pr.prstamp,pe2.cval1,pe.no,pe.nome,pe.ccusto,pe.u_interno,pr.recibo,pe.eviht,pr.txssp,pr.txsse,pr.eliquido,pe.ebasemes
		,'CustoMensalBase' = cast(round((((pe.ebasemes+pe.eviht+(((pe.ebasemes+pe.eviht)/12)*2))*12)/11),2) as decimal(10,2))
		,'CustoMensalBaseComSS' = cast(round((((pe.ebasemes+pe.eviht+(((pe.ebasemes+pe.eviht)/12)*2))*12)/11),2)*(1+((pr.txsse)/100)) as decimal(10,2))
		,'OutrosSujSS' =cast(isnull((select sum(ere) from prre inner join cm6 on prre.cr=cm6.cm
					where cm6.codbase=0 and cm6.iht=0 and cm6.codferss=0 and cm6.codnatss=0 and cm6.ferias=0 and cm6.natal=0 and prre.prstamp=pr.prstamp),0) as decimal(10,2))
		,'OutrosSujSSComSS' =cast(isnull((select sum(ere) from prre inner join cm6 on prre.cr=cm6.cm
					where cm6.codbase=0 and cm6.iht=0 and cm6.codferss=0 and cm6.codnatss=0 and cm6.ferias=0 and cm6.natal=0 and prre.prstamp=pr.prstamp),0) as decimal(10,2))
					+
					cast(isnull((select sum(esujss) from prre inner join cm6 on prre.cr=cm6.cm
					where cm6.codbase=0 and cm6.iht=0 and cm6.codferss=0 and cm6.codnatss=0 and cm6.ferias=0 and cm6.natal=0 and prre.prstamp=pr.prstamp),0)*((pr.txsse)/100) as decimal(10,2))
		,'CustoRecibo' = Round(pr.eliquido+pr.essevalor+pr.ettdesc+pr.ETTNOTLIQUIDO,2) 
		,'CustoCalculado' = cast(round((((pe.ebasemes+pe.eviht+(((pe.ebasemes+pe.eviht)/12)*2))*12)/11),2)*(1+((pr.txsse)/100)) as decimal(10,2))
							+
							cast(isnull((select sum(ere) from prre inner join cm6 on prre.cr=cm6.cm
								where cm6.codbase=0 and cm6.iht=0 and cm6.codferss=0 and cm6.codnatss=0 and cm6.ferias=0 and cm6.natal=0   and prre.prstamp=pr.prstamp),0) as decimal(10,2))
							+
							cast(isnull((select sum(esujss) from prre inner join cm6 on prre.cr=cm6.cm
								where cm6.codbase=0 and cm6.iht=0 and cm6.codferss=0 and cm6.codnatss=0 and cm6.ferias=0 and cm6.natal=0 and prre.prstamp=pr.prstamp),0)*((pr.txsse)/100) as decimal(10,2))
		,'Horas' =iif(pr.dias>22,22,pr.dias)*8 
	FROM pr(nolock)
		INNER JOIN pe(nolock) ON pr.no=pe.no
		LEFT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp
	WHERE month(pr.data)=@Mes and year(pr.data)=@Ano
)
GO
