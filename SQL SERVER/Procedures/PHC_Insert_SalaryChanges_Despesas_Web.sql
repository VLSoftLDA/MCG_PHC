SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Procedimento utilizado para Inserir Descontos de Subs. Alimentação na Aprovação de Despesas
--As regras de quem leva desconto estão repetidas no script GetFuncDescontoSubsidio (manter iguais)

CREATE PROCEDURE [dbo].[PHC_Insert_SalaryChanges_Despesas_Web]
    @dlstamp VARCHAR(30),
	@iniciais VARCHAR(3),
	@excluir VARCHAR(MAX) = '' --nºs de funcionário sem desconto, separados por vírgula (desmarcados na aprovação)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @tipoDespesa VARCHAR(100);
    DECLARE @dsstamp VARCHAR(50);
	DECLARE @funcno int;
    DECLARE @Data DATE;
    DECLARE @noPrincipal INT;
    DECLARE @u_funint VARCHAR(MAX);

    -- Obter DS
    SELECT 
		@tipoDespesa = (SELECT TRIM(descricao) FROM tds WHERE tdsstamp = dl.tdsstamp),
        @dsstamp = dl.dsstamp
    FROM dl
    WHERE dl.dlstamp = @dlstamp;

	SELECT
			@Data = ds.data,
			@funcno = ds.no
	FROM ds
		WHERE ds.dsstamp = @dsstamp;

		--apenas se for despesa de almoço e não for fim de semana (o feriado é verificado por funcionário, em Dados)
	IF TRIM(@tipoDespesa) IN ('ALMOÇO')
		-- fim de semana: 01/01/1900 foi segunda-feira, logo 5 = sábado e 6 = domingo
		-- (não depende do idioma da sessão, ao contrário do DATENAME, nem do DATEFIRST)
		AND DATEDIFF(DAY, '19000101', @Data) % 7 NOT IN (5, 6)

	BEGIN
		SELECT
			@noPrincipal = ds.no,
			@u_funint = ds.u_funint
		FROM ds
		WHERE ds.dsstamp = @dsstamp;

		-- Inclui pe.no principal + internos
		-- UNION (e não UNION ALL) para não lançar dois descontos ao mesmo funcionário
		-- quando ele aparece repetido (ex.: quem registou também está no u_funint)
		;WITH Lista AS (
			-- funcionário que registou
			SELECT @noPrincipal AS no

			UNION

			-- funcionários internos adicionais
			-- TRY_CAST: um valor não numérico é ignorado em vez de fazer falhar a aprovação
			SELECT TRY_CAST(TRIM(value) AS INT)
			FROM STRING_SPLIT(@u_funint, ',')
			WHERE TRY_CAST(TRIM(value) AS INT) IS NOT NULL
		),

		-- Obter dados (PE)
		Dados AS (
			SELECT 
				L.no,
				pe.nome,
				pe.erefeicao
			FROM Lista L
			INNER JOIN pe ON pe.no = L.no
			INNER JOIN pe2 ON pe.pestamp = pe2.pe2stamp
			where 
			pe2.u_estagiar = 0 --exclui estagiários
			and pe.no not in (2, 1056) --exclui funcionários especificos
			and pe.erefeicao > 0 --sem valor de refeição não há desconto a lançar
			--não é feriado para o funcionário (feriado não exclusivo ou exclusivo do estabelecimento dele)
			and NOT EXISTS (
				SELECT 1
				FROM ff WITH (NOLOCK)
				WHERE ((ff.data = @Data AND (ff.dataf = @Data OR ff.dataf = ff.data))
				    OR (ff.fixo = 1 AND ff.diai = (MONTH(@Data) * 100 + DAY(@Data)) AND ff.diai = ff.diaf))
				  AND ff.nope = 0
				  AND (ff.exclusivo = 0 OR ff.estab = pe.estab)
			)
			and L.no not in ( --desmarcados na página de aprovação
				SELECT TRY_CAST(TRIM(value) AS INT)
				FROM STRING_SPLIT(ISNULL(@excluir, ''), ',')
				WHERE TRY_CAST(TRIM(value) AS INT) IS NOT NULL
			)
		)

		-- Inserir na HS para CADA funcionário
		INSERT INTO hs (
			hsstamp, no, nome, data, dtproc, usadtpr,
			ntipo, ntipo1, cr, rem, rqtt, ervu, ere, hs3tipo,ousrinis,usrinis, u_stampds
		)
		SELECT
			LEFT(CONVERT(VARCHAR(36), NEWID()) + CONVERT(VARCHAR(36), NEWID()), 25),
			D.no,
			D.nome,
			@Data,
			@Data,
			1,
			3,
			'Movimentos variáveis',
			49,
			'Sub. de Refeição Cartão',
			-1,
			D.erefeicao,
			-1 * D.erefeicao,
			1,
			@iniciais,
			@iniciais,
			@dsstamp
		FROM Dados D
		
		-- verificacao se já tem desconto nesse dia
		WHERE NOT EXISTS (
		SELECT 1
		FROM hs h
		WHERE h.no = D.no
		  AND h.data = @Data
		  AND h.cr = 49
		  AND h.ntipo = 3
		  AND h.rqtt < 0
	);
	END
END
GO
