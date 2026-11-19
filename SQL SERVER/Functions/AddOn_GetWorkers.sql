SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AddOn_GetWorkers]
(
    @DataRecibo Date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		'Numero' = pe.no,
		'NIF'=rtrim(pe.ncont),
		'Nome' = pe.nome,
		'Casado' = pe2.casado,
		'Titulares' = pe.ntit,
		'Filhos' = pe.nfilhos,
		'TitularDef' = pe.DEFICIENTE,
		'ConjugeDef' = pe2.CONJUGECOMDEFIC,
		'DepDef' = pe2.DEPENDENTECOMDEFIC,
		'NDepDef' = pe2.TOTDEPCOMDEFIC,
		'TabIRS23' = isnull(dbo.AddOn_GetIRSTable(pe2.casado,iif(pe2.casado=1,0,1),iif(pe.nfilhos>0,1,0),iif(pe.ntit>1,1,0),pe.DEFICIENTE),83),
		'ParcelaDependente' = isnull((SELECT 
										eparceladepend 
									FROM tirs(nolock) 
									WHERE notab = (isnull(dbo.AddOn_GetIRSTable(pe2.casado,iif(pe2.casado=1,0,1),iif(pe.nfilhos>0,1,0),iif(pe.ntit>1,1,0),pe.DEFICIENTE),83)))
									,0),
		'ParcelaPorConjugeDefiente' = isnull((SELECT 
										eparcelaconjdefic 
									FROM tirs(nolock) 
									WHERE notab = (isnull(dbo.AddOn_GetIRSTable(pe2.casado,iif(pe2.casado=1,0,1),iif(pe.nfilhos>0,1,0),iif(pe.ntit>1,1,0),pe.DEFICIENTE),83)))
									,0),
		'ParcelaPorDependenteDeficiente' = isnull((SELECT 
										eparceladependdefic 
									FROM tirs(nolock) 
									WHERE notab = (isnull(dbo.AddOn_GetIRSTable(pe2.casado,iif(pe2.casado=1,0,1),iif(pe.nfilhos>0,1,0),iif(pe.ntit>1,1,0),pe.DEFICIENTE),83)))
									,0),
		'TbIRS' = pe.tabirs,
	
		'TxSSFun' = pe.txssp/100,
		'TxSSEmp' = pe.txsse/100,
		'OrdBase' = pe.ebasemes,
		'IHT'=pe.eviht,
		'SubRef' = pe.erefeicao,
		'DataAdmissao' = convert(char(12),pe.dataadm,104),
		'DataInicioContrato' = convert(char(12),pe.cinicio,104),
		'DataSaida' = (case when convert(char(10),pe.dataout,104)='01.01.1900' then '' else convert(char(10),pe.dataout,104) end),
		'HorasDia' = ISNULL(NULLIF(hdia, 0), 8),
		'HorasSemana' = ISNULL(NULLIF(hsemana, 0), 40)
	FROM pe(nolock) 
		LEFT JOIN pe2 On pe.pestamp=pe2.pe2stamp
	WHERE pe.status = 1 AND pe.u_interno=0 AND pe.dataadm<=@DataRecibo
		AND (pe.dataout='1900-01-01' OR month(pe.dataout)>=month(@DataRecibo) 
		AND year(pe.dataout)>=year(@DataRecibo))

)
GO
