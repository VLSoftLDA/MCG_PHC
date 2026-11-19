SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Phc_GetAccountingSalaryCost]
    @Ano INT,
    @Mes INT,
	@Agrupa VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DtBegin DATE;
    DECLARE @DtEnd DATE;
	DECLARE @Periodo CHAR(7);

	SET @Periodo =
		RIGHT('00' + CAST(@Mes AS VARCHAR(2)),2)
		+ '.'
		+ CAST(@Ano AS CHAR(4));

    -- Primeiro dia do mês
    SET @DtBegin = DATEFROMPARTS(@Ano, @Mes, 1);
    -- Último dia do mês
    SET @DtEnd = EOMONTH(@DtBegin);

    EXEC dbo.PHC_SalaryAccountingWithJob
         @DataIni = @DtBegin,
         @DataFim = @DtEnd;
	
	IF @Agrupa = 'Recibo'
	BEGIN
		 SELECT
			'Periodo' =  @Periodo
			,'Funcionario'= cast(T0.No as varchar(10))
			,'Recibo'= cast(T0.Recibo as varchar(10))
			,'Conta' = (case when T1.u_pnnosap<>'' then T1.u_pnnosap else T0.Conta end)
			,'Reconciliacao' = (case when T0.conta like 'E%' then '2312' else T0.conta end)
			,'Designacao' = T0.conta_design
			,'Debito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)>0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)
			,'Credito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)<0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)*(-1)
			,'Obra' = (case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end)
		FROM aaa_tmpSalaryAccounting T0
			LEFT JOIN pc(nolock) T1 on T0.conta = T1.Conta
		GROUP BY T0.No, T0.Recibo,T0.conta,conta_design,T1.u_pnnosap
			,(case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end)
		--HAVING sum(iif(left(T0.conta,1)='E',0,T0.valor_deb))<>0 or sum(iif(left(T0.conta,1)='E',T0.valor_cre-T0.valor_deb,T0.valor_cre))<>0
		ORDER BY T0.No,T0.Recibo,T0.conta,(case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end) desc
	END
	ELSE IF @Agrupa = 'Obra'
	BEGIN
		 SELECT
			'Periodo' =  @Periodo
			,'Conta' = (case when T1.u_pnnosap<>'' then T1.u_pnnosap else T0.Conta end)
			,'Reconciliacao' = (case when T0.conta like 'E%' then '2312' else T0.conta end)
			,'Designacao' = T0.conta_design
			,'Debito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)>0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)
			,'Credito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)<0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)*(-1)
			,'Obra' = (case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end)
		FROM aaa_tmpSalaryAccounting T0
			LEFT JOIN pc(nolock) T1 on T0.conta = T1.Conta
		GROUP BY T0.conta,conta_design,T1.u_pnnosap
			,(case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end)
		--HAVING sum(iif(left(T0.conta,1)='E',0,T0.valor_deb))<>0 or sum(iif(left(T0.conta,1)='E',T0.valor_cre-T0.valor_deb,T0.valor_cre))<>0
		ORDER BY T0.conta,(case when T0.conta like '6%' or T0.conta like '272212%' then T0.Obra else '' end) desc
	END
	ELSE
	BEGIN
		 SELECT
			'Periodo' =  @Periodo
			,'Conta' = (case when T1.u_pnnosap<>'' then T1.u_pnnosap else T0.Conta end)
			,'Reconciliacao' = (case when T0.conta like 'E%' then '2312' else T0.conta end)
			,'Designacao' = T0.conta_design
			,'Debito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)>0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)
			,'Credito' = round((CASE WHEN SUM(T0.valor_deb-T0.valor_cre)<0 THEN SUM(T0.valor_deb-T0.valor_cre) ELSE 0 END),2)*(-1)
		FROM aaa_tmpSalaryAccounting T0
			LEFT JOIN pc(nolock) T1 on T0.conta = T1.Conta
		GROUP BY T0.conta,conta_design,T1.u_pnnosap
		--HAVING sum(iif(left(T0.conta,1)='E',0,T0.valor_deb))<>0 or sum(iif(left(T0.conta,1)='E',T0.valor_cre-T0.valor_deb,T0.valor_cre))<>0
		ORDER BY T0.conta desc
	END

END;
GO
