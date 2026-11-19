SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_DiasFeriado]
(
    @dtInicial Date,
    @dtFinal Date

)

RETURNS INTEGER
AS
BEGIN
	RETURN (
			select 
			isnull(sum(CASE WHEN DATEPART(dw, data) = 1 OR DATEPART(dw, data) = 7 THEN 0 ELSE 1 END),0)
			from ff (nolock)
			where data>=@dtInicial and dataf<=@dtFinal
	)
END
GO
