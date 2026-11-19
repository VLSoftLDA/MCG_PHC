SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_Upd_Despesas_DL_MW]
    @pais varchar(50),
    @obra varchar(100),
    @matricula varchar(100),
    @tipopagamento varchar(100),
    @aprovpagamento bit,
    @noext integer,
    @funcinternos varchar(5000),
    @despesasap varchar(10),
    @despesasap2 varchar(10),
    @taxaiva numeric(10,2),
    @temaut bit,
    @deuaut varchar(100),
    @obs text,
    @dlstamp varchar(30)
AS
BEGIN
    SET NOCOUNT ON;


     --  DECLARAÇÕES

    DECLARE
        @valorLimiteRefeicaoForaPortugal DECIMAL(10,2),
        @valorLimiteRefeicaoAlmoco DECIMAL(10,2),
        @valorLimiteRefeicaoJantar DECIMAL(10,2),
        @valorLimiteRefeicaoLanche DECIMAL(10,2),
        @valorLimiteEpi DECIMAL(10,2),
		@valorLimiteLancheForaPortugal DECIMAL(10,2),

        @valorAtual DECIMAL(10,2),
        @valorTotalPorTipo DECIMAL(10,2),
        @valorLimite DECIMAL(10,2),

        @tipoDespesa VARCHAR(100),
        @dsstamp VARCHAR(30),
        @tdsstamp VARCHAR(30),
        @paisds VARCHAR(50),
        @noextds INT,
        @nfunint INT,
        @funcSemLimites BIT,
        @tipopagamentocab VARCHAR(100),

        @aplicaLimite BIT = 1;


     --  UPDATE CAMPOS FIXOS

    UPDATE dl
    SET
        u_viatura   = @matricula,
        u_aprovpag = @aprovpagamento,
        u_despsap  = @despesasap,
        u_despsap2 = @despesasap2,
        tdstxiva   = @taxaiva,
        eoriiva    = eorivalor * (@taxaiva / 100),
        eiva       = evalor * (@taxaiva / 100),
        u_temaut   = @temaut,
        u_deuaut   = @deuaut,
        obs        = @obs
    WHERE dlstamp = @dlstamp;


     --  ATUALIZA FUNCIONÁRIOS INTERNOS

    UPDATE ds
    SET u_funint = COALESCE(newlist.u_funint, '')
    FROM ds
    CROSS APPLY (
        SELECT STRING_AGG(value, ',') AS u_funint
        FROM STRING_SPLIT(LTRIM(RTRIM(CAST(ds.u_funint AS VARCHAR(MAX)))), ',')
        WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) <> ds.no
    ) newlist
    WHERE ds.dsstamp = (
        SELECT dl.dsstamp FROM dl WHERE dlstamp = @dlstamp
    );


     --  LIMITES (TABELA E2)

    SELECT @valorLimiteRefeicaoForaPortugal = nvalor FROM e2 WHERE e1lino = 1 AND e1cano = 1000 AND ano = 2025;
    SELECT @valorLimiteRefeicaoAlmoco        = nvalor FROM e2 WHERE e1lino = 2 AND e1cano = 1000 AND ano = 2025;
    SELECT @valorLimiteRefeicaoJantar        = nvalor FROM e2 WHERE e1lino = 3 AND e1cano = 1000 AND ano = 2025;
    SELECT @valorLimiteEpi                   = nvalor FROM e2 WHERE e1lino = 4 AND e1cano = 1000 AND ano = 2025;
    SELECT @valorLimiteRefeicaoLanche        = nvalor FROM e2 WHERE e1lino = 5 AND e1cano = 1000 AND ano = 2025;
	SELECT @valorLimiteLancheForaPortugal	 = nvalor FROM e2 WHERE e1lino = 6 AND e1cano = 1000 AND ano = 2025;


     --  DADOS DA DESPESA

    SELECT
        @valorAtual = dl.evalor,
        @tdsstamp  = dl.tdsstamp,
        @tipoDespesa = TRIM(tds.descricao),
        @dsstamp   = dl.dsstamp,
        @paisds    = TRIM(ds.u_descpais),
        @noextds   = ds.u_nfunext,
        @nfunint   = (
            SELECT COUNT(*)
            FROM STRING_SPLIT(LTRIM(RTRIM(CAST(ds.u_funint AS VARCHAR(MAX)))), ',')
            WHERE LTRIM(RTRIM(value)) <> ''
              AND LTRIM(RTRIM(value)) <> CAST(ds.no AS VARCHAR(10))
        ),
        @funcSemLimites = ds.u_semlimit,
        @tipopagamentocab = TRIM(ds.u_tipopgm)
    FROM dl
    JOIN ds  ON ds.dsstamp = dl.dsstamp
    JOIN tds ON tds.tdsstamp = dl.tdsstamp
    WHERE dl.dlstamp = @dlstamp;


   -- GARANTIR QUE evalor NÃO EXCEDE eorivalor (valor a pagar nao excede valor da despesa)
	UPDATE dl
	SET evalor = eorivalor
	WHERE dsstamp = @dsstamp
	  AND tdsstamp = @tdsstamp
	  AND evalor > eorivalor;

    -- SOMATÓRIO POR TIPO
    SELECT @valorTotalPorTipo = ISNULL(SUM(evalor), 0)
    FROM dl
    WHERE dsstamp = @dsstamp
      AND tdsstamp = @tdsstamp and dl.u_temaut=0;


      -- EXCEÇÕES (SEM LIMITES)

    IF (@funcSemLimites = 1)
       OR (@tipopagamentocab = 'Cartão da Empresa')
       OR (@temaut = 1)
    BEGIN
        SET @aplicaLimite = 0;
    END


     --  CÁLCULO DO LIMITE
    IF @aplicaLimite = 1
    BEGIN
        IF @tipoDespesa IN ('ALMOÇO','P.ALMOÇO/LANCHE','JANTAR')
		--IF @tipoDespesa IN ('ALMOÇO','JANTAR') AND @noextds = 0
        BEGIN
			IF @noextds > 0
			BEGIN
				SET @aplicaLimite = 0;
			END
			ELSE
			BEGIN
				IF @paisds = 'Portugal'
				BEGIN
					IF @tipoDespesa = 'ALMOÇO'
						SET @valorLimite = @valorLimiteRefeicaoAlmoco * (@nfunint + 1);
					ELSE IF @tipoDespesa = 'P.ALMOÇO/LANCHE'
						SET @valorLimite = @valorLimiteRefeicaoLanche * (@nfunint + 1);
					ELSE IF  @tipoDespesa = 'JANTAR'
						SET @valorLimite = @valorLimiteRefeicaoJantar * (@nfunint + 1);
				END
				ELSE
				BEGIN
					IF @tipoDespesa = 'P.ALMOÇO/LANCHE'
						SET @valorLimite = @valorLimiteLancheForaPortugal * (@nfunint + 1);
					ELSE
						SET @valorLimite = @valorLimiteRefeicaoForaPortugal * (@nfunint + 1);
				END
			END
        END
        ELSE IF @tipoDespesa = 'EPI'
        BEGIN
            SET @valorLimite = @valorLimiteEpi;
        END
        ELSE
        BEGIN
            SET @aplicaLimite = 0;
        END
    END


       -- UPDATE DO EVALOR (CONTROLADO)
    IF @aplicaLimite = 1
       AND @valorTotalPorTipo > @valorLimite
    BEGIN
        UPDATE dl
        SET evalor = ROUND((evalor / @valorTotalPorTipo) * @valorLimite, 2)
        WHERE dsstamp = @dsstamp
          AND tdsstamp = @tdsstamp and dl.u_temaut=0;
    END

	--UPDATE IVAS
	-- cada linha usa a sua própria taxa (tdstxiva): o mesmo tipo pode ter linhas com taxas de IVA diferentes
     UPDATE dl
        SET
            eiva = evalor * (tdstxiva / 100),
            eoriiva = eorivalor * (tdstxiva / 100)
        WHERE dsstamp = @dsstamp
          AND tdsstamp = @tdsstamp;

    -- TOTAL DO CABEÇALHO
    UPDATE ds
    SET evalor = (
        SELECT ISNULL(SUM(evalor), 0)
        FROM dl
        WHERE dsstamp = @dsstamp
    )
    WHERE dsstamp = @dsstamp;

END
GO
