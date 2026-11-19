SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_DiasFerias]
(
	@workerNo integer,
    @dtInicial Date,
    @dtFinal Date
)

RETURNS INTEGER
AS
BEGIN
	RETURN (

			SELECT 
				isnull(SUM(iif(month(datai)=month(dataf),iif(dataf>@dtFinal,dias- datediff(day,@dtFinal,dataf),dias)
					,iif(month(datai)<> month(dataf),day(EOMONTH(@dtInicial,0))-day(datai)+1,0)
					)
					),0)
			FROM fp(nolock) 
			WHERE no=@workerNo and datai>=@dtInicial and datai<=@dtFinal

	)
END
GO
