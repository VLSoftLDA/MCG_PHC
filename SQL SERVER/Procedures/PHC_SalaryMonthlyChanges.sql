SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PHC_SalaryMonthlyChanges]
	@NFuncionario integer
	,@Nome varchar(200)
	,@Data date
	,@HorasNormais decimal(10,2)
	,@HorasNoturnas decimal(10,2)
	,@HE50 decimal(10,2)
	,@HE75 decimal(10,2)
	,@HE100 decimal(10,2)
	,@HE200 decimal(10,2)
	,@Jantar decimal(10,2)
	,@FDS decimal(10,2)
	,@AjudasCusto decimal(10,2)
	,@FundoMina decimal(10,2)
	,@AdDiarias decimal(10,2)
AS 

BEGIN 
    SET NOCOUNT ON 
	DECLARE @HSstamp varchar(50)
	DECLARE @VSR decimal(10,2)
	-- HORAS
	IF @HorasNormais<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',5,'Hora Normal',@HorasNormais,1)
	End

	IF @HorasNoturnas<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',4,'Hora Noturna',@HorasNoturnas,1.3)
	End

	IF @HE50<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',1,'Hora Extra 50%',@HE50,1.5)
	End

	IF @HE75<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',2,'Hora Extra 75%',@HE75,1.75)
	End

	IF @HE100<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',3,'Hora Extra 100%',@HE100,2)
	End

	IF @HE200<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,hshecod,tipohora,horas,factor)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,1,'Horas extraordinárias',6,'Hora Extra 200%',@HE200,3)
	End
	-- MOVIMENTOS VARIÁVEIS - Remunerações
	IF @Jantar<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))
		SET @VSR = isnull((SELECT erefeicao FROM pe(nolock) WHERE no=@NFuncionario),0)

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',175,'Subs. Refeição - Jantar',@Jantar,@VSR,@Jantar*@VSR,1)
	End

	IF @FDS<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))
		SET @VSR = isnull((SELECT erefeicao FROM pe(nolock) WHERE no=@NFuncionario),0)

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',176,'Subs. Refeição - FdS',@FDS,@VSR,@FDS*@VSR,1)
	End
	IF @AjudasCusto<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',26,'Ajudas Custo - Nacional',1,@AjudasCusto,@AjudasCusto,1)
	End
	IF @FundoMina<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cr,rem,rqtt,ervu,ere,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',21,'Fundo de Mina',1,@FundoMina,@FundoMina,1)
	End

	-- MOVIMENTOS VARIÁVEIS - Descontos
	IF @AdDiarias<>0
	Begin
		SET @HSstamp = (SELECT left(convert(varchar(36), newid()) + convert(varchar(36), newid()), 25))

		INSERT INTO 
			hs(hsstamp,no,nome,data,dtproc,usadtpr,ntipo,ntipo1,cd,ddesc,erd,hs3tipo)
		VALUES(@HSstamp,@NFuncionario,@Nome,@Data,@Data,1,3,'Movimentos variáveis',510,'Adiantamento Diárias',@AdDiarias,2)
	End

END
GO
