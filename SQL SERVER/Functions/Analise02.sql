SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise02] 
(	
	-- Add the parameters for the function here
	@Ano int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
'Empresa' = 'Meivcore',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM sisPHCMeivcore.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM sisPHCMeivcore.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM sisPHCMeivcore.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Ambiente',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHMeivcoreAmbiente.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHMeivcoreAmbiente.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHMeivcoreAmbiente.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Autielvolt',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHAutielvolt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHAutielvolt.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHAutielvolt.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Aveirisol',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHAveirisol.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHAveirisol.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHAveirisol.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Irocrew',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHIronCrew.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHIronCrew.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHIronCrew.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Isonewt',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHIsonewt.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHIsonewt.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHIsonewt.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Competition',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHMeivCompetition.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHMeivCompetition.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHMeivCompetition.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Meivstation',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHMeivStation.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHMeivStation.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHMeivStation.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Meivtraining',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHMeivTraining.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHMeivTraining.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHMeivTraining.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'Transforce',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHPondus.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHPondus.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHPondus.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'FMMV',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHFmmv.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHFmmv.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHFmmv.dbo.pr WHERE year(pr.data)=@Ano)

UNION ALL

SELECT 
'Empresa' = 'RadikalWinds',
'Número' = rtrim(convert(char(10),pe.no)),
'Funcionário' =pe.nome,
'JANEIRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=1 AND year(pr.data)=@Ano),
'FEVEREIRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=2 AND year(pr.data)=@Ano),
'MARÇO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=3 AND year(pr.data)=@Ano),
'ABRIL' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=4 AND year(pr.data)=@Ano),
'MAIO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=5 AND year(pr.data)=@Ano),
'JUNHO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=6 AND year(pr.data)=@Ano),
'JULHO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=7 AND year(pr.data)=@Ano),
'AGOSTO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=8 AND year(pr.data)=@Ano),
'SETEMBRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=9 AND year(pr.data)=@Ano),
'OUTUBRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=10 AND year(pr.data)=@Ano),
'NOVEMBRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=11 AND year(pr.data)=@Ano),
'DEZEMBRO' =  (SELECT count(*) FROM RHMeivCertification.dbo.pr WHERE pr.no=pe.no AND month(pr.data)=12 AND year(pr.data)=@Ano)
FROM RHMeivCertification.dbo.pe (nolock)
WHERE pe.no IN (SELECT DISTINCT no FROM RHMeivCertification.dbo.pr WHERE year(pr.data)=@Ano)



)
GO
