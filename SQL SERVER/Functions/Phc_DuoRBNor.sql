SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_DuoRBNor]
(
	@prstamp as varchar(30)
)

RETURNS DECIMAL(16,2)

AS

BEGIN
	DECLARE @valor AS DECIMAL(16,2) 

	Select @valor= (cast(isnull((
								select sum(ere) 
								from prre 
									inner join cm6 on prre.cr=cm6.cm
									inner join pr on prre.prstamp=pr.prstamp
								where pr.codigo<>1 and pr.prstamp=@prstamp and (cm6.debnor=(select cm6.debnor from cm6 where cm=1))),0) 
					 as decimal(10,2))
					)/12
					+
				    (cast(isnull((
								select -1*sum(ede) 
								from prde 
									inner join cm6 on prde.cd=cm6.cm
									inner join pr on prde.prstamp=pr.prstamp
								where pr.codigo<>1 and pr.prstamp=@prstamp and (cm6.crenor=(select cm6.debnor from cm6 where cm=1))),0) 
					 as decimal(10,2))
					)/12

	Return @valor
END
GO
