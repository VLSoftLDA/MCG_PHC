SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[AnexosBinario]
(	
	@anexosstamp nvarchar(50)
)
RETURNS TABLE 
AS
RETURN 
(
SELECT
    LTRIM(RTRIM(resumo)) AS Anexo,
    LTRIM(RTRIM(fname)) AS Ficheiro,
   CAST('' AS XML).value('xs:base64Binary(sql:column("bdados"))', 'VARCHAR(MAX)') AS ConteudoB64
FROM (
    SELECT 
        resumo, 
        fname, 
        CAST(bdados AS VARBINARY(MAX)) AS bdados
    FROM anexos
    WHERE LTRIM(RTRIM(anexosstamp)) = LTRIM(RTRIM(@anexosstamp))
) AS T
)
GO
