SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Componentes do pacote remuneratório (salário, remuneração variável, subsídios, seguros, outros
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresComponentesPacoteRemuneratorio]
(	
	@DataInicial date,
	@DataFinal date,
	@Internos bit,
	@Externos bit
)
RETURNS TABLE 
AS
RETURN 
(
	select rem as 'Componentes do Pacote Remuneratório',
	count(*) as 'Quantidade de Recibos onde está presente'
	from prre 
	join pr on prre.prstamp=pr.prstamp
	left join pe on pe.no=pr.no
	where rem<>'' and pr.data between @DataInicial and @DataFinal
	--and pr.no in (select distinct pe.no from pe where )  filtrar por vinculo 
	and ( (@Internos = 1 AND pe.u_interno = 1) OR (@Externos = 1 AND pe.u_interno = 0) )
	group by rem

)
GO
