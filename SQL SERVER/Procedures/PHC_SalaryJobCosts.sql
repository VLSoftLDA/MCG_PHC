SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_SalaryJobCosts]
      @DataInicial date
	 ,@DataFinal date 
	 ,@MesRecibo integer
	 ,@AnoRecibo integer
AS 

BEGIN 
    SET NOCOUNT ON 

	DECLARE @WorkerTaxNumber varchar(50),@WorkerNo int,@WorkerName varchar(250),@JobCode varchar(50);
	DECLARE @PeriodTotalHours decimal(10,2),@VacationHours decimal(10,2),@HolidaysHours decimal(10,2),@WorkerHours decimal(10,2),@JobHours decimal(10,2);
	DECLARE @PrStamp varchar(50),@Recibo varchar(50),@CustoRecibo decimal(10,2);

	DECLARE @CustoObra decimal(10,2) = 0;
	DECLARE @PerObra decimal(10,8) = 0;
	DECLARE @CustoCalculado decimal(10,2) = 0;
	DECLARE @SelLine int = 0;
	DECLARE @ObsRecibo varchar(250) = '';
	DECLARE @Obs varchar(250)='';

	DECLARE csWorkersHours CURSOR FOR
		SELECT
			SQLView.WorkerTaxNumber 
			,SQLView.WorkerNo
			,SQLView.WorkerName
			,SQLView.JobCode	
			,SQLView.PeriodTotalHours
			,SQLView.VacationHours
			,SQLView.HolidaysHours
			,isnull(iif(SQLView.WorkerHours<SQLView.PeriodTotalHours,SQLView.PeriodTotalHours,SQLView.WorkerHours),0) as 'WorkerHours'
			,SQLView.JobHours
			,SQLView.Obs
		FROM(
			SELECT 
				T0.WorkerTaxNumber 
				,'MW' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,T0.JobCode as 'JobCode'	
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicial,@DataFinal)*8) as 'HolidaysHours'
				,T0.WorkerTotalHours as 'MwWorkerTotalHours'
				,T0.JobTotalHours as 'MwJobHours'
				,T0.WorkerTotalHours
					+(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8) as 'WorkerHours'
				,T0.JobTotalHours as 'JobHours'
				,'Registo de horas' as 'Obs'
			FROM aaa_tmpWorkersTS T0
				LEFT JOIN pe2(nolock) ON T0.WorkerTaxNumber = pe2.cval1
				LEFT JOIN pe(nolock) ON pe2.pe2stamp=pe.pestamp
			UNION ALL 
			SELECT 
				T0.WorkerTaxNumber 
				,'CC' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,iif(year(@DataInicial)<@AnoRecibo,pe2.cval3,pe.Ccusto)  as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicial,@DataFinal)*8) as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,MAX(T0.WorkerTotalHours)
					+(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8) as 'WorkerHours'
				,MAX(T0.PeriodTotalHours)
					-MAX(T0.WorkerTotalHours)
					-(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8) as 'JobHours'
				,'Registo de horas menor (CC)' as 'Obs'
			FROM aaa_tmpWorkersTS T0
				LEFT JOIN pe2(nolock) ON T0.WorkerTaxNumber = pe2.cval1
				LEFT JOIN pe(nolock) ON pe2.pe2stamp=pe.pestamp
			GROUP BY T0.WorkerTaxNumber,pe.ccusto,pe.no,pe.nome,pe2.cval3
			HAVING (MAX(T0.PeriodTotalHours)
					-(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8)
					-MAX(T0.WorkerTotalHours))>0
			UNION ALL 
			SELECT 
				pe2.cval1 as 'WorkerTaxNumber'
				,'CC' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,iif(year(@DataInicial)<@AnoRecibo,pe2.cval3,pe.Ccusto) as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
				-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,dbo.Phc_DiasFeriado(@DataInicial,@DataFinal)*8 as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as 'WorkerHours'
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal))*8 as 'JobHours'
				,'Não registou horas (CC)' as 'Obs'
			FROM pr(nolock)
				INNER JOIN pe(nolock) ON pr.no=pe.no
				LEFT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp
			WHERE pr.Eliquido<>0 and pe.u_interno=1 and month(pr.data)=@MesRecibo and year(pr.data)=@AnoRecibo
					and pe2.cval1 not in (select WorkerTaxNumber from aaa_tmpWorkersTS) 
			UNION ALL
			SELECT 
				pe2.cval1 as 'WorkerTaxNumber'
				,'FF' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,'Férias' as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)
					-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8 as 'PeriodTotalHours'
				,(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8) as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicial,@DataFinal)*8) as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,iif(isnull(T0.WorkerTotalHours,0)=0
							,(dbo.Phc_DiasUteis(@DataInicial,@DataFinal)-dbo.Phc_DiasFeriado(@DataInicial,@DataFinal))*8
							,T0.WorkerTotalHours+(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8)) as 'WorkerHours'
				,(dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8) as 'JobHours'
				,'Férias (não contabiliza custos) ' as 'Obs'
			FROM pr(nolock)
				INNER JOIN pe(nolock) ON pr.no=pe.no
				LEFT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp
				LEFT JOIN (SELECT 
								WorkerTaxNumber as 'WorkerTaxNumber'
								,MAX(PeriodTotalHours) as 'PeriodTotalHours'
								,MAX(WorkerTotalHours) as 'WorkerTotalHours'
								FROM aaa_tmpWorkersTS
								GROUP BY WorkerTaxNumber) T0 ON T0.WorkerTaxNumber = pe2.cval1
			WHERE pr.Eliquido<>0 and pe.u_interno=1 and month(pr.data)=1 and year(pr.data)=2025
			and (dbo.Phc_DiasFerias(pe.no,@DataInicial,@DataFinal)*8)<>0
			) as SQLView
		ORDER BY SQLView.WorkerName,SQLView.JobCode;


	DELETE FROM aaa_tmpSalaryJobs;

	OPEN csWorkersHours;

	FETCH NEXT FROM csWorkersHours INTO @WorkerTaxNumber,@WorkerNo,@WorkerName,@JobCode,@PeriodTotalHours,@VacationHours,@HolidaysHours,@WorkerHours,@JobHours,@Obs;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @PrStamp = isnull((SELECT prstamp FROM Phc_JobSalaryCost(@MesRecibo,@AnoRecibo) WHERE No=@WorkerNo),'');
		SET @Recibo = isnull(cast((SELECT Recibo FROM Phc_JobSalaryCost(@MesRecibo,@AnoRecibo) WHERE No=@WorkerNo) as char(50)),'');
		SET @CustoRecibo = isnull((SELECT CustoCalculado FROM Phc_JobSalaryCost(@MesRecibo,@AnoRecibo) WHERE No=@WorkerNo),0);

		SET @Recibo = concat('Recibo Nº',@Recibo)
		SET @ObsRecibo = ''

		IF @PrStamp = ''
		begin
			SET @Recibo = 'Não existe'
			SET @ObsRecibo = 'Sem recibo de vencimento'
		end

		IF @PrStamp <> ''
		begin
			SET @CustoObra = isnull((SELECT sum(value) FROM aa_pr_jobs WHERE prstamp=@PrStamp and jobcode=@JobCode),0);
		end

		If @WorkerHours >0
		begin
			SET @PerObra = ((@JobHours*100)/@WorkerHours)/100;
			If @PerObra>1 SET @PerObra = 1;

			SET @CustoCalculado = Round(@CustoRecibo*@PerObra,2);
		end

		If @CustoObra>0
		begin
			SET @SelLine = 0 ;
			IF @PrStamp <> '' SET @ObsRecibo = 'Custo do recibo já distribuído.';
		end
		Else
		begin
			If @JobCode <> 'Férias' SET @SelLine = 1;
		end
		
		INSERT INTO 
			aaa_tmpSalaryJobs(Sel,stamp,PrStamp,WorkerTaxNumber,Nome,HorasUteis,HorasFerias,TotalHoras,Obra,Horas,Percentagem,CustoObra,CustoRecibo,Recibo,CustoJaDistribuido,Observacoes,Notas)
		VALUES (@SelLine,@PrStamp,@PrStamp,@WorkerTaxNumber,@WorkerName,@PeriodTotalHours,@VacationHours,@WorkerHours,@JobCode,@JobHours,@PerObra,@CustoCalculado,@CustoRecibo,@Recibo,@CustoObra,@ObsRecibo,@Obs);


		FETCH NEXT FROM csWorkersHours INTO @WorkerTaxNumber,@WorkerNo,@WorkerName,@JobCode,@PeriodTotalHours,@VacationHours,@HolidaysHours,@WorkerHours,@JobHours,@Obs;
	END;
	
	CLOSE csWorkersHours;
	DEALLOCATE csWorkersHours;
END
GO
