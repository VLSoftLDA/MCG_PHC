SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InserirFeriasAniversario]
    @no INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Ano INT = YEAR(GETDATE());

    WITH Aniversarios AS (
        SELECT 
            pe.pestamp,
            pe.no,
            --isnull((SELECT TRIM(nome) 
            -- FROM pe pe1 
            -- WHERE pe1.pestamp = pe.pesupstampfe),'') AS nomesup,
			'' AS nomesup,
            pe.dataadm,
            pe.estab,

            DATEFROMPARTS(
                @Ano,
                MONTH(pe.nasc),
                CASE 
                    WHEN MONTH(pe.nasc) = 2 AND DAY(pe.nasc) = 29 
                         AND NOT (
                             @Ano % 4 = 0 AND 
                             (@Ano % 100 <> 0 OR @Ano % 400 = 0)
                         )
                    THEN 28
                    ELSE DAY(pe.nasc)
                END
            ) AS data_aniv
        FROM pe
        WHERE pe.status <> 3
          AND pe.nasc IS NOT NULL AND pe.nasc <> '19000101'
          AND pe.dataadm IS NOT NULL AND pe.dataadm <> '19000101'

          -- filtro
          AND (@no = 0 OR pe.no = @no)
    ),

    Feriados AS (
        SELECT 
            CASE 
                WHEN ff.fixo = 1 THEN 
                    DATEFROMPARTS(@Ano, MONTH(ff.data), DAY(ff.data))
                ELSE 
                    CONVERT(date, ff.data)
            END AS data_feriado,
            ff.estab
        FROM ff
        WHERE 
            (
                (ff.fixo = 0 AND YEAR(ff.data) = @Ano)
                OR ff.fixo = 1
            )
            AND ff.nope = 0
    ),

    Ajustado AS (
        SELECT 
            a.*,
            (
                SELECT MIN(d)
                FROM (
                    SELECT DATEADD(DAY, v.number, a.data_aniv) AS d
                    FROM master..spt_values v
                    WHERE v.type = 'P' AND v.number BETWEEN 0 AND 15
                ) dias
                WHERE 
					-- verificacao fim de semana
                    DATENAME(WEEKDAY, d) NOT IN ('Saturday', 'Sunday')

					--verificacao feriado
                    AND NOT EXISTS (
                        SELECT 1
                        FROM Feriados f
                        WHERE f.data_feriado = d
                          AND (f.estab = 0 OR f.estab = a.estab)
                    )
            ) AS data_util
        FROM Aniversarios a
    )

    INSERT INTO dbo.fp (
        fpstamp, dias, pestamp, no, pesupnomefe,
        horaf, horai, ano, pmes, pano,
        fechado, obs, ismdias, datai, dataf, isfpadmissao, u_aniv,
        ousrhora, ousrdata, ousrinis, usrdata, usrhora, usrinis
    )
    SELECT
        TRIM(LEFT(NEWID(),5) + RIGHT(NEWID(),5) + LEFT(NEWID(),5) + RIGHT(NEWID(),5)),
        0,
        a.pestamp,
        a.no,
        TRIM(a.nomesup),

        '00:00',
        '00:00',
		CASE 
            WHEN YEAR(a.dataadm) = @Ano THEN YEAR(a.dataadm)
            ELSE year(getdate()) - 1
        END,
        MONTH(a.data_util),
        YEAR(a.data_util),

        1,
        concat('Inserido pelo sistema de aniversários a ', convert(varchar, getdate(),103)),
        0,
        a.data_util,
        a.data_util,
        CASE 
            WHEN YEAR(a.dataadm) = @Ano THEN 1 
            ELSE 0 
        END,
		1,

        '00:00',
        GETDATE(),
        'Wsis',
        GETDATE(),
        '00:00',
        'Wsis'

    FROM Ajustado a

    WHERE DATEADD(MONTH, 6, a.dataadm) <= a.data_aniv  --apenas adiciona caso a data de aniversario seja 6 meses após a data de admissão
	AND a.data_aniv >= getdate()
    AND NOT EXISTS (
        SELECT 1
        FROM fp f
        WHERE f.pestamp = a.pestamp
          AND a.data_util BETWEEN f.datai AND f.dataf
    );
END
GO
