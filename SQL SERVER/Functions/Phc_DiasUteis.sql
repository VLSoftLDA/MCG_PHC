SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_DiasUteis]
(
    @dtInicial Date,
    @dtFinal Date
)

RETURNS integer
AS
BEGIN
    RETURN (
				select
				(DATEDIFF(DAY, @dtInicial, @dtFinal) + 1)
				-(DATEDIFF(WEEK, @dtInicial, @dtFinal) * 2)
				-(CASE WHEN DATENAME(WEEKDAY, @dtInicial) = 'Sunday' THEN 1 ELSE 0 END)
				-(CASE WHEN DATENAME(WEEKDAY, @dtFinal) = 'Saturday' THEN 1 ELSE 0 END) 

    )
END
GO
