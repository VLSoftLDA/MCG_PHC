SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PHC_SalaryMonthlyChangesWeb]
	@Nif varchar(30)
	,@Nome varchar(200)
	,@Data date
	,@ValorDia decimal(10,2)

	,@SubFerias decimal(10,2)
	,@SubNatal decimal(10,2)

	,@DiasSubRefeicao decimal(10,2)
	,@ValorDiaSubRefeicao decimal(10,2)

	,@IsencaoHorario decimal(10,2)

	,@ComplementoDestacamento decimal(10,2)

	,@HorasFundoMina decimal(10,2)
	,@ValorHoraFundoMina decimal(10,2)

	,@HorasSubsTrabNoturno decimal(10,2)
	,@ValorHoraSubsTrabNoturno decimal(10,2)

	,@DiasAjCustNacional decimal(10,2)
	,@ValorDiaAjCustoNacional decimal(10,2)
	
	,@DiasAjCustoEstr1 decimal(10,2)
	,@ValorDiaAjCustoEstr1 decimal(10,2)

	,@DiasAjCustoEstr2 decimal(10,2)
	,@ValorDiaAjCustoEstr2 decimal(10,2)

	,@PremioFuncao decimal(10,2)
	,@Gratificacoes decimal(10,2)

	,@Kms decimal(10,2)
	,@ValorPorKm decimal(10,2)

	,@AcertosRecibo decimal(10,2)

	,@HorasExtra1 decimal(10,2)
	,@HorasExtra2eSeguintes decimal(10,2)
	,@HoraExtraFdS decimal(10,2)

	,@DiasFalta decimal(10,2)

	,@Adiantamento decimal(10,2)
	,@Penhora decimal(10,2)
	
AS 

BEGIN 
    SET NOCOUNT ON 
	DECLARE @HSstamp varchar(50)
	DECLARE @NFuncionario integer

	set @NFuncionario = (SELECT top 1 no from pe where ncont=@Nif)

	--MOVIMENTOS VARIAVEIS
	--SUBSIDIO FERIAS
	IF @SubFerias<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',5,'Subsídio de Férias',1,@SubFerias,@SubFerias,1)
	End

	--SUBSIDIO NATAL
	IF @SubNatal<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',6,'Subsídio de Natal',1,@SubNatal,@SubNatal,1)
	End

	--SUBSIDIO REFEICAO
	IF @DiasSubRefeicao<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',25,'Subsídio de Refeição',@DiasSubRefeicao,@ValorDiaSubRefeicao,(@DiasSubRefeicao * @ValorDiaSubRefeicao),1)
	End

	--ISENCAO HORARIO
	IF @IsencaoHorario<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',4,'Isenção de Horário',1,@IsencaoHorario,@IsencaoHorario,1)
	End

	--COMPLEMENTO DESTACAMENTO
	IF @ComplementoDestacamento<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',35,'Complemento Destacamento',1,@ComplementoDestacamento,@ComplementoDestacamento,1)
	End

	--FUNDO DE MINA
	IF @HorasFundoMina<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',21,'Fundo de Mina',@HorasFundoMina,@ValorHoraFundoMina,(@HorasFundoMina * @ValorHoraFundoMina),1) 
	End

	--SUBS TRABALHO NOTURNO
	IF @HorasSubsTrabNoturno<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',28,'Subsídio Trabalho Noturno',@HorasSubsTrabNoturno,@ValorHoraSubsTrabNoturno,(@HorasSubsTrabNoturno * @ValorHoraSubsTrabNoturno),1)
	End

	--AJUDAS CUSTO NACIONAL
	IF @DiasAjCustNacional<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',26,'Ajudas de Custo Nac.',@DiasAjCustNacional,@ValorDiaAjCustoNacional,(@DiasAjCustNacional * @ValorDiaAjCustoNacional),1)
	End

	--AJUDAS CUSTO ESTRANGEIRO 1
	IF @DiasAjCustoEstr1<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',40,'Aj.Custo Estrangeiro',@DiasAjCustoEstr1,@ValorDiaAjCustoEstr1,(@DiasAjCustoEstr1 * @ValorDiaAjCustoEstr1),1)
	End

	--AJUDAS CUSTO ESTRANGEIRO 2
	IF @DiasAjCustoEstr2<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',40,'Aj.Custo Estrangeiro',@DiasAjCustoEstr2,@ValorDiaAjCustoEstr2,(@DiasAjCustoEstr2 * @ValorDiaAjCustoEstr2),1)
	End

	--PREMIO FUNCAO
	IF @PremioFuncao<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',34,'Prémio de Função',1,@PremioFuncao,@PremioFuncao,1)
	End

	--GRATIFICAÇÕES
	IF @Gratificacoes<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',20,'Outras Gratificações',1,@Gratificacoes,@Gratificacoes,1)
	End

	--KMS VIATURA PROPRIA
	IF @Kms<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',22,'Km',@Kms,@ValorPorKm,(@Kms * @ValorPorKm),1)
	End

		--ACERTOS RECIBO
	IF @AcertosRecibo<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',121,'Acerto Recibo Vencimento',1,@AcertosRecibo,@AcertosRecibo,1)
	End



	--FIM MOVIMENTOS VARIAVEIS

	-- HORAS EXTRA
	--1ª HORA
	IF @HorasExtra1<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',1,'1ª Hora Extra',@HorasExtra1,1.5)
	End

	--2ª HORA E SEGUINTES
	IF @HorasExtra2eSeguintes<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',2,'2ª Hora Extra e seguintes',@HorasExtra2eSeguintes,1.75)
	End

	--HORAS EXTRA FIM DE SEMANA
	IF @HoraExtraFdS<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',3,'Fins de Semana e Feriados',@HoraExtraFdS,2)
	End

	--FIM HORAS EXTRA

	--DESCONTOS
	--ADIANTAMENTOS
	IF @Adiantamento<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cd,ddesc,erd,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',506,'Adiantamento Salário',@Adiantamento,2)
	End

	--PENHORA
	IF @Penhora<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cd,ddesc,erd,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',505,'Penhora judicial',@Penhora,2)
	End

			--FALTAS
	IF @DiasFalta<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',12,'Desc. Faltas Dia Just.',@DiasFalta,(@ValorDia * (-1)),(@DiasFalta * (@ValorDia * (-1))),1)
	End

	--FIM DESCONTOS

END
GO
