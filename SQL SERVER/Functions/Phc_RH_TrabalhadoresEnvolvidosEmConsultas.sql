SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Nº de trabalhadores envolvidos em consultas sobre condições de trabalho e ESG
-- =============================================
CREATE FUNCTION [dbo].[Phc_RH_TrabalhadoresEnvolvidosEmConsultas]
(	
	@dataFimAno as Date
)
RETURNS TABLE 
AS
RETURN 
(
	select isnull(sum(total_trabalhadores),0) as 'Numero_Trabalhadores' from [dbo].[Phc_RH_TrabalhadoresGeneroEFaixaEtaria](@dataFimAno)
)
GO
