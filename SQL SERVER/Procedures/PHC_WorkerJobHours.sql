SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_WorkerJobHours]
      @DataInicialInternos date
	 ,@DataFinalInternos date 
	 ,@DataInicialExternos date
	 ,@DataFinalExternos date 
	 ,@MesRecibo integer
	 ,@AnoRecibo integer
AS 

BEGIN 
    SET NOCOUNT ON 

	DECLARE @WorkerTaxNumber varchar(50),@WorkerNo int,@WorkerName varchar(250),@JobCode varchar(50);
	DECLARE @PeriodTotalHours decimal(10,2),@VacationHours decimal(10,2),@HolidaysHours decimal(10,2),@WorkerHours decimal(10,2),@JobHours decimal(10,2);
	DECLARE @PrStamp varchar(50),@Recibo varchar(50);
	DECLARE @ObraDefault varchar(30) = isnull((select avalor from e2(nolock) where e1cano=1002 and e1lino=3 and ano=2025),'')

	DECLARE @HorasObra decimal(10,2) = 0;
	DECLARE @PerObra decimal(10,8) = 0;
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
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)*8) as 'HolidaysHours'
				,T0.WorkerTotalHours as 'MwWorkerTotalHours'
				,T0.JobTotalHours as 'MwJobHours'
				,T0.WorkerTotalHours
					+(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8) as 'WorkerHours'
				,T0.JobTotalHours as 'JobHours'
				,'Registo de horas' as 'Obs'
			FROM aaa_tmpAllWorkersTS T0
				LEFT JOIN pe2(nolock) ON T0.WorkerTaxNumber = pe2.cval1
				LEFT JOIN pe(nolock) ON pe2.pe2stamp=pe.pestamp
			WHERE pe.u_interno=1
			UNION ALL 
			SELECT 
				T0.WorkerTaxNumber 
				,'CC' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,iif(year(@DataInicialInternos)<@AnoRecibo,pe2.cval3,pe.Ccusto)  as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)*8) as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,MAX(T0.WorkerTotalHours)
					+(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8) as 'WorkerHours'
				,MAX(T0.PeriodTotalHours)
					-MAX(T0.WorkerTotalHours)
					-(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8) as 'JobHours'
				,'Registo de horas menor(Custo no CC)' as 'Obs'
			FROM aaa_tmpAllWorkersTS T0
				LEFT JOIN pe2(nolock) ON T0.WorkerTaxNumber = pe2.cval1
				LEFT JOIN pe(nolock) ON pe2.pe2stamp=pe.pestamp
			WHERE pe.u_interno=1
			GROUP BY T0.WorkerTaxNumber,pe.ccusto,pe.no,pe.nome,pe2.cval3
			HAVING (MAX(T0.PeriodTotalHours)
					-(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8)
					-MAX(T0.WorkerTotalHours))>0
			UNION ALL 
			SELECT 
				pe2.cval1 as 'WorkerTaxNumber'
				,'CC' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,iif(year(@DataInicialInternos)<@AnoRecibo,pe2.cval3,pe.Ccusto) as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
				-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8 as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)*8 as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8 as 'WorkerHours'
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos))*8 as 'JobHours'
				,'Não registou horas(Custo no CC)' as 'Obs'
			FROM pr(nolock)
				INNER JOIN pe(nolock) ON pr.no=pe.no
				LEFT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp
			WHERE pr.Eliquido<>0 and pe.u_interno=1 and month(pr.data)=@MesRecibo and year(pr.data)=@AnoRecibo
					and pe2.cval1 not in (select WorkerTaxNumber from aaa_tmpAllWorkersTS where Type='Internos') 
			UNION ALL
			SELECT 
				pe2.cval1 as 'WorkerTaxNumber'
				,'FF' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,'Férias' as 'JobCode'
				,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8 as 'PeriodTotalHours'
				,(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8) as 'VacationHours'
				,(dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)*8) as 'HolidaysHours'
				,0 as 'MwWorkerTotalHours'
				,0 as 'MwJobHours'
				,iif(isnull(T0.WorkerTotalHours,0)=0
							,(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos))*8
							,T0.WorkerTotalHours+(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8)) as 'WorkerHours'
				,(dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8) as 'JobHours'
				,'Férias (não contabiliza custos) ' as 'Obs'
			FROM pr(nolock)
				INNER JOIN pe(nolock) ON pr.no=pe.no
				LEFT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp
				LEFT JOIN (SELECT 
								WorkerTaxNumber as 'WorkerTaxNumber'
								,MAX(PeriodTotalHours) as 'PeriodTotalHours'
								,MAX(WorkerTotalHours) as 'WorkerTotalHours'
								FROM aaa_tmpAllWorkersTS WHERE Type='Internos'
								GROUP BY WorkerTaxNumber) T0 ON T0.WorkerTaxNumber = pe2.cval1
			WHERE pr.Eliquido<>0 and pe.u_interno=1 and month(pr.data)=1 and year(pr.data)=2025
			and (dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos)*8)<>0

			UNION ALL -- EXTERNOS

			SELECT 
				T0.WorkerTaxNumber 
				,'MW' as 'Type'
				,pe.no as 'WorkerNo'
				,pe.nome as 'WorkerName'
				,T0.JobCode as 'JobCode'	
				,T0.WorkerTotalHours as 'PeriodTotalHours'
				,0 as 'VacationHours'
				,0 as 'HolidaysHours'
				,T0.WorkerTotalHours as 'MwWorkerTotalHours'
				,T0.JobTotalHours as 'MwJobHours'
				,T0.WorkerTotalHours as 'WorkerHours'
				,T0.JobTotalHours as 'JobHours'
				,'Registo de horas' as 'Obs'
			FROM aaa_tmpAllWorkersTS T0
				LEFT JOIN pe2(nolock) ON T0.WorkerTaxNumber = pe2.cval1
				LEFT JOIN pe(nolock) ON pe2.pe2stamp=pe.pestamp
			WHERE pe.u_interno=0
			) as SQLView
		ORDER BY SQLView.WorkerName,SQLView.JobCode;


	DELETE FROM aaa_tmpSalaryJobs;


	OPEN csWorkersHours;

	FETCH NEXT FROM csWorkersHours INTO @WorkerTaxNumber,@WorkerNo,@WorkerName,@JobCode,@PeriodTotalHours,@VacationHours,@HolidaysHours,@WorkerHours,@JobHours,@Obs;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @PrStamp = isnull((SELECT max(prstamp) FROM Phc_SalaryCost(@MesRecibo,@AnoRecibo) WHERE No=@WorkerNo),'');
		SET @Recibo = isnull(cast((SELECT max(Recibo) FROM Phc_SalaryCost(@MesRecibo,@AnoRecibo) WHERE No=@WorkerNo) as char(50)),'');


		SET @Recibo = concat('Recibo Nº',@Recibo)
		SET @ObsRecibo = ''

		IF @PrStamp = ''
		begin
			SET @Recibo = 'Não existe'
			SET @ObsRecibo = 'Sem recibo de vencimento'
		end

		IF @PrStamp <> ''
		begin
			SET @HorasObra = isnull((SELECT sum(hours) FROM aa_pr_jobshours WHERE prstamp=@PrStamp and jobcode=@JobCode),0);
		end

		If @WorkerHours >0
		begin
			SET @PerObra = ((@JobHours*100)/@WorkerHours)/100;
			If @PerObra>1 SET @PerObra = 1;


		end

		If @HorasObra>0
		begin
			SET @SelLine = 0 ;
			IF @PrStamp <> '' SET @ObsRecibo = 'Horas já distribuidas no recibo.';
		end
		Else
		begin
			If @JobCode <> 'Férias' SET @SelLine = 1;
		end
		
		INSERT INTO 
			aaa_tmpSalaryJobs(Sel,stamp,PrStamp,WorkerTaxNumber,Nome,HorasUteis,HorasFerias,TotalHoras,Obra,Horas,Percentagem,Recibo,Observacoes,Notas)
		VALUES (@SelLine,@PrStamp,@PrStamp,@WorkerTaxNumber,@WorkerName,@PeriodTotalHours,@VacationHours,@WorkerHours,@JobCode,@JobHours,@PerObra,@Recibo,@ObsRecibo,@Obs);


		FETCH NEXT FROM csWorkersHours INTO @WorkerTaxNumber,@WorkerNo,@WorkerName,@JobCode,@PeriodTotalHours,@VacationHours,@HolidaysHours,@WorkerHours,@JobHours,@Obs;
	END;
	
	CLOSE csWorkersHours;
	DEALLOCATE csWorkersHours;

	DECLARE csSalaryWithoutHours CURSOR FOR
	select
		pr.prstamp as 'Stamp',
		pe.no as 'Número',
		pe2.cval1 as 'Contribuinte',
		pe.nome as 'Nome',
		concat('Recibo Nº',pr.recibo) as 'Recibo',
		(dbo.Phc_DiasUteis(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFeriado(@DataInicialInternos,@DataFinalInternos)
					-dbo.Phc_DiasFerias(pe.no,@DataInicialInternos,@DataFinalInternos))*8 as 'Horas'
	from pr (nolock)
	    INNER JOIN pe(nolock) ON pr.no=pe.no
		RIGHT JOIN pe2(nolock) ON pe.pestamp=pe2.pe2stamp			
	where year(data)=@AnoRecibo and month(data)=@MesRecibo
		and pr.prstamp not in (select prstamp from aaa_tmpSalaryJobs);

	OPEN csSalaryWithoutHours;

	FETCH NEXT FROM csSalaryWithoutHours INTO @PrStamp,@WorkerNo,@WorkerTaxNumber,@WorkerName,@Recibo,@WorkerHours;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO 
			aaa_tmpSalaryJobs(Sel,stamp,PrStamp,WorkerTaxNumber,Nome,HorasUteis,HorasFerias,TotalHoras,Obra,Horas,Percentagem,Recibo,Observacoes,Notas)
		VALUES (1,@PrStamp,@PrStamp,@WorkerTaxNumber,@WorkerName,@WorkerHours,0,@WorkerHours,@ObraDefault,@WorkerHours,1,@Recibo,'','Não registou horas(Custo nos Encarregados)');


		FETCH NEXT FROM csSalaryWithoutHours INTO @PrStamp,@WorkerNo,@WorkerTaxNumber,@WorkerName,@Recibo,@WorkerHours;
	END;

	CLOSE csSalaryWithoutHours;
	DEALLOCATE csSalaryWithoutHours;
END
GO
