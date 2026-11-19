SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise08] 
(	
	@Ano int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
'Empresa' = 'Meivcore',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM sisPHCMeivcore.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM sisPHCMeivcore.dbo.pr(nolock) 
   inner join sisPHCMeivcore.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Ambiente',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHMeivcoreAmbiente.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHMeivcoreAmbiente.dbo.pr(nolock) 
   inner join RHMeivcoreAmbiente.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Autielvolt',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHAutielvolt.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHAutielvolt.dbo.pr(nolock) 
   inner join RHAutielvolt.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Aveirisol',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHAveirisol.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHAveirisol.dbo.pr(nolock) 
   inner join RHAveirisol.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Irocrew',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHIronCrew.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHIronCrew.dbo.pr(nolock) 
   inner join RHIronCrew.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Isonewt',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHIsonewt.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHIsonewt.dbo.pr(nolock) 
   inner join RHIsonewt.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Competition',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHMeivCompetition.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHMeivCompetition.dbo.pr(nolock) 
   inner join RHMeivCompetition.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Meivstation',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHMeivStation.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHMeivStation.dbo.pr(nolock) 
   inner join RHMeivStation.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Meivtraining',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHMeivTraining.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHMeivTraining.dbo.pr(nolock) 
   inner join RHMeivTraining.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'Transforce',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHPondus.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHPondus.dbo.pr(nolock) 
   inner join RHPondus.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'FMMV',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHFmmv.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHFmmv.dbo.pr(nolock) 
   inner join RHFmmv.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

UNION ALL

SELECT
'Empresa' = 'RadikalWinds',
'Funcionario'=pr.nome,
'Tipo' = prre.rem,
'Dias' = (SELECT sum(prx.dias) FROM RHMeivCertification.dbo.pr AS prx WHERE prx.no=pr.no AND year(prx.data)=@Ano),
'Quantidade' = sum(prre.rqtt),
'Total' = sum(prre.ervu)
FROM RHMeivCertification.dbo.pr(nolock) 
   inner join RHMeivCertification.dbo.prre(nolock) on pr.prstamp=prre.prstamp
where cr in (12,18) AND year(pr.data)=@Ano
group by pr.nome,prre.rem,pr.no

)
GO
