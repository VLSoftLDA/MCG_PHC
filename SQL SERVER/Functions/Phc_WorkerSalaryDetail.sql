SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_WorkerSalaryDetail]
(
    @DataInicial date
    ,@DataFinal date
)

RETURNS TABLE 
AS
RETURN 
(
	
	SELECT 
		cast(pr.Recibo as char(15)) as 'Recibo'
		,pr.CCusto
		,cast(pr.Estab as char(15)) as 'Estab'
		,@DataInicial as 'DataInicial'
		,@DataFinal as 'DataFinal'
		,convert(char(10),pr.data,120) as 'DataRecibo'
		,cast(pr.No as char(15)) as 'Número'
		,pr.Nome
		,iif(pe.u_interno=1,'Sim','Não') as 'Interno'
		,pr.Ncont as 'Nif'
		,pe2.nmdpt as 'Departamento'
		,cast(pe.nfilhos as char(15)) as 'Filhos'
		,pe.ECIVIL as 'Ecivil'
		,cast((datediff(month,pe.nasc,getdate()) /12) as char(15)) as 'Idade'
		--,SUM(TL.SujeitoSS) as 'SujeitoSS'
		--,SUM(TL.SujeitoIRS) as 'SujeitoIRS'
		,pr.txssp as 'TxSSFuncionario'
		,pr.txsse as 'TxSSEmpresa'
		,convert(decimal(9,2),pr.ESSEVALOR) as 'SSEmpresa'
		--,SUM(iif(T1.ss=1 or (T1.ss=0 and T1.sr=1),TL.SujeitoSS,0))*(pr.txssp/100) as 'SSFuncionário'
		--,SUM(iif(T1.codirs=1,TL.Total,0)) as 'IRS'
		,convert(decimal(9,2),pr.eliquido) as 'Liquido'
		,pe.tcontr as 'TipoContrato'
		,TL.Tipo
		,cast(TL.Código as char(15)) as 'Código'
		,TL.Designação
		,TL.Quantidade
		,TL.PUnit
		,TL.Total
		,TL.SujeitoSS
		,TL.SujeitoIRS
	FROM pr(nolock)	
		INNER JOIN (
				SELECT 
					T0.prstamp
					,'Remuneração' as 'Tipo'
					,T0.cr as 'Codigo'
					,T0.rem as 'Designacao'
					,SUM(T0.rqtt) as 'Quantidade'
					,SUM(T0.ervu) as 'PUnit'
					,SUM(T0.ere) as 'Total'
					,SUM(T0.ereirs) as 'SujeitoIRS'
					,SUM(T0.esujss) as 'SujeitoSS'
				FROM  prre(nolock) T0
				WHERE T0.cr>0
				GROUP BY T0.prstamp,T0.cr,T0.rem

				UNION ALL

				SELECT 
					T0.prstamp
					,'Desconto' as 'Tipo'
					,T0.cd as 'Codigo'
					,T0.des as 'Designacao'
					,SUM(T0.dqtt) as 'Quantidade'
					,SUM(T0.ede) as 'PUnit'
					,SUM(T0.ede) as 'Total'
					,0 as 'SujeitoIRS'
					,0 as 'SujeitoSS'
				FROM  prde(nolock) T0 
				WHERE T0.cd>0
				GROUP BY T0.prstamp,T0.cd,T0.des) TL on pr.prstamp = TL.prstamp
		LEFT JOIN cm6(nolock) T1 ON TL.codigo = T1.cm and T1.inactivo=0
		LEFT JOIN pe(nolock) on pe.no=pr.no 
		LEFT JOIN pe2(nolock) on pe.pestamp=pe2.pe2stamp
	WHERE pr.data between @DataInicial AND @DataFinal	
	GROUP BY pr.Recibo,pr.CCusto,pr.Estab,pr.data,pr.No,pr.ESSEVALOR,pr.eliquido
		,pr.Nome,pe.u_interno,pr.Ncont,pe2.nmdpt,pe.nfilhos,pe.ECIVIL,pe.nasc,pr.txssp,pr.txsse,pe.tcontr	
		,TL.Tipo,TL.Código,TL.Designação,TL.Quantidade,TL.PUnit,TL.Total,TL.SujeitoSS,TL.SujeitoIRS		
)
GO
