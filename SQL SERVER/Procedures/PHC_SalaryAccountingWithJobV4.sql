SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_SalaryAccountingWithJobV4]
      @Ano int
     ,@Mes int
AS
BEGIN 
    SET NOCOUNT ON;

    DECLARE 
        @prstamp varchar(50),
        @recibo int,
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

    DECLARE csRubricas CURSOR LOCAL FAST_FORWARD READ_ONLY FOR

    SELECT 
        'PrStamp' = SQ.prstamp,
        'Recibo' = SQ.Recibo,
        'Nome' = SQ.Nome,
        'Tipo' = SQ.Tipo,
        'Código' = SQ.Código,
        'Descrição' = SQ.Descrição,
        'Valor' = CAST(MAX(SQ.Valor) AS decimal(10,2)),
        'Obra' = SQ.Obra,
        'Percentagem' = CAST(SUM(SQ.Percentagem) AS decimal(10,2)),
        'ValorDistribuido' = CAST(SUM(SQ.ValorDistribuido) AS decimal(10,2)),
        'Gerencia_DEB' = Gerencia_DEB,
        'Gerencia_CRE' = Gerencia_CRE,
        'Normal_DEB' = Normal_DEB,
        'Normal_CRE' = Normal_CRE,
        'Producao_DEB' = Producao_DEB,
        'Producao_CRE' = Producao_CRE,
        'PEmprego_DEB' = PEmprego_DEB,
        'PEmprego_CRE' = PEmprego_CRE,
        'Ordem' = 1
    FROM (
        SELECT
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = prre.cr
		,'Descrição' = prre.rem
		,'Valor' = sum(prre.ere)
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' = ISNULL(NULLIF(T0.hours, 0) * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = SUM(prre.ere) * ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1) 
		,cm6.debger as 'Gerencia_DEB'
		,cm6.creger as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,cm6.crenor as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,cm6.crepro as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,cm6.cre1emp as 'PEmprego_CRE'
	FROM prre (nolock)
		INNER JOIN pr ON prre.prstamp=pr.prstamp
		INNER JOIN cm6 ON prre.cr=cm6.cm and cm6.especie=0 and cm6.ferias=0 and cm6.natal=0  -- Não contabilizar subsidios de férias e natal
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes AND prre.rem<>''
	GROUP BY prre.rem,pr.nome,pr.codigo,pr.prstamp,pr.recibo,prre.cr,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp

	UNION ALL

	-- 27221212 - Férias em duodécimos
	SELECT 
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = cm6.cm
		,'Descrição' = cm6.cmdesc
		,'Valor' = dbo.Phc_TwelfthSalary(pr.prstamp)
		,'Obra' =  COALESCE(CASE WHEN pe.u_interno = 0 THEN @defaultJob END,pe.ccusto,'')
		,'Percentagem' = ISNULL(T0.hours * 100.0 / T1.Total, 100) 
		,'ValorDistribuido' = dbo.Phc_TwelfthSalary(pr.prstamp)*ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,cm6.u_debger3 as 'Gerencia_DEB'
		,cm6.u_creger3 as 'Gerencia_CRE'
		,cm6.u_debnor3 as 'Normal_DEB'
		,cm6.u_crenor3 as 'Normal_CRE'
		,cm6.u_debnor3 as 'Producao_DEB'
		,cm6.u_crenor3 as 'Producao_CRE'
		,cm6.u_debnor3 as 'PEmprego_DEB'
		,cm6.u_crenor3 as 'PEmprego_CRE'
	FROM pr (nolock)
		LEFT JOIN cm6 ON cm6.ferias=1 and cm6.cmdesc not like 'Retro%' and cm6.cmdesc not like 'Propor%'
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes
	GROUP BY pr.nome,pr.codigo,pr.prstamp,pr.recibo,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.cm,cm6.cmdesc,cm6.u_creger3,cm6.u_crenor3,cm6.u_debger3,cm6.u_debnor3

	UNION ALL

	-- 63202 - Sub. Férias em duodécimos quando é pago o subsidio
	SELECT 
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = cm6.cm
		,'Descrição' = cm6.cmdesc
		,'Valor' = dbo.Phc_TwelfthSalary(pr.prstamp)
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' = ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = dbo.Phc_TwelfthSalary(pr.prstamp)*ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,cm6.debger as 'Gerencia_DEB'
		,cm6.creger as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,cm6.crenor as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,cm6.crepro as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,cm6.cre1emp as 'PEmprego_CRE'
	FROM pr (nolock)
		LEFT JOIN cm6 ON cm6.ferias=1 and cm6.cmdesc not like 'Retro%' and cm6.cmdesc not like 'Propor%'
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE dbo.Phc_GetHolidayBonus(pr.prstamp)>0 and year(pr.data)=@ano and month(pr.data)=@mes
	GROUP BY pr.nome,pr.codigo,pr.prstamp,pr.recibo,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.cm,cm6.cmdesc,cm6.u_creger3,cm6.u_crenor3,cm6.u_debger3,cm6.u_debnor3

	UNION ALL

	-- 27221211 - Subsidio de férias em duodécimos (Retira duodécimos quando é pago)!
	SELECT 
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = cm6.cm
		,'Descrição' = cm6.cmdesc
		,'Valor' = dbo.Phc_TwelfthSalary(pr.prstamp)
		,'Obra' =  CASE
						WHEN dbo.Phc_GetHolidayBonus(pr.prstamp) > 0
							AND pe.u_interno = 1
							THEN pe.ccusto
						WHEN NULLIF(T0.JobCode,'') IS NOT NULL
							THEN T0.JobCode
						WHEN pe.u_interno = 1
							THEN pe.ccusto
						ELSE @defaultJob
					END
		,'Percentagem' = ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = CASE
									WHEN dbo.Phc_GetHolidayBonus(pr.prstamp) > 0
										THEN dbo.Phc_GetHolidayBonus(pr.prstamp)
											- dbo.Phc_TwelfthSalary(pr.prstamp)
									ELSE dbo.Phc_TwelfthSalary(pr.prstamp)
							   END
							   * ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.u_debger2,cm6.debger) as 'Gerencia_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.creger,cm6.u_creger2) as 'Gerencia_CRE'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.debnor) as 'Normal_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.crenor,cm6.u_crenor2) as 'Normal_CRE'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.debpro) as 'Producao_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.crepro,cm6.u_crenor2) as 'Producao_CRE'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.deb1emp) as 'PEmprego_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.cre1emp,cm6.u_crenor2) as 'PEmprego_CRE'
	FROM pr (nolock)
		INNER JOIN cm6 ON cm6.ferias=1 and cm6.cmdesc not like 'Retro%' and cm6.cmdesc not like 'Propor%'
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes
	GROUP BY pr.nome,pr.codigo,pr.prstamp,pr.recibo,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.cm,cm6.cmdesc,cm6.u_creger2,cm6.u_crenor2,cm6.u_debger2,cm6.u_debnor2

	UNION ALL

	-- 63203 - Sub. Natal em duodécimos quando é pago o subsidio
	SELECT 
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = cm6.cm
		,'Descrição' = cm6.cmdesc
		,'Valor' = dbo.Phc_TwelfthSalary(pr.prstamp)
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' = ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = dbo.Phc_TwelfthSalary(pr.prstamp)* ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,cm6.debger as 'Gerencia_DEB'
		,cm6.creger as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,cm6.crenor as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,cm6.crepro as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,cm6.cre1emp as 'PEmprego_CRE'
	FROM pr (nolock)
		LEFT JOIN cm6 ON cm6.natal=1 and cm6.cmdesc not like 'Retro%' and cm6.cmdesc not like 'Propor%'
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE dbo.Phc_GetChristmasBonus(pr.prstamp)>0 and year(pr.data)=@ano and month(pr.data)=@mes
	GROUP BY pr.nome,pr.codigo,pr.prstamp,pr.recibo,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.cm,cm6.cmdesc,cm6.u_creger3,cm6.u_crenor3,cm6.u_debger3,cm6.u_debnor3

	UNION ALL

	-- 27221213 - Subsidio de natal em duodécimos (Retira duodécimos quando é pago)!
	SELECT 
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = cm6.cm
		,'Descrição' = cm6.cmdesc
		,'Valor' = dbo.Phc_TwelfthSalary(pr.prstamp)
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' = ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = CASE
								WHEN dbo.Phc_GetChristmasBonus(pr.prstamp) > 0
									THEN dbo.Phc_GetChristmasBonus(pr.prstamp)
										- dbo.Phc_TwelfthSalary(pr.prstamp)
								ELSE dbo.Phc_TwelfthSalary(pr.prstamp)
							  END
							  * ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.u_debger2,cm6.debger) as 'Gerencia_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.creger,cm6.u_creger2) as 'Gerencia_CRE'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.debnor) as 'Normal_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.crenor,cm6.u_crenor2) as 'Normal_CRE'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.debpro) as 'Producao_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.crepro,cm6.u_crenor2) as 'Producao_CRE'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.u_debnor2,cm6.deb1emp) as 'PEmprego_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.cre1emp,cm6.u_crenor2) as 'PEmprego_CRE'
	FROM pr (nolock)
		INNER JOIN cm6 ON cm6.natal=1 and cm6.cmdesc not like 'Retro%' and cm6.cmdesc not like 'Propor%'
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes
	GROUP BY pr.nome,pr.codigo,pr.prstamp,pr.recibo,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.cm,cm6.cmdesc,cm6.u_creger2,cm6.u_crenor2,cm6.u_debger2,cm6.u_debnor2

	UNION ALL

	SELECT
		pr.prstamp
		,pr.recibo
		,pe.u_interno
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = prde.cd
		,'Descrição' = prde.des
		,'Valor' = sum(prde.ede)
		,'Obra' = COALESCE(NULLIF(cm6.u_obra, ''),IIF(COALESCE(T0.JobCode, '') = '' AND pe.u_interno = 1,pe.ccusto,COALESCE(T0.JobCode, '')))
		,'Percentagem' =  ISNULL((NULLIF(T0.hours, 0) * 100.0) / NULLIF(T1.Total, 0),100) 
		,'ValorDistribuido' = SUM(prde.ede) *ISNULL((NULLIF(T0.hours, 0) * 1.0) / NULLIF(T1.Total, 0),1)
		,cm6.debger as 'Gerencia_DEB'
		,cm6.creger as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,cm6.crenor as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,cm6.crepro as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,cm6.cre1emp as 'PEmprego_CRE'
	FROM prde (nolock)
		INNER JOIN pr ON prde.prstamp=pr.prstamp
		INNER JOIN cm6 ON prde.cd=cm6.cm and cm6.especie=0
		INNER JOIN pe ON pr.no=pe.no
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes AND prde.des<>''
	GROUP BY prde.des,pr.nome,pr.codigo,pr.prstamp,pr.recibo,prde.cd,T1.Total,T0.hours,T0.JobCode,pe.ccusto,pe.u_sncsind,pe.u_interno
			,cm6.debger,cm6.creger,cm6.debnor,cm6.crenor,cm6.debpro,cm6.crepro,cm6.deb1emp,cm6.cre1emp,cm6.u_obra
    ) SQ
    GROUP BY 
        SQ.PrStamp,SQ.u_interno,SQ.Nome,SQ.Tipo,SQ.Código,SQ.Descrição,
        SQ.Obra,SQ.Recibo,
        SQ.Gerencia_DEB,SQ.Gerencia_CRE,
        SQ.Normal_DEB,SQ.Normal_CRE,
        SQ.Producao_DEB,SQ.Producao_CRE,
        SQ.PEmprego_DEB,SQ.PEmprego_CRE
	UNION ALL

	SELECT
		'PrStamp' = pr.prstamp
		,'Recibo' = pr.recibo
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = 999
		,'Descrição' ='Segurança Social paga pela empresa'
		,'Valor' = cast(pr.essevalor as decimal(10,2))
		,'Obra' = IIF(COALESCE(T0.JobCode, '') = '' AND pe.u_interno = 1,pe.ccusto,COALESCE(T0.JobCode, ''))
		,'Percentagem' = ISNULL((NULLIF(T0.hours, 0) * 100.0) / NULLIF(T1.Total, 0),100)
		,'ValorDistribuido' = CAST(pr.essevalor AS DECIMAL(10,2))*ISNULL((NULLIF(T0.hours, 0) * 1.0) / NULLIF(T1.Total, 0),1)
		,cm6.debger as 'Gerencia_DEB'
		,cm6.creger as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,cm6.crenor as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,cm6.crepro as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,cm6.cre1emp as 'PEmprego_CRE'
		,'Ordem' = 2
	FROM pr (nolock)
		INNER JOIN pe ON pr.no=pe.no
		INNER JOIN cm6 ON cm6.cm=999
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes
	
	UNION ALL
	-- SS dos Subsidios de natal. Mas no recibo em que é pago o subsidio devolve 0
	SELECT
		'PrStamp' = pr.prstamp
		,'Recibo' = pr.recibo
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = 999
		,'Descrição' ='Segurança Social paga pela empresa'
		,'Valor' = CASE
					WHEN dbo.Phc_GetChristmasBonus(pr.prstamp) > 0
						THEN 0
					ELSE CAST(dbo.Phc_TwelfthSalary(pr.prstamp) * (pr.txsse / 100.0) AS decimal(10,2))
				   END
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' = ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = CASE
								WHEN dbo.Phc_GetChristmasBonus(pr.prstamp) > 0
									THEN 0
								ELSE CAST(dbo.Phc_TwelfthSalary(pr.prstamp) * (pr.txsse / 100.0) AS decimal(10,2))
							  END
							  * ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,cm6.debger as 'Gerencia_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.creger,cm6.u_creger2) as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.crenor,cm6.u_crenor2) as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.crepro,cm6.u_crenor2) as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,iif(dbo.Phc_GetChristmasBonus(pr.prstamp)>0,cm6.cre1emp,cm6.u_crenor2) as 'PEmprego_CRE'
		,'Ordem' = 2
	FROM pr (nolock)
		INNER JOIN pe ON pr.no=pe.no
		INNER JOIN cm6 ON cm6.cm=999
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes

	UNION ALL
	-- SS dos Subsidios de férias. Mas no recibo em que é pago o subsidio devolve 0
	SELECT
		'PrStamp' = pr.prstamp
		,'Recibo' = pr.recibo
		,'Nome' = pr.nome
		,'Tipo' = pr.codigo
		,'Código' = 999
		,'Descrição' ='Segurança Social paga pela empresa'
		,'Valor' = CASE
				WHEN dbo.Phc_GetHolidayBonus(pr.prstamp) > 0
					THEN 0
				ELSE CAST(dbo.Phc_TwelfthSalary(pr.prstamp) * (pr.txsse / 100.0) AS decimal(10,2))
			END
		,'Obra' = COALESCE(NULLIF(T0.JobCode, ''),CASE WHEN pe.u_interno = 1 THEN pe.ccusto END,'')
		,'Percentagem' =ISNULL(T0.hours * 100.0 / NULLIF(T1.Total, 0), 100)
		,'ValorDistribuido' = CASE
				WHEN dbo.Phc_GetHolidayBonus(pr.prstamp) > 0
					THEN 0
				ELSE CAST(dbo.Phc_TwelfthSalary(pr.prstamp) * (pr.txsse / 100.0) AS decimal(10,2))
			END
			* ISNULL(T0.hours * 1.0 / NULLIF(T1.Total, 0), 1)
		,cm6.debger as 'Gerencia_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.creger,cm6.u_creger2) as 'Gerencia_CRE'
		,cm6.debnor as 'Normal_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.crenor,cm6.u_crenor2) as 'Normal_CRE'
		,cm6.debpro as 'Producao_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.crepro,cm6.u_crenor2) as 'Producao_CRE'
		,cm6.deb1emp as 'PEmprego_DEB'
		,iif(dbo.Phc_GetHolidayBonus(pr.prstamp)>0,cm6.cre1emp,cm6.u_crenor2) as 'PEmprego_CRE'
		,'Ordem' = 2
	FROM pr (nolock)
		INNER JOIN pe ON pr.no=pe.no
		INNER JOIN cm6 ON cm6.cm=999
		LEFT JOIN aa_pr_jobshours T0 on pr.prstamp = T0.prstamp
		LEFT JOIN (select prstamp, iif(isnull(sum(hours),0)=0,1,sum(hours)) as Total from aa_pr_jobshours group by prstamp) T1 on pr.prstamp=T1.prstamp
	WHERE year(pr.data)=@ano and month(pr.data)=@mes

	ORDER BY Nome,Código;

    DELETE FROM aaa_tmpSalaryAccounting;

    OPEN csRubricas;
    FETCH NEXT FROM csRubricas INTO
        @prstamp,@recibo,@nome,@tipo,@codigo,@descricao,@valor,@obra,
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

        SET @conta_design =
            (SELECT descricao FROM pc(NOLOCK)
             WHERE conta=@conta_deb AND ano=2025);

        IF LEFT(@conta_deb,1)='E' OR @conta_deb IN('2452','2421')
            SET @obra='';

        IF @conta_deb IN('2452','2421') OR @conta_deb LIKE '272212%'
            SET @prstamp='';

        INSERT INTO aaa_tmpSalaryAccounting
		(ordem,prstamp,recibo,nome,tipo,codigo,descricao,valor,obra,percentagem,distribuido,gerencia_deb,gerencia_cre,normal_deb,normal_cre,producao_deb,producao_cre,pemprego_deb,pemprego_cre,conta,conta_design,valor_deb,valor_cre)
        VALUES(
            @ordem,@prstamp,@recibo,@nome,@tipo,@codigo,@descricao,
            @valor,@obra,@percentagem,@distribuido,
            @gerencia_deb,@gerencia_cre,
            @normal_deb,@normal_cre,
            @producao_deb,@producao_cre,
            @pemprego_deb,@pemprego_cre,
            @conta_deb,@conta_design,@distribuido,0
        );

        SET @conta_design =
            (SELECT descricao FROM pc(NOLOCK)
             WHERE conta=@conta_cre AND ano=2025);

        INSERT INTO aaa_tmpSalaryAccounting
		(ordem,prstamp,recibo,nome,tipo,codigo,descricao,valor,obra,percentagem,distribuido,gerencia_deb,gerencia_cre,normal_deb,normal_cre,producao_deb,producao_cre,pemprego_deb,pemprego_cre,conta,conta_design,valor_deb,valor_cre)
        VALUES(
            @ordem,@prstamp,@recibo,@nome,@tipo,@codigo,@descricao,
            @valor,@obra,@percentagem,@distribuido,
            @gerencia_deb,@gerencia_cre,
            @normal_deb,@normal_cre,
            @producao_deb,@producao_cre,
            @pemprego_deb,@pemprego_cre,
            @conta_cre,@conta_design,0,@distribuido
        );

        FETCH NEXT FROM csRubricas INTO
            @prstamp,@recibo,@nome,@tipo,@codigo,@descricao,@valor,@obra,
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
