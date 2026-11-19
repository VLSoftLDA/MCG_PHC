SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_CompaniesSalaries]
(
    @Mes int
    ,@Ano int
)

RETURNS TABLE 
AS
RETURN 
(
	
	SELECT 'Autielvolt' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHAutielvolt].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Aveirisol' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHAveirisol].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'FMMV' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHFmmv].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'IronCrew' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHIronCrew].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Isonewt' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHIsonewt].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'MeivAmbiente' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHMeivcoreAmbiente].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'MeivCertification' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHMeivCertification].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'MeivCompetion' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHMeivCompetition].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Meivcore' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [sisPHCMeivcore].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'MeivStation' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHMeivStation].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'MeivTraining' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHMeivTraining].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Pondus' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHPondus].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'SLM' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHSlm].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Termiso' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHTermiso].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 
	UNION ALL
	SELECT 'Tubogal' as 'Empresa', count(*) AS 'Recibos emitidos' FROM [RHTubogal].dbo.pr WHERE year(data)=@Ano and month(data)=@Mes 

)
GO
