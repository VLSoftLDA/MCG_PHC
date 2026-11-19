SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AtualizarLimitesDespesasEntreDatas]
    @DataInicio DATE,
    @DataFim DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        UPDATE dl
        SET dl.evalor = dl.orivalor
        FROM dl
        INNER JOIN ds ON dl.dsstamp = ds.dsstamp
        WHERE dl.tdsdesc IN ('ALMOÇO','P.ALMOÇO/LANCHE','JANTAR','EPI')
          AND ds.data >= @DataInicio
		  AND ds.data < DATEADD(DAY, 1, @DataFim)
		  AND NOT ((ds.u_semlimit = 1)
		   OR (TRIM(ds.u_tipopgm) = 'Cartão da Empresa')
		   OR (dl.u_temaut = 1)
		   OR ds.u_nfunext > 0)

        -- Cursor
        DECLARE @dlstamp VARCHAR(30);

        DECLARE cur CURSOR FOR
        SELECT dl.dlstamp
        FROM dl
        INNER JOIN ds ON dl.dsstamp = ds.dsstamp
        WHERE ds.data >= @DataInicio
          AND ds.data < DATEADD(DAY, 1, @DataFim)
		  AND NOT (
			(ds.u_semlimit = 1)
			OR (TRIM(ds.u_tipopgm) = 'Cartão da Empresa')
			OR (dl.u_temaut = 1)
			OR ds.u_nfunext > 0
		)
			AND u_aprovpag=0
			AND process=0;

        OPEN cur;
        FETCH NEXT FROM cur INTO @dlstamp;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC dbo.PHC_Upd_Despesas_DL_Web_Light @dlstamp;

            FETCH NEXT FROM cur INTO @dlstamp;
        END

        CLOSE cur;
        DEALLOCATE cur;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;

        DECLARE @Erro NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Erro, 16, 1);
    END CATCH
END;
GO
