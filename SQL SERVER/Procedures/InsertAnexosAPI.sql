SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertAnexosAPI] 
    @nif VARCHAR(50),
    @titulo_ficheiro VARCHAR(100),
    @nome_ficheiro VARCHAR(100),
    @extensao VARCHAR(20),
    @conteudo_anexo IMAGE,
    @u_idapi INTEGER,
	@bd VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @stamp VARCHAR(50);
	SELECT @stamp = trim((SELECT LEFT(NEWID(), 5) + RIGHT(NEWID(), 5) + LEFT(NEWID(), 5) + RIGHT(NEWID(), 5)));

    -- Verifica se o u_idapi já existe na tabela anexos e se existe o funcionario com o nif associado ao documento
    IF (NOT EXISTS (SELECT 1 FROM anexos WHERE u_idapi = @u_idapi) and EXISTS (SELECT 1 FROM pe WHERE pe.ncont = trim(@nif)))
    BEGIN 
        INSERT INTO anexos(anexosstamp, oritable, tabnm, resumo, recstamp, bdados, fname, fext, flen, tipo, u_idapi)
        VALUES
        (   
            @stamp, 
            'PE',  
            'Funcionários',  
            TRIM(@titulo_ficheiro),  
            (SELECT TRIM(pestamp) FROM pe WHERE pe.ncont = @nif and (status<>3 or pe.no=8605) and status<>25),
            @conteudo_anexo,  
            TRIM(@nome_ficheiro),  
            TRIM(REPLACE(@extensao, '.', '')),
			DATALENGTH(@conteudo_anexo),
            1,  
            @u_idapi 
        )


		-- executar procedure 
		--DECLARE @noFuncionario INTEGER;
		--SELECT @noFuncionario = pe.no FROM pe WHERE pe.ncont = TRIM(@nif) and status<>3 and status<>25;

		--EXEC [MCGRHAssinaturas].[dbo].[InsertLogAnexos]
		--	@stamp = @stamp,
		--	@no = @noFuncionario,
		--	@nif = @nif,
		--	@titulo_ficheiro = @titulo_ficheiro,
		--	@nome_ficheiro = @nome_ficheiro,
		--	@u_idapi = @u_idapi,
		--	@bd = @bd;

    END
End


--select * from pe where ncont='111111111' and status<>3 and status<>25

--select * from pe where pestamp='b81-4ce4-892f-8ff2486176'
GO
