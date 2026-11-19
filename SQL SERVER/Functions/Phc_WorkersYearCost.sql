SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_WorkersYearCost]
(
    @Ano int
)

RETURNS TABLE 
AS
RETURN 
(
	
	SELECT 
		 pr.Nome
		,iif(pe.u_interno=1,'Sim','Não') as 'Interno'
		,SUM(iif(month(pr.data)=1,T1.Total+pr.ESSEVALOR,0)) as 'Janeiro'	
		,SUM(iif(month(pr.data)=2,T1.Total+pr.ESSEVALOR,0)) as 'Fevereiro'	
		,SUM(iif(month(pr.data)=3,T1.Total+pr.ESSEVALOR,0)) as 'Março'	
		,SUM(iif(month(pr.data)=4,T1.Total+pr.ESSEVALOR,0)) as 'Abril'	
		,SUM(iif(month(pr.data)=5,T1.Total+pr.ESSEVALOR,0)) as 'Maio'	
		,SUM(iif(month(pr.data)=6,T1.Total+pr.ESSEVALOR,0)) as 'Junho'	
		,SUM(iif(month(pr.data)=7,T1.Total+pr.ESSEVALOR,0)) as 'Julho'	
		,SUM(iif(month(pr.data)=8,T1.Total+pr.ESSEVALOR,0)) as 'Agosto'	
		,SUM(iif(month(pr.data)=9,T1.Total+pr.ESSEVALOR,0)) as 'Setembro'	
		,SUM(iif(month(pr.data)=10,T1.Total+pr.ESSEVALOR,0)) as 'Outubro'	
		,SUM(iif(month(pr.data)=11,T1.Total+pr.ESSEVALOR,0)) as 'Novembro'	
		,SUM(iif(month(pr.data)=12,T1.Total+pr.ESSEVALOR,0)) as 'Dezembro'	
		,SUM(T1.Total+pr.ESSEVALOR) as 'Total'	
	FROM pr(nolock)	
	INNER JOIN pe(nolock) ON pr.no=pe.no
		INNER JOIN (
				SELECT 
					T0.prstamp
					,SUM(T0.ere) as 'Total'
				FROM  prre(nolock) T0
				WHERE T0.cr>0
				GROUP BY T0.prstamp) T1 on pr.prstamp = T1.prstamp
	WHERE year(pr.data) =@Ano 
	GROUP BY pr.nome,pe.u_interno
)
GO
