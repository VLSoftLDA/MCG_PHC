SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Insert_Faltas_RH_Web]
(
    @absstamp   VARCHAR(30),
    @hscodigo   INT,
	@obs   VARCHAR(1000),
    @usernome   VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @ocorrencia INT,
        @datai      DATE,
        @dataf      DATE,
        @dataHS     DATE;

    SELECT @ocorrencia = ISNULL(MAX(hs.ocorrencia), 0) + 1
    FROM hs WITH (NOLOCK);

    SELECT 
        @datai = datai,
        @dataf = dataf
    FROM abs WITH (NOLOCK)
    WHERE absstamp = @absstamp;

    SET @dataHS = @datai;

    WHILE @dataHS <= @dataf
    BEGIN
        /* Ignorar fins de semana */
        IF DATENAME(WEEKDAY, @dataHS) NOT IN ('Saturday', 'Sunday')
        BEGIN
            /* Ignorar feriados */
            IF NOT EXISTS (
                SELECT 1
                FROM ff WITH (NOLOCK)
                WHERE
                    (
                        (ff.data = @dataHS AND (ff.dataf = @dataHS OR ff.dataf = ff.data))
                        OR
                        (ff.fixo = 1 
                         AND ff.diai = MONTH(@dataHS) * 100 + DAY(@dataHS)
                         AND ff.diai = ff.diaf)
                    )
                    AND ff.nope = 0
                    AND ((ff.exclusivo = 1 AND ff.estab = 0) OR ff.exclusivo = 0)
            )
            BEGIN
                INSERT INTO hs
                (
                    hsstamp, ntipo, ntipo1, no, nome, absstamp, just,
                    fdia, obs, ocorrencia, bsfalta, tyfalta, tydescricao,
                    refe, desconta, anabsen, usadtpr, area, decreferias,
                    data, ccusto,
                    usrinis, usrdata, usrhora,
                    ousrinis, ousrdata, ousrhora
                )
                SELECT
                    trim((SELECT LEFT(NEWID(), 5) + RIGHT(NEWID(), 5) + LEFT(NEWID(), 5) + RIGHT(NEWID(), 5))),
                    2,
                    'Faltas',
                    a.no,
                    a.nome,
                    a.absstamp,
                    t.just,
                    1,
                    @obs,
                    @ocorrencia,   -- mesma ocorrência
                    t.bsfalta,
                    t.codigo,
                    t.descricao,
                    t.refe,
                    t.desconta,
                    t.anabsen,
                    t.usadtpr,
                    '',
                    t.decreferias,
                    @dataHS,
                    '',
                    @usernome,
                    GETDATE(),
                    CONVERT(CHAR(8), GETDATE(), 14),
                    @usernome,
                    GETDATE(),
                    CONVERT(CHAR(8), GETDATE(), 14)
                FROM abs a
                INNER JOIN ty t ON t.codigo = @hscodigo
                WHERE a.absstamp = @absstamp;
            END
        END

        SET @dataHS = DATEADD(DAY, 1, @dataHS);
    END
END;
GO
