SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise07]
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
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM sisPHCMeivcore.dbo.prre(nolock)
       INNER JOIN sisPHCMeivcore.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from sisPHCMeivcore.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Ambiente',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHMeivcoreAmbiente.dbo.prre(nolock)
       INNER JOIN RHMeivcoreAmbiente.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHMeivcoreAmbiente.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Autielvolt',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHAutielvolt.dbo.prre(nolock)
       INNER JOIN RHAutielvolt.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHAutielvolt.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Aveirisol',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHAveirisol.dbo.prre(nolock)
       INNER JOIN RHAveirisol.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHAveirisol.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Irocrew',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHIronCrew.dbo.prre(nolock)
       INNER JOIN RHIronCrew.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHIronCrew.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Isonewt',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHIsonewt.dbo.prre(nolock)
       INNER JOIN RHIsonewt.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHIsonewt.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Competition',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHMeivCompetition.dbo.prre(nolock)
       INNER JOIN RHMeivCompetition.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHMeivCompetition.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Meivstation',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHMeivStation.dbo.prre(nolock)
       INNER JOIN RHMeivStation.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHMeivStation.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Meivtraining',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHMeivTraining.dbo.prre(nolock)
       INNER JOIN RHMeivTraining.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHMeivTraining.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'Transforce',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHPondus.dbo.prre(nolock)
       INNER JOIN RHPondus.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHPondus.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'FMMV',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHFmmv.dbo.prre(nolock)
       INNER JOIN RHFmmv.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHFmmv.dbo.cm6 where codhe=1)
GROUP BY pr.nome

UNION ALL

SELECT
	'Empresa' = 'RadikalWinds',
    'Funcionario' = pr.nome,
     'Qtt' = sum(prre.rqtt),
      'Valor' = sum(prre.ere)
FROM RHMeivCertification.dbo.prre(nolock)
       INNER JOIN RHMeivCertification.dbo.pr(nolock) ON prre.prstamp=pr.prstamp
WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>'' AND prre.cr IN (select cm from RHMeivCertification.dbo.cm6 where codhe=1)
GROUP BY pr.nome

)
GO
