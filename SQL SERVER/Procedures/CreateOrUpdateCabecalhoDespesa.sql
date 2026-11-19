SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[CreateOrUpdateCabecalhoDespesa]
(
    @dsstamp        VARCHAR(50),
    @nifColaborador VARCHAR(20),
    @dataDespesa    date,   -- formato yyyymmdd
    @paisDespesa    VARCHAR(50),
    @obra           VARCHAR(50),
    @nifDocumento   VARCHAR(20),
    @documento      VARCHAR(50),
    @nifFornecedor  VARCHAR(20),
    @tipoPagamento  VARCHAR(50),
    @descricao      VARCHAR(255),
    @funcInternos   VARCHAR(MAX),
    @noFuncExt      INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Obter dados do colaborador
    DECLARE @no INT,
            @nome VARCHAR(200),
            @u_semlimit BIT

    SELECT TOP 1
        @no = pe.no,
        @nome = pe.nome,
        @u_semlimit = pe2.u_semlimit
    FROM pe
    LEFT JOIN pe2 ON pe.pestamp = pe2.pe2stamp
    WHERE pe2.cval1 = @nifColaborador

    -- Se não existir colaborador, aborta
    IF @no IS NULL
    BEGIN
        RAISERROR('Colaborador não encontrado.',16,1)
        RETURN
    END


    -- Verificar se já existe dsstamp
    IF EXISTS (SELECT 1 FROM ds WHERE dsstamp = @dsstamp)
    BEGIN

        UPDATE ds
        SET
            no          = @no,
            nome        = @nome,
            data        = @dataDespesa,
            descricao   = @descricao,
            usrinis     = 'MW',
            usrdata     = GETDATE(),
            usrhora     = CONVERT(VARCHAR(8), GETDATE(), 108),
            u_descpais  = @paisDespesa,
            u_tipopgm   = @tipoPagamento,
            u_funint    = @funcInternos,
            u_nfunext   = @noFuncExt,
            u_obra      = @obra,
            u_document  = @documento,
            u_semlimit  = @u_semlimit,
            u_contforn  = @nifFornecedor
        WHERE dsstamp = @dsstamp

    END
    ELSE
    BEGIN

        --------------------------------------------------------
        -- INSERT
        --------------------------------------------------------
        INSERT INTO ds
        (
            dsstamp, no, nome, data, descricao,
            ousrinis, ousrdata, ousrhora,
            usrinis, usrdata, usrhora,
            u_descpais, u_tipopgm, u_funint, u_nfunext,
            u_obra, u_document, u_semlimit, u_contforn
        )
        VALUES
        (
            @dsstamp,
            @no,
            @nome,
            @dataDespesa,
            @descricao,
            'MW',
            GETDATE(),
            CONVERT(VARCHAR(8), GETDATE(), 108),
            'MW',
            GETDATE(),
            CONVERT(VARCHAR(8), GETDATE(), 108),
            @paisDespesa,
            @tipoPagamento,
            @funcInternos,
            @noFuncExt,
            @obra,
            @documento,
            @u_semlimit,
            @nifFornecedor
        )

    END

END
GO
