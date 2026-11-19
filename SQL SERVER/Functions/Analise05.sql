SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise05]
(	
	@DataInicial date,
	@DataFinal date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT DISTINCT
'Empresa' = 'Meivcore',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM sisPHCMeivcore.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM sisPHCMeivcore.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM sisPHCMeivcore.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM sisPHCMeivcore.dbo.pr (nolock)
	INNER JOIN  sisPHCMeivcore.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  sisPHCMeivcore.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN sisPHCMeivcore.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL

SELECT DISTINCT
'Empresa' = 'Ambiente',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHMeivcoreAmbiente.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHMeivcoreAmbiente.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHMeivcoreAmbiente.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHMeivcoreAmbiente.dbo.pr (nolock)
	INNER JOIN  RHMeivcoreAmbiente.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHMeivcoreAmbiente.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHMeivcoreAmbiente.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Autielvolt',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHAutielvolt.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHAutielvolt.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHAutielvolt.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHAutielvolt.dbo.pr (nolock)
	INNER JOIN  RHAutielvolt.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHAutielvolt.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHAutielvolt.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Aveirisol',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHAveirisol.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHAveirisol.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHAveirisol.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHAveirisol.dbo.pr (nolock)
	INNER JOIN  RHAveirisol.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHAveirisol.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHAveirisol.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Irocrew',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHIronCrew.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHIronCrew.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHIronCrew.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHIronCrew.dbo.pr (nolock)
	INNER JOIN  RHIronCrew.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHIronCrew.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHIronCrew.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Isonewt',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHIsonewt.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHIsonewt.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHIsonewt.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHIsonewt.dbo.pr (nolock)
	INNER JOIN  RHIsonewt.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHIsonewt.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHIsonewt.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Competition',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHMeivCompetition.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHMeivCompetition.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHMeivCompetition.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHMeivCompetition.dbo.pr (nolock)
	INNER JOIN  RHMeivCompetition.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHMeivCompetition.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHMeivCompetition.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Meivstation',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHMeivStation.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHMeivStation.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHMeivStation.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHMeivStation.dbo.pr (nolock)
	INNER JOIN  RHMeivStation.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHMeivStation.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHMeivStation.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Meivtraining',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHMeivTraining.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHMeivTraining.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHMeivTraining.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHMeivTraining.dbo.pr (nolock)
	INNER JOIN  RHMeivTraining.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHMeivTraining.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHMeivTraining.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'Transforce',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHPondus.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHPondus.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHPondus.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHPondus.dbo.pr (nolock)
	INNER JOIN  RHPondus.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHPondus.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHPondus.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'FMMV',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHFmmv.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHFmmv.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHFmmv.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHFmmv.dbo.pr (nolock)
	INNER JOIN  RHFmmv.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHFmmv.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHFmmv.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal

UNION ALL
SELECT DISTINCT
'Empresa' = 'RadikalWinds',
'Numero' = pe.no,
'Nome' = pe.nome,
'Nif' = pe.NCONT,
'Função' = pe.CCPROFISS,
'TipoContrato' = pe.tcontr,
--'DataEntrada' = pe.DATAADM,
'DataInicio' = isnull((SELECT TOP 1 datainicontrato FROM RHMeivCertification.dbo.hp(nolock) WHERE hp.no=pe.no AND datainicontrato <@DataFinal ORDER BY datainicontrato DESC),0),
'DataSaida' = isnull((SELECT TOP 1 datafimcontrato FROM RHMeivCertification.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0),
'MotivoSaida' = isnull((SELECT TOP 1 descmotivossaid FROM RHMeivCertification.dbo.hp(nolock) WHERE hp.no=pe.no AND datafimcontrato>@DataInicial ORDER BY datafimcontrato),0)
FROM RHMeivCertification.dbo.pr (nolock)
	INNER JOIN  RHMeivCertification.dbo.pe (nolock) ON pe.no=pr.no 
	INNER JOIN  RHMeivCertification.dbo.pe2 (nolock) ON pe2.pe2stamp=pe.pestamp
	LEFT JOIN RHMeivCertification.dbo.hp(nolock) ON pe.no=hp.no
WHERE pr.data between @DataInicial AND @DataFinal
)
GO
