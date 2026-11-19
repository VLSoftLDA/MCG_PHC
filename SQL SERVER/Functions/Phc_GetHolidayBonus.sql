SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_GetHolidayBonus]
(
	@prstamp Varchar(30)
)

RETURNS DECIMAL(16,2)

AS

BEGIN
	DECLARE @valor AS DECIMAL(16,2) 

	Select @valor= (cast(isnull((
								select sum(ere) 
								from prre 
									inner join cm6 on prre.cr=cm6.cm
									inner join pr on pr.prstamp=prre.prstamp
								where cm6.ferias=1 and prre.prstamp=@prstamp),0)
					 as decimal(10,2))
					)

	Return @valor
END;
GO
