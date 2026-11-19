SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise03] 
(	
	@DataInicial date,
	@DataFinal date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
	'Empresa' = 'Meivcore',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM sisPHCMeivcore.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM sisPHCMeivcore.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Ambiente',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHMeivcoreAmbiente.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHMeivcoreAmbiente.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Autielvolt',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHAutielvolt.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHAutielvolt.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Aveirisol',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHAveirisol.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHAveirisol.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Irocrew',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHIronCrew.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHIronCrew.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Isonewt',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHIsonewt.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHIsonewt.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Competition',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHMeivCompetition.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHMeivCompetition.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Meivstation',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHMeivStation.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHMeivStation.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Meivtraining',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHMeivTraining.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHMeivTraining.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'Transforce',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHPondus.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHPondus.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'FMMV',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHFmmv.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHFmmv.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1

UNION ALL

SELECT 
	'Empresa' = 'RadikalWinds',
    'Número' = pe.no,
    'Nome' = pe.nome,
    'Nº SS' = pe.nbenef
FROM RHMeivCertification.dbo.pe (nolock)
WHERE pe.no NOT IN (SELECT no FROM RHMeivCertification.dbo.pr WHERE  pr.data BETWEEN @DataInicial AND @DataFinal)
AND pe.status=1
)
GO
