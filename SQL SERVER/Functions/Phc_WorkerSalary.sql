SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_WorkerSalary]
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
		,cast(pe.Estab as char(15)) as 'Estab'
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
		,SUM(TL.SujeitoSS) as 'SujeitoSS'
		,SUM(TL.SujeitoIRS) as 'SujeitoIRS'
		,pr.txssp as 'TxSSFuncionario'
		,pr.txsse as 'TxSSEmpresa'
		,convert(decimal(9,2),pr.ESSEVALOR) as 'SSEmpresa'
		,SUM(iif(T1.ss=1 or (T1.ss=0 and T1.sr=1),TL.SujeitoSS,0))*(pr.txssp/100) as 'SSFuncionário'
		,SUM(iif(T1.codirs=1,TL.Total,0)) as 'IRS'
		,pr.eliquido as 'Liquido'
		--,SUM(iif(T1.nototliq=0 and TL.Tipo='Remuneração',TL.Total,0)) - SUM(iif(TL.Tipo='Desconto',TL.Total,0)) as 'Liquido'
		,SUM(iif(TL.Tipo='Remuneração',TL.Total,0)) as 'Ilíquido'
		,SUM(iif(TL.Codigo=1,TL.Total,0)) as 'BaseRecibo'
		--,SUM(iif(TL.Codigo=54,TL.Total,0)) as 'LicençaParental' -- 17.01.2025 Retirei porque a distinção está no Tipo de falta
		--,SUM(iif(TL.Codigo=17,TL.Total,0)) as 'LicençaCasamento' -- 17.01.2025 Retirei porque a distinção está no Tipo de falta
		--,SUM(iif(TL.codigo=55,TL.Total,0)) as 'FaltasDiasNojo' -- 17.01.2025 Retirei porque a distinção está no Tipo de falta
		,SUM(iif(T1.sr=1 and T1.genero=0,TL.Total,0)) as 'SubRefeição'
		,SUM(iif(T1.sr=1 and T1.genero=1,TL.Total,0)) as 'SubRefeiçãoCartão'
		,SUM(iif(TL.Codigo=4,TL.Total,0)) as 'IsençãoHorário'
		,SUM(iif(T1.ferias=1,TL.Total,0)) as 'SubFérias'
		,SUM(iif(T1.natal=1,TL.Total,0)) as 'SubNatal'
		,SUM(iif(T1.codhe=1,TL.Total,0)) as 'HorasExtras'
		,SUM(iif(T1.nocturno=1,TL.Total,0)) as 'SubNoturno'
		,SUM(iif(TL.Codigo=21,TL.Total,0)) as 'FundoMina'
		,SUM(iif(TL.codigo=22,TL.Total,0)) as 'Kms'
		,SUM(iif(TL.Codigo=20,TL.Total,0)) as 'OutrasGratificações'
		,SUM(iif(T1.ajcusto=1 ,TL.Total,0)) as 'AjCustoNacionais'
		,SUM(iif(T1.eajcusto=1,TL.Total,0)) as 'AjCustoEstrangeiro'
		,SUM(iif(T1.indemn=1 ,TL.Total,0)) as 'Indemnização'
		,SUM(iif(TL.Codigo=32 ,TL.Total,0)) as 'GratificaçõesBalanço'
		,SUM(iif(TL.Codigo=34,TL.Total,0)) as 'PrémioFunção'
		,SUM(iif(TL.Codigo=89 ,TL.Total,0)) as 'PrémioSegurança'
		,SUM(iif(TL.Codigo=35 ,TL.Total,0)) as 'ComplementoDestacamento'
		,SUM(iif(T1.especie=1 ,TL.Total,0)) as 'RendimentoEspécie'
		,SUM(iif(TL.Codigo=100 ,TL.Total,0)) as 'FériasNãoGozadas'
		,SUM(iif(TL.Codigo=101 ,TL.Total,0)) as 'RetOrdBase'
		,SUM(iif(TL.Codigo=117 ,TL.Total,0)) as 'RetSubFérias'
		,SUM(iif(TL.Codigo=172 ,TL.Total,0)) as 'RetSubNatal'
		,SUM(iif(TL.Codigo=50 ,TL.Total,0)) as 'PrémioProdutividade'
		,SUM(iif(TL.codigo=45,TL.Total,0)) as 'SubsídioPernoita'
		,SUM(iif(TL.codigo=91,TL.Total,0)) as 'SuplementoPiquete'
		,SUM(iif(TL.codigo=44,TL.Total,0)) as 'BolsaEstágio'
		,SUM(iif(T1.flthora=1 or T1.fltdia=1 or T1.fltmes=1,TL.Total,0)) as 'Faltas'
		,SUM(iif(TL.codigo=506,TL.Total,0)) as 'Adiantamento'
		,SUM(iif(TL.codigo=507,TL.Total,0)) as 'PenhoraVencimento'
		,SUM(iif(TL.codigo=505,TL.Total,0)) as 'PenhoraJudicial'
		,SUM(iif(TL.codigo=777,TL.Total,0)) as 'DescontoSeguro'
		,SUM(iif(TL.codigo=56,TL.Total,0)) as 'SubSegurançaParagem'
		,SUM(iif(TL.codigo=57,TL.Total,0)) as 'SubSegurançaS/Pernoita'
		,SUM(iif(TL.codigo=58,TL.Total,0)) as 'SubSegurançaC/Pernoita'
		,SUM(iif(TL.codigo=30,TL.Total,0)) as 'CompensaçãoP/CessaçãoCT'
		,SUM(iif(TL.Tipo='Remuneração',TL.Total,0))+(pr.ESSEVALOR) as 'TotalCusto'
		,pe.tcontr as 'TipoContrato'
		,pe2.dcategoria as 'Categoria Recibo'
		,pe.dataadm as 'Data de Admissão'
	FROM pr(nolock)	
		LEFT JOIN (
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
	GROUP BY pr.Recibo,pr.CCusto,pe.Estab,pr.data,pr.No,pr.ESSEVALOR,pr.eliquido
		,pr.Nome,pe.u_interno,pr.Ncont,pe2.nmdpt,pe.nfilhos,pe.ECIVIL,pe.nasc,pr.ettsuj
		,pr.ettnsuj,pr.txssp,pr.txsse,pe.tcontr	,pe2.dcategoria,pe.dataadm	
)
GO
