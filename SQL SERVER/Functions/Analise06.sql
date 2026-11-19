SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise06] 
(	
	@Ano int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
'Meivcore' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM sisPHCMeivcore.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Ambiente' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHMeivcoreAmbiente.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Autielvolt' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHAutielvolt.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Aveirisol' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHAveirisol.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Irocrew' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHIronCrew.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Isonewt' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHIsonewt.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Competition' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHMeivCompetition.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Meivstation' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHMeivStation.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Meivtraining' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHMeivTraining.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'Transforce' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHPondus.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'FMMV' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHFmmv.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

UNION ALL

SELECT
'RadikalWinds' as 'Empresa',
   no as 'Número'
   ,nome as 'Nome'
   ,sum(dias) AS 'Dias' 
FROM RHMeivCertification.dbo.pr (nolock)
WHERE year(data) =@Ano 
GROUP BY no, nome 

)
GO
