SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_ShowLog]
(
	@stamp Varchar(25)
)

RETURNS TABLE

AS

RETURN

(
	SELECT 
	'Utilizador' = usercode,
	'Data' = data,
	'Hora' = hora,
	'Descrição' = descricao,
	'Tipo' = tipo,
	'Texto' = convert(varchar(254),texto),
	'Data Real' = datetimerow,
	'Tabela' = tabnom
	FROM nlog(nolock)
	WHERE tabstamp=@stamp
)
GO
