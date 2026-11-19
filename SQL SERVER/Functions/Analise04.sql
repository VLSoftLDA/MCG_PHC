SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise04]
(	
	@DataInicial date,
	@DataFinal date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
'Meivcore' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM sisPHCMeivcore.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Ambiente' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHMeivcoreAmbiente.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Autielvolt' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHAutielvolt.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Aveirisol' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHAveirisol.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Irocrew' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHIronCrew.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Isonewt' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHIsonewt.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Competition' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHMeivCompetition.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Meivstation' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHMeivStation.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Meivtraining' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHMeivTraining.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'Transforce' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHPondus.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'FMMV' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHFmmv.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

UNION ALL

SELECT
'RadikalWinds' as 'Empresa',
no as Numero,
nome as NOME,
morada AS MORADA,
NBENEF AS NSS,
NCONT AS NIF
FROM RHMeivCertification.dbo.pe (nolock)
WHERE DATAADM BETWEEN @DataInicial AND @DataFinal

)
GO
