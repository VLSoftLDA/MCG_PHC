SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_AjudasCustoObraPagas]
(
	@idObra Varchar(20),
    @dtInicial Date,
    @dtFinal Date

)

RETURNS DECIMAL(16,2)

AS

BEGIN
	DECLARE @valor AS DECIMAL(16,2) 

	Select @valor= (select 
					'Valor' = isnull(sum(total),0) 
					from U_XLSAjudasCusto(nolock) 
					where obra=@idObra and datarecibo between @dtInicial and @dtFinal
					)

	Return @valor
END
GO
