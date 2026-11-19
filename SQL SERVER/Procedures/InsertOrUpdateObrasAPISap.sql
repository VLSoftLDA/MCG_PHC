SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertOrUpdateObrasAPISap]
    @ccusto NVARCHAR(50),
    @designacao NVARCHAR(200),
    @canceled NVARCHAR(50),
    @jobstatus NVARCHAR(80),
    @workernif NVARCHAR(80),
    @createdate DATETIME,
    @startdate DATETIME,
    @enddate DATETIME,
    @invoiceclosedate DATETIME,
    @bd NVARCHAR(80)
AS
BEGIN
    -- Declarar variável para 'inactivo'
    DECLARE @inactivo BIT;
    DECLARE @cctstamp NVARCHAR(50);

    IF @canceled = 'Y'
    BEGIN
        SET @inactivo = 1;
    END
    ELSE
    BEGIN
        SET @inactivo = 0;
    END

    -- Verifica se a obra já existe
    IF EXISTS (SELECT 1 FROM cct WHERE TRIM(ccusto) = @ccusto)
    BEGIN

		SET @cctstamp = (select cctstamp from cct WHERE ccusto = @ccusto )

        -- Se já existe a obra, faz o UPDATE
        UPDATE cct
        SET
            u_design = @designacao,
            inactivo = @inactivo,
            u_sapstat = @jobstatus,
            u_gestnif = @workernif,
            u_cdate = @createdate,
            u_stdate = @startdate,
            u_enddate = @enddate,
            u_invcdate = @invoiceclosedate
        WHERE ccusto = @ccusto;

        -- Log do UPDATE
        --EXEC [MCGRHObras].[dbo].[InsertLogObras]
        --    @stamp = @cctstamp, 
        --    @cct = @ccusto, 
        --    @tipo = 'update', 
        --    @bd = @bd;
    END
    ELSE
    BEGIN

		SET @cctstamp = LEFT(NEWID(), 5) + RIGHT(NEWID(), 5) + LEFT(NEWID(), 5) + RIGHT(NEWID(), 5);

        -- Se não existe a obra, faz o INSERT
        INSERT INTO cct (cctstamp, ccusto, u_design, inactivo, u_sapstat, u_gestnif, u_cdate, u_stdate, u_enddate, u_invcdate)
        VALUES (
            @cctstamp, 
            @ccusto, 
            @designacao, 
            @inactivo, 
            @jobstatus, 
            @workernif, 
            @createdate, 
            @startdate, 
            @enddate, 
            @invoiceclosedate
        );

        -- Log do INSERT
        --EXEC [MCGRHObras].[dbo].[InsertLogObras]
        --    @stamp = @cctstamp, 
        --    @cct = @ccusto, 
        --    @tipo = 'insert', 
        --    @bd = @bd;
    END
END;
GO
