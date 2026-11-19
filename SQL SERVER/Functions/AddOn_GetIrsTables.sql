SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AddOn_GetIrsTables]
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT
        'Stamp' = T0.tirsstamp,
	    'Numero' = T0.notab,
	    'Nome' = ltrim(rtrim(T0.nometab)),
	    'Ano' = T0.ano,
	    'Casado' = iif(T0.casado=1,'Sim','Não'),
	    'NaoCasado' = iif(T0.naocasado=1,'Sim','Não'),
	    'Titulares' = iif(T0.doistitulares=1,2,1),
	    'TemDepedentes' = iif(T0.dependentes=1,'Sim','Não'),
	    'TitularDeficiente' = iif(T0.deficiente=1,'Sim','Não'),
	    'ParcelaPorDependente' = T0.eparceladepend,
	    'ParcelaPorConjugeDefiente' = T0.eparcelaconjdefic,
	    'ParcelaPorDependenteDeficiente' = T0.eparceladependdefic
    FROM tirs(nolock) as T0
    WHERE Ano=2025 and tabela=1 
    --ORDER BY T0.notab
)
GO
