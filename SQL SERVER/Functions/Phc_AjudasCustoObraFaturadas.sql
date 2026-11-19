SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_AjudasCustoObraFaturadas]
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
					'Valor' = isnull(sum(fi.ETILIQUIDO),0) 
					from fi (nolock) 
					LEFT JOIN ft (nolock) ON ft.ftstamp = fi.ftstamp 
					LEFT JOIN ft2 (nolock) ON ft2.ft2stamp = ft.ftstamp
					where ft2.processo = @idObra and fi.ref='AJC' AND ft.anulado=0 AND ft.fdata BETWEEN @dtInicial AND @dtFinal
					)

	Return @valor
END
GO
