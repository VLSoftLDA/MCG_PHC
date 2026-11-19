SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PHC_Web_JobWorkerHours]
	-- Add the parameters for the stored procedure here
      @DataInicial date
	 ,@DataFinal date 
	 
AS
BEGIN
	DELETE FROM aaa_tmpWorkersTS

	SELECT 
		dbo.Phc_DiasUteis(@DataInicial,@DataFinal)-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal) as diasUteis,
		(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as horasUteisPeriodo
END
GO
