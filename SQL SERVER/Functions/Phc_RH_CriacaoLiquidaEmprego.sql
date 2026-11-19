SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_CriacaoLiquidaEmprego]
(	
	@data1 as Date,
	@data2 as Date,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
	concat(month(@data1),'/', year(@data1)) as 'Mês',
    COUNT(*) AS 'Nº de Recibos de Vencimento'
FROM
    pe
WHERE
    pe.no in (select distinct pr.no from pr
					where year(data)= year(@data1) and month(data)=month(@data1)
					) --registos recibos de vencimento nesse ano
	and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )
UNION ALL

	SELECT
	concat(month(@data2),'/', year(@data2)) as 'Mês',
    COUNT(*) AS 'Nº de Recibos de Vencimento'
FROM
    pe
WHERE
    pe.no in (select distinct pr.no from pr
					where year(data)= year(@data2) and month(data)=month(@data2)
					) --registos recibos de vencimento nesse ano
	and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )
UNION ALL

SELECT 
	'Diferença' as 'Mês',
	 ((SELECT COUNT(*) FROM pe WHERE  ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ) and pe.no in (select distinct pr.no from pr where year(data)= year(@data2) and month(data)=month(@data2))) -  (SELECT COUNT(*) FROM pe WHERE  ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) ) and pe.no in (select distinct pr.no from pr where year(data)= year(@data1) and month(data)=month(@data1)))) AS 'Nº de Recibos de Vencimento'


)
GO
