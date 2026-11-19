SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Phc_GetHRCodesValueWeb]
(
    @Mes integer
    ,@Ano integer
)

RETURNS TABLE 
AS
RETURN 
(
		-- REMUNERAÇÕES
		Select 'REM' as Tipo,prre.cr as Codigo,space(20) as ncusto
			,sum(case when pr.codigo=1 then ROUND(prre.ere,2) else 0 end) as Gerencia
			,sum(case when pr.codigo=2 then ROUND(prre.ere,2) else 0 end) as Normal
			,sum(case when pr.codigo=3 then ROUND(prre.ere,2) else 0 end) as Producao
			,sum(case when pr.codigo=4 then ROUND(prre.ere,2) else 0 end) as PEmprego
		from pr (nolock) 
			inner join prre (nolock) on pr.prstamp=prre.prstamp 
			inner join cm6 (nolock) on prre.cr=cm6.cm and cm6.especie = 0  
		where month(pr.data)=@Mes And year(pr.data)=@Ano And pr.plano=0 
		group by prre.cr 

		UNION ALL
		-- DESCONTOS
		Select 
			'DES' as Tipo,prde.cd as Codigo
			,space(20) as ncusto
			,sum(Case when pr.codigo=1 then Round(prde.ede,2) Else 0 end) as Gerencia
			,sum(Case when pr.codigo=2 then Round(prde.ede,2) Else 0 end) as Normal
			,sum(Case when pr.codigo=3 then Round(prde.ede,2) Else 0 end) as Producao
			,sum(Case when pr.codigo=4 then Round(prde.ede,2) Else 0 end) as PEmprego
		from pr (nolock) 
			inner join prde (nolock) on pr.prstamp=prde.prstamp 
			inner join cm6 (nolock) on prde.cd=cm6.cm 
		where month(pr.data)=@Mes And year(pr.data)=@Ano And pr.plano=0 
		group by prde.cd

		UNION ALL
		-- SEGURANÇA SOCIAL
		Select 'SS' as Tipo, 999 as Codigo, space(20) as ncusto
			,sum(Case when pr.codigo=1 then Round(pr.essevalor,2) Else 0 end) as Gerencia
			,sum(Case when pr.codigo=2 then Round(pr.essevalor,2) Else 0 end) as Normal
			,sum(Case when pr.codigo=3 then Round(pr.essevalor,2) Else 0 end) as Producao
			,sum(Case when pr.codigo=4 then Round(pr.essevalor,2) Else 0 end) as PEmprego
		from pr (nolock)
		where month(pr.data)=@Mes And year(pr.data)=@Ano And pr.plano=0
					
)
GO
