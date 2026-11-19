SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Analise38] 
(	
	@DataInicial date
    ,@DataFinal date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT  
'Empresa' = 'Meivcore',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM sisPHCMeivcore.dbo.prre(nolock) 
		INNER JOIN sisPHCMeivcore.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM sisPHCMeivcore.dbo.prde(nolock)  
		INNER JOIN sisPHCMeivcore.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  sisPHCMeivcore.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Ambiente',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHMeivcoreAmbiente.dbo.prre(nolock) 
		INNER JOIN RHMeivcoreAmbiente.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHMeivcoreAmbiente.dbo.prde(nolock)  
		INNER JOIN RHMeivcoreAmbiente.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHMeivcoreAmbiente.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Autielvolt',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHAutielvolt.dbo.prre(nolock) 
		INNER JOIN RHAutielvolt.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHAutielvolt.dbo.prde(nolock)  
		INNER JOIN RHAutielvolt.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHAutielvolt.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Aveirisol',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHAveirisol.dbo.prre(nolock) 
		INNER JOIN RHAveirisol.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHAveirisol.dbo.prde(nolock)  
		INNER JOIN RHAveirisol.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHAveirisol.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Irocrew',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHIronCrew.dbo.prre(nolock) 
		INNER JOIN RHIronCrew.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHIronCrew.dbo.prde(nolock)  
		INNER JOIN RHIronCrew.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHIronCrew.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Isonewt',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHIsonewt.dbo.prre(nolock) 
		INNER JOIN RHIsonewt.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHIsonewt.dbo.prde(nolock)  
		INNER JOIN RHIsonewt.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHIsonewt.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Competition',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHMeivCompetition.dbo.prre(nolock) 
		INNER JOIN RHMeivCompetition.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHMeivCompetition.dbo.prde(nolock)  
		INNER JOIN RHMeivCompetition.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHMeivCompetition.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Meivstation',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHMeivStation.dbo.prre(nolock) 
		INNER JOIN RHMeivStation.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHMeivStation.dbo.prde(nolock)  
		INNER JOIN RHMeivStation.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHMeivStation.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Meivtraining',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHMeivTraining.dbo.prre(nolock) 
		INNER JOIN RHMeivTraining.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHMeivTraining.dbo.prde(nolock)  
		INNER JOIN RHMeivTraining.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHMeivTraining.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'Transforce',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHPondus.dbo.prre(nolock) 
		INNER JOIN RHPondus.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHPondus.dbo.prde(nolock)  
		INNER JOIN RHPondus.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHPondus.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'FMMV',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHFmmv.dbo.prre(nolock) 
		INNER JOIN RHFmmv.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHFmmv.dbo.prde(nolock)  
		INNER JOIN RHFmmv.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHFmmv.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery

UNION ALL

SELECT  
'Empresa' = 'RadikalWinds',
* FROM (
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = prre.rem
	,'Valor' = sum(prre.ere)
	FROM RHMeivCertification.dbo.prre(nolock) 
		INNER JOIN RHMeivCertification.dbo.pr(nolock)  ON prre.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prre.rem<>''
	GROUP BY prre.rem,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = (case when prde.TXEXTMIRS = 1 then 'IRS - Sobretaxa' else prde.des end)
	,'Valor' = sum(prde.ede)
	FROM RHMeivCertification.dbo.prde(nolock)  
		INNER JOIN RHMeivCertification.dbo.pr(nolock)  ON prde.prstamp=pr.prstamp
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal AND prde.des<>''
	GROUP BY prde.des,prde.txextMirs,pr.codigo
	
	UNION ALL
	
	SELECT
	'Tipo' = case 
				when pr.codigo=1 then 'Gerência'
				when pr.codigo=3 then 'Produção'
				when pr.codigo=4 then '1º Emprego'
				else 'Normal'
			end
	,'Descrição' = 'Segurança social paga pela empresa'
	,'Valor' = SUM(pr.ESSEVALOR)
	FROM  RHMeivCertification.dbo.pr(nolock)  
	WHERE pr.data BETWEEN @DataInicial AND @DataFinal 
	GROUP BY pr.codigo
) subquery


)
GO
