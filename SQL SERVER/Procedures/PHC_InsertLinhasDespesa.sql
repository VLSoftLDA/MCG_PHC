SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PHC_InsertLinhasDespesa]
	@dlstamp varchar(40),
	@lordem integer,
    @dsstamp varchar(40),
    @tipoDespesa varchar(50),
    @valorLinha decimal(18,2),
    @valorLinhaAPagar decimal(18,2),
	@taxaiva decimal(18,2),
    @obs text

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- ===============================
        -- TIPO DE DESPESA
        -- ===============================
        -- sem tdsstamp a linha fica fora dos limites do PHC_Upd_Despesas_DL_MW (JOIN tds), por isso aborta
        DECLARE @tdsstamp VARCHAR(30);

        SELECT TOP 1 @tdsstamp = tdsstamp FROM tds WHERE tds.descricao = @tipoDespesa;

        IF @tdsstamp IS NULL
            RAISERROR('Tipo de despesa "%s" não existe na tabela tds.', 16, 1, @tipoDespesa);

        -- ===============================
        -- INSERE NOVA LINHA
        -- ===============================
        INSERT INTO dl (
			dlstamp,
			lordem,
            dsstamp,
            tdsstamp,
			tdsdesc,
			eorivalor,
            evalor,
            eoriiva,
			eiva,
			tdstxiva,
            obs,
			ousrinis,
			ousrdata,
			ousrhora,
			usrinis,
			usrdata,
			usrhora

        )
        VALUES (
			@dlstamp,
			@lordem,
            @dsstamp,
            @tdsstamp,
            @tipoDespesa,
            @valorLinha,
            @valorLinhaAPagar,
            @valorLinha * (@taxaiva / 100),
			@valorLinhaAPagar * (@taxaiva / 100),
			@taxaiva,
            @obs,
			'MW',
            GETDATE(),
            CONVERT(VARCHAR(8), GETDATE(), 108),
			'MW',
            GETDATE(),
            CONVERT(VARCHAR(8), GETDATE(), 108)
        );

		    UPDATE ds
				SET
				evalor = (
					SELECT ISNULL(SUM(evalor), 0)
					FROM dl
					WHERE dsstamp = @dsstamp
				),
				eorivalor = (
					SELECT ISNULL(SUM(eorivalor), 0)
					FROM dl
					WHERE dsstamp = @dsstamp
				)
				WHERE dsstamp = @dsstamp;

    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000), @ErrNo INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrNo = ERROR_NUMBER();
        RAISERROR('Erro ao inserir linhas da despesa: %s', 16, 1, @ErrMsg);
    END CATCH

END
GO
