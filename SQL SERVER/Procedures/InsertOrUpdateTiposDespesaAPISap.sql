SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertOrUpdateTiposDespesaAPISap]
    @tipodespesa NVARCHAR(50),
    @designacao NVARCHAR(200),
    @grupoiva NVARCHAR(50),
    @nomeiva NVARCHAR(200),
    @conta NVARCHAR(200),
    @ivapercent NUMERIC(15,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @tdstamp NVARCHAR(50);

    -- Normalizar o código vindo do SAP (mantém maiúsculas/minúsculas)
    SET @tipodespesa = TRIM(@tipodespesa);

    -- Procura o tipo despesa com comparação binária (distingue Cb10 de CB10, acentos, largura, etc.)
    SELECT TOP 1 @tdstamp = TRIM(tdstamp)
    FROM aa_ds_sap
    WHERE TRIM(tipo) COLLATE Latin1_General_BIN2 = @tipodespesa COLLATE Latin1_General_BIN2;

    IF @tdstamp IS NOT NULL
    BEGIN
        -- Se já existe tipo despesa, faz o UPDATE
        UPDATE aa_ds_sap
        SET
            tipo = @tipodespesa,
            nome = @designacao,
            grupo_iva = @grupoiva,
            nome_iva = @nomeiva,
            conta = @conta,
            taxa_iva = @ivapercent
        WHERE tdstamp = @tdstamp;

        -- Log do UPDATE
        --EXEC [MCGRHObras].[dbo].[InsertLogObras]
        --    @stamp = @cctstamp, 
        --    @cct = @ccusto, 
        --    @tipo = 'update', 
        --    @bd = @bd;
    END
    ELSE
    BEGIN
        SET @tdstamp = LEFT(NEWID(), 5) + RIGHT(NEWID(), 5) + LEFT(NEWID(), 5) + RIGHT(NEWID(), 5);

        -- Se não existe o tipo despesa, faz o INSERT
        INSERT INTO aa_ds_sap (tdstamp, tipo, nome, grupo_iva, nome_iva, conta, taxa_iva)
        VALUES (@tdstamp, @tipodespesa, @designacao, @grupoiva, @nomeiva, @conta, @ivapercent);

        -- Log do INSERT
        --EXEC [MCGRHObras].[dbo].[InsertLogObras]
        --    @stamp = @cctstamp, 
        --    @cct = @ccusto, 
        --    @tipo = 'insert', 
        --    @bd = @bd;
    END
END;
GO
