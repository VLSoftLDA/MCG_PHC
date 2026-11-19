SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_MCG_WorkersYearCost]
(
     @Ano int
)

RETURNS TABLE 
AS
RETURN 
(
	SELECT 'Meivcore' as 'Empresa', T0.* FROM  sisPHCMeivcore.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Ambiente' as 'Empresa', T0.* FROM  RHMeivcoreAmbiente.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Autielvolt' as 'Empresa', T0.* FROM  RHAutielvolt.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Aveirisol' as 'Empresa', T0.* FROM  RHAveirisol.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Irocrew' as 'Empresa', T0.* FROM  RHIronCrew.dbo.Phc_WorkersYearCost(@Ano)T0
	UNION ALL
	SELECT 'Isonewt' as 'Empresa', T0.* FROM  RHIsonewt.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Competition' as 'Empresa', T0.* FROM  RHMeivCompetition.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Meivstation' as 'Empresa', T0.* FROM  RHMeivStation.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Meivtraining' as 'Empresa', T0.* FROM  RHMeivTraining.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'Transforce' as 'Empresa', T0.* FROM  RHPondus.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'FMMV' as 'Empresa', T0.* FROM  RHFmmv.dbo.Phc_WorkersYearCost(@Ano) T0
	UNION ALL
	SELECT 'RadikalWinds' as 'Empresa', T0.* FROM  RHMeivCertification.dbo.Phc_WorkersYearCost(@Ano) T0
)
GO
