SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_AjcHe_Processar]
    @WorkerTaxNumber VARCHAR(50),
    @SalaryPeriod    VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @Msg          VARCHAR(254),
        /* funcionário */
        @WorkerNumber INT,
        @WorkerName   VARCHAR(100),
        @MealValue    DECIMAL(10,2),
        @MealDesc     VARCHAR(100),
        @MealCod      INT,
        /* movimento corrente */
        @Seq          INT = 0,
        @StampAHE     VARCHAR(50),
        @Data         DATE,
        @DataRef      DATE,
        @DayName      VARCHAR(50),
        @Valor        DECIMAL(10,2),
        @Rotulo       VARCHAR(50),
        @Cr           INT,
        @HsheCod      INT,
        @Descr        VARCHAR(254),
        @Factor       DECIMAL(18,6),
        /* registo existente */
        @Existe       BIT,
        @ExDesign     VARCHAR(254),
        @ExData       CHAR(10),
        @ExTotal      DECIMAL(18,6),
        @ExNome       VARCHAR(100);

    DECLARE @Movs TABLE
    (
        Seq      INT IDENTITY(1,1) PRIMARY KEY,
        StampAHE VARCHAR(50),
        Data     DATE,
        DataRef  DATE,
        DayName  VARCHAR(50),
        Valor    DECIMAL(10,2),
        Rotulo   VARCHAR(50),
        Cr       INT NULL,          -- preenchido nas AJC
        HsheCod  INT NULL,          -- preenchido nas HE
        Descr    VARCHAR(254),
        Factor   DECIMAL(18,6)
    );

    DECLARE @Log TABLE
    (
        Seq      INT IDENTITY(1,1) PRIMARY KEY,
        Nivel    VARCHAR(10),
        Rotulo   VARCHAR(50),
        Valor    DECIMAL(18,6),
        ExDesign VARCHAR(254),
        ExData   CHAR(10),
        ExNome   VARCHAR(100)
    );

    BEGIN TRY
        /* 1) Mapa sem registos (igual ao Reccount("cWAH")=0 do original) */
        IF NOT EXISTS (SELECT 1
                       FROM aa_pr_ajche
                       WHERE WorkerTaxNumber = @WorkerTaxNumber
                         AND SalaryPeriod    = @SalaryPeriod)
        BEGIN
            SELECT Nivel    = CONVERT(VARCHAR(10), 'SEMDADOS'),
                   Mensagem = CONVERT(VARCHAR(254), 'Ainda não existe nenhum registo nos mapas de Horas extras e Ajudas de Custo! Nenhum movimento inserido!');
            RETURN;
        END;

        /* 2) Funcionário e subsídio de refeição (resolvidos uma única vez) */
        SELECT
            @WorkerNumber = pe.no,
            @WorkerName   = pe.nome
        FROM pe
        INNER JOIN pe2 ON pe.pestamp = pe2.pe2stamp
        WHERE pe2.cval1 = @WorkerTaxNumber;

        IF @WorkerNumber IS NULL OR @WorkerName IS NULL
        BEGIN
            SET @Msg = 'Não existe nenhum funcionário com o NIF ' + @WorkerTaxNumber + '. Nenhum movimento inserido!';
            SELECT Nivel = CONVERT(VARCHAR(10), 'ERRO'), Mensagem = @Msg;
            RETURN;
        END;

        SELECT
            @MealValue = subr.evalor,
            @MealDesc  = subr.cmdesc,
            @MealCod   = subr.cm           
        FROM pe
        INNER JOIN pe2  ON pe.pestamp = pe2.pe2stamp
        INNER JOIN subr ON subr.codsubr = pe.codsubr
        WHERE pe2.cval1 = @WorkerTaxNumber;

        /* 3) Movimentos candidatos, já com descrição e fator resolvidos */
        INSERT INTO @Movs (StampAHE, Data, DataRef, DayName, Valor, Rotulo, Cr, HsheCod, Descr, Factor)
        SELECT
            RTRIM(a.StampAHE), a.Data, a.DataRef, RTRIM(a.DayName),
            t.Valor, t.Rotulo, t.Cr, t.HsheCod,
            ISNULL(COALESCE(c.cmdesc, h.descricao), ''),
            ISNULL(h.factor, 0)
        FROM aa_pr_ajche AS a
        CROSS APPLY (VALUES (1, a.CostHelpNValue,  ' Ajudas de custo nacional!',    26,   NULL),
                            (2, a.CostHelpEValue,  ' Ajudas de custo estrangeiro!', 40,   NULL),
                            (3, a.FirstExtraHour,  ' 1ª Horas!',                    NULL, 1),
                            (4, a.SecondExtraHour, ' 2ª Horas!',                    NULL, 2),
                            (5, a.WeekendHours,    ' FDS!',                         NULL, 3)
                    ) AS t (Ordem, Valor, Rotulo, Cr, HsheCod)
        OUTER APPLY (SELECT TOP (1) cm6.cmdesc
                     FROM cm6 (NOLOCK)
                     WHERE cm6.cm = t.Cr) AS c
        OUTER APPLY (SELECT TOP (1) hshe.descricao, hshe.factor
                     FROM hshe (NOLOCK)
                     WHERE hshe.codigo = t.HsheCod) AS h
        WHERE a.WorkerTaxNumber = @WorkerTaxNumber
          AND a.SalaryPeriod    = @SalaryPeriod
          AND t.Valor <> 0
        ORDER BY a.Data, a.StampAHE, t.Ordem;

        /* 4) Processamento sequencial */
        BEGIN TRANSACTION;

        WHILE 1 = 1
        BEGIN
            SELECT TOP (1)
                @Seq      = m.Seq,
                @StampAHE = m.StampAHE,
                @Data     = m.Data,
                @DataRef  = m.DataRef,
                @DayName  = m.DayName,
                @Valor    = m.Valor,
                @Rotulo   = m.Rotulo,
                @Cr       = m.Cr,
                @HsheCod  = m.HsheCod,
                @Descr    = m.Descr,
                @Factor   = m.Factor
            FROM @Movs AS m
            WHERE m.Seq > @Seq
            ORDER BY m.Seq;

            IF @@ROWCOUNT = 0 BREAK;

            /* 4.1) Duplicado em HS (substitui MCExists) */
            SET @Existe = 0;

            SELECT TOP (1)
                @Existe   = 1,
                @ExDesign = CASE WHEN hs.ntipo = 1 THEN hs.tipohora ELSE hs.rem END,
                @ExData   = CONVERT(CHAR(10), hs.data, 121),
                @ExTotal  = hs.ere,
                @ExNome   = hs.nome
            FROM hs
            INNER JOIN pe  ON hs.no = pe.no
            INNER JOIN pe2 ON pe.pestamp = pe2.pe2stamp
            WHERE pe2.cval1 = @WorkerTaxNumber
              AND hs.data   = @Data
              AND (   (@Cr      IS NOT NULL AND hs.cr      = @Cr      AND hs.ere   = @Valor)
                   OR (@HsheCod IS NOT NULL AND hs.hshecod = @HsheCod AND hs.horas = @Valor) );

            IF @Existe = 1
            BEGIN
                INSERT INTO @Log (Nivel, Valor, ExDesign, ExData, ExNome)
                VALUES ('EXISTENTE', @ExTotal, @ExDesign, @ExData, @ExNome);
                CONTINUE;
            END;

            /* 4.2) Movimento: AJC (movimento variável) ou HE (hora extra) */
            IF @Cr IS NOT NULL
                INSERT INTO hs
                    (hsstamp, u_stampAHE, no, nome, data, dtproc, usadtpr, ntipo, ntipo1,
                     cr, rem, rqtt, ervu, ere, hs3tipo)
                VALUES
                    (LEFT(CONVERT(VARCHAR(36), NEWID()), 25), @StampAHE, @WorkerNumber, @WorkerName,
                     @Data, @DataRef, 1, 3, 'Movimentos variáveis',
                     @Cr, @Descr, 1, @Valor, @Valor, 1);
            ELSE
                INSERT INTO hs
                    (hsstamp, u_stampAHE, no, nome, data, dtproc, usadtpr, ntipo, ntipo1,
                     hshecod, tipohora, horas, factor)
                VALUES
                    (LEFT(CONVERT(VARCHAR(36), NEWID()), 25), @StampAHE, @WorkerNumber, @WorkerName,
                     @Data, @DataRef, 1, 1, 'Horas extraordinárias',
                     @HsheCod, @Descr, @Valor, @Factor);

            /* 4.3) Desconto do subsídio de refeição: por cada AJC em dia útil */
            IF @Cr IS NOT NULL
               AND ISNULL(@MealValue, 0) <> 0
               AND @DayName NOT IN ('Saturday', 'Sunday')

                INSERT INTO hs
                    (hsstamp, no, nome, u_StampAHE, data, dtproc, usadtpr, ntipo, ntipo1,
                     cr, rem, rqtt, ervu, ere, hs3tipo)
                VALUES
                    (LEFT(CONVERT(VARCHAR(36), NEWID()), 25), @WorkerNumber, @WorkerName, @StampAHE,
                     @Data, @DataRef, 1, 3, 'Movimentos variáveis',
                     @MealCod,                  
                     ISNULL(@MealDesc, ''), -1, @MealValue, @MealValue, 1);

            INSERT INTO @Log (Nivel, Rotulo, Valor)
            VALUES ('INSERIDO', @Rotulo, @Valor);
        END;

        COMMIT TRANSACTION;

        /* 5) Log com as mensagens no formato original (números à maneira do astr) */
        SELECT
            l.Nivel,
            Mensagem = CONVERT(VARCHAR(254),
                CASE WHEN l.Nivel = 'INSERIDO'
                     THEN '»' + @WorkerTaxNumber + ' inseridas ' + n.Txt + l.Rotulo
                     ELSE '» Já existe um registo para: ' + RTRIM(ISNULL(l.ExDesign, ''))
                          + '; Data:'  + RTRIM(ISNULL(l.ExData, ''))
                          + '; Valor:' + n.Txt
                          + ';'        + RTRIM(ISNULL(l.ExNome, '')) + ';'
                END)
        FROM @Log AS l
        CROSS APPLY (SELECT T = CONVERT(VARCHAR(40), CAST(ISNULL(l.Valor, 0) AS DECIMAL(18,6)))) AS a
        CROSS APPLY (SELECT S = LEFT(a.T, LEN(a.T) - PATINDEX('%[^0]%', REVERSE(a.T)) + 1)) AS b
        CROSS APPLY (SELECT Txt = REPLACE(CASE WHEN RIGHT(b.S, 1) = '.' THEN LEFT(b.S, LEN(b.S) - 1)
                                               ELSE b.S END, '.', ',')) AS n
        ORDER BY l.Seq;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SELECT Nivel    = CONVERT(VARCHAR(10), 'ERRO'),
               Mensagem = CONVERT(VARCHAR(254), 'Erro a registar movimentos: ' + ERROR_MESSAGE());
    END CATCH
END
GO
