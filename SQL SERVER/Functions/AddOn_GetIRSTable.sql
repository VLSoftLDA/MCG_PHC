SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AddOn_GetIRSTable]
(
	 @Casado integer,
	 @NaoCasado integer,
	 @Dependentes integer,
	 @DoisTitulares integer,
	 @TitularDeficiente integer
)

RETURNS Varchar(50) 

AS

BEGIN
	RETURN (
			
			SELECT 
				notab
			FROM tirs(nolock) 
			WHERE Ano=2025 and tabela=1 
				and (naocasado=@NaoCasado or casado=@casado)
				and doistitulares = @DoisTitulares
				and dependentes = @Dependentes
				and deficiente = @TitularDeficiente
		)
END
GO
