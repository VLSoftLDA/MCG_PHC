SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_DiasSubsAlimentDespesas] 
(	
@Mes as Integer,
@Ano as Integer
)
RETURNS TABLE 
AS
RETURN 
(
SELECT 
  pe.nome AS [Nome],  -- Nome do funcionário
  pe.no AS [Nº Funcionário],  
  COUNT(*) AS [Dias a Descontar]
FROM dl
LEFT JOIN ds ON dl.dsstamp = ds.dsstamp
CROSS APPLY STRING_SPLIT(
    CASE 
      WHEN u_funint IS NOT NULL AND LTRIM(RTRIM(CAST(u_funint AS VARCHAR(MAX)))) <> '' THEN 
          CONCAT(CAST(u_funint AS VARCHAR(MAX)), ',', CAST(ds.no AS VARCHAR)) --junta u_funint com no
      ELSE 
          CAST(ds.no AS VARCHAR)
    END, 
    ',' 
) ss
LEFT JOIN pe ON pe.no = CAST(ss.value AS INT)
WHERE dl.tdsdesc = 'ALIMENTAÇÃO'
  AND MONTH(dl.data) = @Mes
  AND YEAR(dl.data) = @Ano 
GROUP BY pe.no, pe.nome  -- agrupa pelo numero de funcionario e nome

UNION ALL

-- total
SELECT 
  'TOTAL' AS [Nome],
  0 AS [Nº Funcionário],
  COUNT(*) AS [Dias a Descontar]
FROM dl
LEFT JOIN ds ON dl.dsstamp = ds.dsstamp
CROSS APPLY STRING_SPLIT(
    CASE 
      WHEN u_funint IS NOT NULL AND LTRIM(RTRIM(CAST(u_funint AS VARCHAR(MAX)))) <> '' THEN 
          CONCAT(CAST(u_funint AS VARCHAR(MAX)), ',', CAST(ds.no AS VARCHAR)) -- junta u_funint com no
      ELSE 
          CAST(ds.no AS VARCHAR)
    END, 
    ',' 
) ss
LEFT JOIN pe ON pe.no = CAST(ss.value AS INT)
WHERE dl.tdsdesc = 'ALIMENTAÇÃO'
  AND MONTH(dl.data) = @Mes
  AND YEAR(dl.data) = @Ano
)
GO
