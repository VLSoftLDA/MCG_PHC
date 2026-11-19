SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_TwelfthSalary]
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
								where (cm6.codbase=1 or cm6.iht=1) and prre.prstamp=@prstamp),0) 
					 as decimal(10,2))
					)/12

	Return @valor
END
GO
