SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_SalaryAccountingWithJob]
    @DataIni DATE 
    ,@DataFim DATE
AS
BEGIN 
    SET NOCOUNT ON;

    DECLARE 
        @prstamp varchar(50),
        @recibo int,
		@no int,
        @nome varchar(200),
        @tipo int,
        @codigo int,
        @descricao varchar(200),
        @valor decimal(10,2),
        @obra varchar(30),
        @percentagem decimal(10,2),
        @distribuido decimal(10,2);

    DECLARE 
        @gerencia_deb varchar(20),@gerencia_cre varchar(20),
        @normal_deb varchar(20),@normal_cre varchar(20),
        @producao_deb varchar(20),@producao_cre varchar(20),
        @pemprego_deb varchar(20),@pemprego_cre varchar(20);

    DECLARE 
        @conta_cre varchar(20),@conta_deb varchar(20),
        @conta_design varchar(200);

    DECLARE @ordem int = 0;

    DECLARE @defaultJob varchar(30) =
        ISNULL((SELECT avalor FROM e2(NOLOCK)
                WHERE e1cano=1002 AND e1lino=3 AND ano=2025),'');

    DECLARE @PSeguro decimal(10,2) =
        ISNULL((SELECT nvalor FROM e2(NOLOCK)
                WHERE e1cano=1002 AND e1lino=4 AND ano=2025),'');

	-- CRIAR TABELA TEMPORÁRIA COM OS VALORES A USAR POR RECIBO
	SELECT
		pr.prstamp,
		WorkerTwelfthSalary = ISNULL(round((pe.ebasemes + pe.eviht)/12,2),0),
		HolidayBonus =
			ISNULL(round(HB.Valor,2),0),
		ChristmasBonus =
			ISNULL(round(CB.Valor,2),0),
		TwelfthSalary =
			ISNULL(round(TS.Valor,2),0)
	INTO #Bonus
	FROM pr
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN (
			SELECT
				prre.prstamp,
				SUM(prre.ere) AS Valor
			FROM prre
				INNER JOIN cm6 ON prre.cr = cm6.cm
			WHERE cm6.U_RBFerias = 1
			GROUP BY prre.prstamp
		) HB ON HB.prstamp = pr.prstamp
		LEFT JOIN (
			SELECT
				prre.prstamp,
				SUM(prre.ere) AS Valor
			FROM prre
				INNER JOIN cm6 ON prre.cr = cm6.cm
			WHERE cm6.U_RBNatal = 1
			GROUP BY prre.prstamp
		) CB ON CB.prstamp = pr.prstamp
		LEFT JOIN (
			SELECT
				prre.prstamp,
				SUM(prre.ere)/12.0 AS Valor
			FROM prre
				INNER JOIN cm6 ON prre.cr = cm6.cm
			WHERE (cm6.codbase = 1 OR cm6.iht = 1)
			GROUP BY prre.prstamp
		)TS ON TS.prstamp = pr.prstamp
	WHERE pr.data >= @DataIni AND pr.data <= @DataFim;

	CREATE UNIQUE INDEX IX_Bonus_PrStamp ON #Bonus(prstamp);
	-- FIM 

	-- CRIAR TABELA TEMPORÁRIA COM O TOTAL DE HORAS POR RECIBO
	SELECT
		prstamp,
		CASE
			WHEN ISNULL(SUM(hours),0)=0 THEN 1
			ELSE SUM(hours)
		END AS Total
	INTO #JobHours
	FROM aa_pr_jobshours
	GROUP BY prstamp;

	CREATE UNIQUE INDEX IX_JobHours_PrStamp	ON #JobHours(prstamp);
	-- FIM 


    DECLARE csRubricas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
    WITH CTE_Base AS (-- TODOS OS RECIBOS DO INTERVALO DE DATAS
        SELECT 
            pr.prstamp,
            pr.recibo,
            pr.no,
            pr.nome,
            Tipo = pr.codigo,
            pr.essevalor,
            pr.txsse,
            pe.u_interno,
            pe.ccusto,
            pe.u_sncsind,
            TB.WorkerTwelfthSalary,
            TB.HolidayBonus,
            TB.ChristmasBonus,
            TB.TwelfthSalary,
            T0.JobCode,
            T0.hours,
            T1.Total,
            Percentagem = ISNULL(
                T0.hours * 100.0 / NULLIF(T1.Total, 0),
                100
            ),
            FatorDistribuicao = ISNULL(
                T0.hours * 1.0 / NULLIF(T1.Total, 0),
                1
            ),
            ObraNormal = COALESCE(
                NULLIF(T0.JobCode, ''),
                CASE
                    WHEN pe.u_interno = 1 THEN pe.ccusto
                END,
                ''
            ),
            ObraInterno = IIF(
                COALESCE(T0.JobCode, '') = ''
                AND pe.u_interno = 1,
                pe.ccusto,
                COALESCE(T0.JobCode, '')
            )
        FROM pr
            INNER JOIN pe ON pe.no = pr.no
            LEFT JOIN #Bonus TB ON TB.prstamp = pr.prstamp
            LEFT JOIN aa_pr_jobshours T0 ON T0.prstamp = pr.prstamp
            LEFT JOIN #JobHours T1 ON T1.prstamp = pr.prstamp
        WHERE
            pr.data >= @DataIni
            AND pr.data <= @DataFim
    ),
    CTE_PRRE AS (--Todas as remunerações dos recibos excepto Férias e Natal
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            Tipo = B.Tipo,
            Codigo = prre.cr,
            Descricao = prre.rem,
            Valor = SUM(prre.ere),
            Obra = B.ObraNormal,
            Percentagem = B.Percentagem,
            ValorDistribuido = SUM(prre.ere) * B.FatorDistribuicao,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
        FROM CTE_Base B
            INNER JOIN prre ON prre.prstamp = B.prstamp
            INNER JOIN cm6 ON cm6.cm = prre.cr
                            AND cm6.especie = 0
                            AND cm6.U_RBFerias = 0
                            AND cm6.U_RBNatal = 0
        WHERE
            prre.rem <> ''
        GROUP BY
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            B.ObraNormal,
            B.Percentagem,
            B.FatorDistribuicao,
            prre.cr,
            prre.rem,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
    ),
    CTE_PRDE AS (--Todos descontos dos recibos excepto descontos em Espécie
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            Codigo = prde.cd,
            Descricao = prde.des,
            Valor = SUM(prde.ede),
            Obra = COALESCE(
                NULLIF(cm6.u_obra, ''),
                B.ObraInterno
            ),
            Percentagem = B.Percentagem,
            ValorDistribuido = SUM(prde.ede) * B.FatorDistribuicao,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
        FROM CTE_Base B
            INNER JOIN prde ON prde.prstamp = B.prstamp
            INNER JOIN cm6 ON cm6.cm = prde.cd
                            AND cm6.especie = 0
        WHERE
            prde.des <> ''
        GROUP BY
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            B.ObraInterno,
            B.Percentagem,
            B.FatorDistribuicao,
            prde.cd,
            prde.des,
            cm6.u_obra,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
    ),
    CTE_Ferias AS (--Férias e subsídio de férias
        -- 27221212/27221222 - Férias em duodécimos
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            Codigo = cm6.cm,
            Descricao = cm6.cmdesc,
            Valor = B.TwelfthSalary,
            Obra = COALESCE(
                CASE
                    WHEN B.u_interno = 0 THEN @defaultJob
                END,
                B.ccusto,
                ''
            ),
            Percentagem = B.Percentagem,
            ValorDistribuido = B.TwelfthSalary * B.FatorDistribuicao,
            Gerencia_DEB = cm6.u_debger3,
            Gerencia_CRE = cm6.u_creger3,
            Normal_DEB = cm6.u_debnor3,
            Normal_CRE = cm6.u_crenor3,
            Producao_DEB = cm6.u_debnor3,
            Producao_CRE = cm6.u_crenor3,
            PEmprego_DEB = cm6.u_debnor3,
            PEmprego_CRE = cm6.u_crenor3
        FROM CTE_Base B
            LEFT JOIN cm6 ON cm6.U_RBFerias = 1
        
        UNION ALL 

        -- 63202 - Sub. Férias em duodécimos quando é pago o subsídio
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            cm6.cm,
            cm6.cmdesc,
            Valor = B.TwelfthSalary,
            Obra = B.ObraNormal,
            Percentagem = B.Percentagem,
            ValorDistribuido = B.TwelfthSalary * B.FatorDistribuicao,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.U_RBFerias = 1
        WHERE
            B.HolidayBonus > 0

        UNION ALL 
        
        -- 27221211/27221221 - Retira duodécimos quando é pago
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            cm6.cm,
            cm6.cmdesc + ' (Retira duodécimos - Férias)',
            Valor = B.TwelfthSalary,
            Obra = CASE
                WHEN B.HolidayBonus > 0
                AND B.u_interno = 1 THEN B.ccusto
                WHEN NULLIF(B.JobCode, '') IS NOT NULL THEN B.JobCode
                WHEN B.u_interno = 1 THEN B.ccusto
                ELSE @defaultJob
            END,
            Percentagem = B.Percentagem,
            ValorDistribuido = CASE
                WHEN B.HolidayBonus > 0 THEN B.HolidayBonus - B.TwelfthSalary
                ELSE B.TwelfthSalary
            END * B.FatorDistribuicao,
            Gerencia_DEB = IIF(
                B.HolidayBonus > 0,
                cm6.u_debger2,
                cm6.debger
            ),
            Gerencia_CRE = IIF(
                B.HolidayBonus > 0,
                cm6.creger,
                cm6.u_creger2
            ),
            Normal_DEB = IIF(
                B.HolidayBonus > 0,
                cm6.u_debnor2,
                cm6.debnor
            ),
            Normal_CRE = IIF(
                B.HolidayBonus > 0,
                cm6.crenor,
                cm6.u_crenor2
            ),
            Producao_DEB = IIF(
                B.HolidayBonus > 0,
                cm6.u_debnor2,
                cm6.debpro
            ),
            Producao_CRE = IIF(
                B.HolidayBonus > 0,
                cm6.crepro,
                cm6.u_crenor2
            ),
            PEmprego_DEB = IIF(
                B.HolidayBonus > 0,
                cm6.u_debnor2,
                cm6.deb1emp
            ),
            PEmprego_CRE = IIF(
                B.HolidayBonus > 0,
                cm6.cre1emp,
                cm6.u_crenor2
            )
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.U_RBFerias = 1
    ),
    CTE_Natal AS (-- Subsídio de Natal
        -- 63203
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            cm6.cm,
            cm6.cmdesc,
            Valor = B.TwelfthSalary,
            Obra = B.ObraNormal,
            Percentagem = B.Percentagem,
            ValorDistribuido = B.TwelfthSalary * B.FatorDistribuicao,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.U_RBNatal = 1
        WHERE
            B.ChristmasBonus > 0

        UNION ALL 
        
        -- 27221213/27221223
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            cm6.cm,
            cm6.cmdesc + ' (Retira duodécimos - Natal)',
            Valor = B.TwelfthSalary,
            Obra = B.ObraNormal,
            Percentagem = B.Percentagem,
            ValorDistribuido = CASE
                WHEN B.ChristmasBonus > 0 THEN B.ChristmasBonus - B.TwelfthSalary
                ELSE B.TwelfthSalary
            END * B.FatorDistribuicao,
            IIF(B.ChristmasBonus > 0, cm6.u_debger2, cm6.debger),
            IIF(B.ChristmasBonus > 0, cm6.creger, cm6.u_creger2),
            IIF(B.ChristmasBonus > 0, cm6.u_debnor2, cm6.debnor),
            IIF(B.ChristmasBonus > 0, cm6.crenor, cm6.u_crenor2),
            IIF(B.ChristmasBonus > 0, cm6.u_debnor2, cm6.debpro),
            IIF(B.ChristmasBonus > 0, cm6.crepro, cm6.u_crenor2),
            IIF(B.ChristmasBonus > 0, cm6.u_debnor2, cm6.deb1emp),
            IIF(B.ChristmasBonus > 0, cm6.cre1emp, cm6.u_crenor2)
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.U_RBNatal = 1
    ),
    CTE_Rubricas AS (
        SELECT * FROM CTE_PRRE
        UNION ALL
        SELECT * FROM CTE_PRDE
        UNION ALL
        SELECT * FROM CTE_Ferias
        UNION ALL
        SELECT * FROM CTE_Natal
    ),
    CTE_Agrupada AS (
        SELECT
            PrStamp = prstamp,
            Recibo = recibo,
            Numero = no,
            Nome = nome,
            Tipo = Tipo,
            Codigo,
            Descricao,
            Valor = CAST(
                MAX(Valor) AS DECIMAL(10, 2)
            ),
            Obra,
            Percentagem = CAST(
                SUM(Percentagem) AS DECIMAL(10, 2)
            ),
            ValorDistribuido = CAST(
                SUM(ValorDistribuido) AS DECIMAL(10, 2)
            ),
            debger AS Gerencia_DEB,
            creger AS Gerencia_CRE,
            debnor AS Normal_DEB,
            crenor AS Normal_CRE,
            debpro AS Producao_DEB,
            crepro AS Producao_CRE,
            deb1emp AS PEmprego_DEB,
            cre1emp AS PEmprego_CRE,
            Ordem = 1
        FROM CTE_Rubricas
        GROUP BY
            prstamp,
            recibo,
            no,
            nome,
            Tipo,
            Codigo,
            Descricao,
            Obra,
            debger,
            creger,
            debnor,
            crenor,
            debpro,
            crepro,
            deb1emp,
            cre1emp
    ),
    CTE_SS AS (
        -- Segurança Social
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            Codigo = 999,
            Descricao = 'Segurança Social paga pela empresa',
            Valor = CAST(B.essevalor AS DECIMAL(10, 2)),
            Obra = B.ObraInterno,
            Percentagem = B.Percentagem,
            ValorDistribuido = CAST(B.essevalor AS DECIMAL(10, 2)) * B.FatorDistribuicao,
            cm6.debger,
            cm6.creger,
            cm6.debnor,
            cm6.crenor,
            cm6.debpro,
            cm6.crepro,
            cm6.deb1emp,
            cm6.cre1emp,
            Ordem = 2
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.cm = 999
        
        UNION ALL 
        
        -- SS do Sub. de Natal
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            999,
            'Segurança Social paga pela empresa - Sub. Natal',
            CASE
                WHEN B.ChristmasBonus > 0 THEN 0
                ELSE CAST(
                    round(B.TwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)
                )
            END,
            B.ObraNormal,
            B.Percentagem,
            (
                CASE
                    WHEN B.ChristmasBonus > 0 THEN 0
                    ELSE CAST(
                        round(B.TwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)
                    )
                END
            ) * B.FatorDistribuicao,
            cm6.debger,
            IIF(B.ChristmasBonus > 0, cm6.creger, cm6.u_creger2),
            cm6.debnor,
            IIF(B.ChristmasBonus > 0, cm6.crenor, cm6.u_crenor2),
            cm6.debpro,
            IIF(B.ChristmasBonus > 0, cm6.crepro, cm6.u_crenor2),
            cm6.deb1emp,
            IIF(B.ChristmasBonus > 0, cm6.cre1emp, cm6.u_crenor2),
            2
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.cm = 999

        UNION ALL 
        
        -- SS do Sub. de Natal quando recibo do Sub. de Natal é feito separado do ordenado base
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            999,
            'Segurança Social paga pela empresa - Sub. Natal (Recibo Separado)',
            CAST(round(B.WorkerTwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)),
            B.ObraNormal,
            B.Percentagem,
            (CAST(round(B.WorkerTwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2))* B.FatorDistribuicao),
            cm6.u_creger2,
            cm6.debger, 
            cm6.u_crenor2,
            cm6.debnor,
            cm6.u_crenor2,
            cm6.debpro, 
            cm6.u_crenor2,
            cm6.deb1emp, 
            2
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.cm = 999
        WHERE CAST(B.ChristmasBonus AS INT) = CAST((B.WorkerTwelfthSalary*12) AS INT)  
            AND CAST(B.ChristmasBonus AS INT) <> CAST((round(B.TwelfthSalary,2)*12) AS INT)
    
        UNION ALL 
        
        -- SS do Sub. de Férias
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            999,
            'Segurança Social paga pela empresa - Sub. Férias',
            CASE
                WHEN B.HolidayBonus > 0 THEN 0
                ELSE CAST(
                    round(B.TwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)
                )
            END,
            B.ObraNormal,
            B.Percentagem,
            (
                CASE
                    WHEN B.HolidayBonus > 0 THEN 0
                    ELSE CAST(
                        round(B.TwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)
                    )
                END
            ) * B.FatorDistribuicao,
            cm6.debger,
            IIF(B.HolidayBonus > 0, cm6.creger, cm6.u_creger2),
            cm6.debnor,
            IIF(B.HolidayBonus > 0, cm6.crenor, cm6.u_crenor2),
            cm6.debpro,
            IIF(B.HolidayBonus > 0, cm6.crepro, cm6.u_crenor2),
            cm6.deb1emp,
            IIF(B.HolidayBonus > 0, cm6.cre1emp, cm6.u_crenor2),
            2
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.cm = 999

        UNION ALL 
        
        -- SS do Sub. de Férias quando recibo do Sub. de férias é feito separado do ordenado base
        SELECT
            B.prstamp,
            B.recibo,
            B.no,
            B.nome,
            B.Tipo,
            999,
            'Segurança Social paga pela empresa - Sub. Férias (Recibo Separado)',
            CAST(round(B.WorkerTwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2)),
            B.ObraNormal,
            B.Percentagem,
            (CAST(round(B.WorkerTwelfthSalary * (B.txsse / 100.0),2) AS DECIMAL(10, 2))* B.FatorDistribuicao),
            cm6.u_creger2,
            cm6.debger, 
            cm6.u_crenor2,
            cm6.debnor,
            cm6.u_crenor2,
            cm6.debpro, 
            cm6.u_crenor2,
            cm6.deb1emp, 
            2
        FROM CTE_Base B
            INNER JOIN cm6 ON cm6.cm = 999
        WHERE CAST(B.HolidayBonus AS INT) = CAST((B.WorkerTwelfthSalary*12) AS INT)  
            AND CAST(B.HolidayBonus AS INT) <> CAST((round(B.TwelfthSalary,2)*12) AS INT)
        
    ),
    CTE_Final AS (
        SELECT * FROM CTE_Agrupada
        UNION ALL
        SELECT * FROM CTE_SS
    )
    SELECT
        PrStamp,
        Recibo,
        Numero,
        Nome,
        Tipo,
        Codigo,
        Descricao,
        Valor,
        Obra,
        Percentagem,
        ValorDistribuido,
        Gerencia_DEB,
        Gerencia_CRE,
        Normal_DEB,
        Normal_CRE,
        Producao_DEB,
        Producao_CRE,
        PEmprego_DEB,
        PEmprego_CRE,
        Ordem
    FROM CTE_Final
    ORDER BY
        Nome,
        Recibo,
        Codigo;

    DELETE FROM aaa_tmpSalaryAccounting;

    OPEN csRubricas;
    FETCH NEXT FROM csRubricas INTO
        @prstamp,@recibo,@no,@nome,@tipo,@codigo,@descricao,@valor,@obra,
        @percentagem,@distribuido,
        @gerencia_deb,@gerencia_cre,
        @normal_deb,@normal_cre,
        @producao_deb,@producao_cre,
        @pemprego_deb,@pemprego_cre,@ordem;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @tipo=1 BEGIN SET @conta_cre=@gerencia_cre; SET @conta_deb=@gerencia_deb END;
        IF @tipo=2 BEGIN SET @conta_cre=@normal_cre;   SET @conta_deb=@normal_deb END;
        IF @tipo=3 BEGIN SET @conta_cre=@producao_cre; SET @conta_deb=@producao_deb END;
        IF @tipo=4 BEGIN SET @conta_cre=@pemprego_cre; SET @conta_deb=@pemprego_deb END;

    
        SELECT TOP 1 @conta_design = descricao 
		FROM pc(NOLOCK) 
		WHERE descricao<>'' and conta=@conta_deb;

        IF LEFT(@conta_deb,1)='E' OR @conta_deb IN('2452','2421')
            SET @obra='';

        IF @conta_deb IN('2452','2421') OR @conta_deb LIKE '272212%'
            SET @prstamp='';

        INSERT INTO aaa_tmpSalaryAccounting
		(ordem,prstamp,recibo,no,nome,tipo,codigo,descricao,valor,obra,percentagem,distribuido,gerencia_deb,gerencia_cre,normal_deb,normal_cre,producao_deb,producao_cre,pemprego_deb,pemprego_cre,conta,conta_design,valor_deb,valor_cre)
        VALUES(
            @ordem,@prstamp,@recibo,@no,@nome,@tipo,@codigo,@descricao,
            @valor,@obra,@percentagem,@distribuido,
            @gerencia_deb,@gerencia_cre,
            @normal_deb,@normal_cre,
            @producao_deb,@producao_cre,
            @pemprego_deb,@pemprego_cre,
            @conta_deb,@conta_design,@distribuido,0
        );

        SELECT TOP 1 @conta_design =descricao 
		FROM pc(NOLOCK) 
		WHERE descricao<>'' and conta=@conta_cre;

        INSERT INTO aaa_tmpSalaryAccounting
		(ordem,prstamp,recibo,no,nome,tipo,codigo,descricao,valor,obra,percentagem,distribuido,gerencia_deb,gerencia_cre,normal_deb,normal_cre,producao_deb,producao_cre,pemprego_deb,pemprego_cre,conta,conta_design,valor_deb,valor_cre)
        VALUES(
            @ordem,@prstamp,@recibo,@no,@nome,@tipo,@codigo,@descricao,
            @valor,@obra,@percentagem,@distribuido,
            @gerencia_deb,@gerencia_cre,
            @normal_deb,@normal_cre,
            @producao_deb,@producao_cre,
            @pemprego_deb,@pemprego_cre,
            @conta_cre,@conta_design,0,@distribuido
        );

        FETCH NEXT FROM csRubricas INTO
            @prstamp,@recibo,@no,@nome,@tipo,@codigo,@descricao,@valor,@obra,
            @percentagem,@distribuido,
            @gerencia_deb,@gerencia_cre,
            @normal_deb,@normal_cre,
            @producao_deb,@producao_cre,
            @pemprego_deb,@pemprego_cre,@ordem;
    END;

    CLOSE csRubricas;
    DEALLOCATE csRubricas;
END
GO
