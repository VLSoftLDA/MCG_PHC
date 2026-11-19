SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_SalarioValidarHoras] (
	@DtInicial as Date,
	@DtFinal as Date
)
RETURNS TABLE 
AS
RETURN 
(
	select
		 pr.prstamp
		 ,pr.data
		 ,pr.recibo
		 ,pr.no
		 ,pr.nome
		 ,convert(decimal(10,2),pe.ebasemes) as 'Base'
		 ,pe.cinicio as DtIniContrato
		 ,dbo.Phc_DiasFeriado(concat(year(pr.data),'-',month(pr.data),'-01'),pr.data) as DiasFeriado
		 ,(case when pe.cinicio > concat(year(pr.data),'-',month(pr.data),'-01') and dbo.Phc_DiasUteis(pe.cinicio,pr.data)>0
			then dbo.Phc_DiasUteis(pe.cinicio,pr.data)
			else 0
		 end) as DiasContrato
		 ,dbo.Phc_DiasUteis(concat(year(pr.data),'-',month(pr.data),'-01'),pr.data) as DiasUteis
		 ,convert(int,pr.horasmes) as 'HorasRecibo'
		 ,convert(decimal(10,2),SUM(prre.ere)) as 'RemRecP'
	from pr
		inner join pe on pe.no=pr.no
		left join prre on pr.prstamp=prre.prstamp
		inner join cm6 on prre.cr = cm6.cm and cm6.tiposs like 'P - %'
	WHERE pr.data BETWEEN @DtInicial AND @DtFinal
	group by pr.data,pr.recibo,pr.no,pr.nome,pr.horasmes,pr.prstamp,pe.cinicio,pe.ebasemes

)
GO
