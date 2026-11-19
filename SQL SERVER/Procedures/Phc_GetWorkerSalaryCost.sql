SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Phc_GetWorkerSalaryCost]
    @AnoRec int,
    @MesRec int
AS
BEGIN
    EXEC dbo.PHC_SalaryAccountingWithJobV4
         @Ano = @AnoRec,
         @Mes = @MesRec;

    SELECT
        CONCAT(@MesRec, '/', @AnoRec) AS Periodo,
        pr.nome AS Funcionário,
        CAST(T0.recibo AS char(15)) AS Recibo,
        SUM(T0.valor_deb - T0.valor_cre) AS Custo
    FROM aaa_tmpSalaryAccounting T0
		INNER JOIN pr ON T0.prstamp = pr.prstamp
    WHERE Conta LIKE '6%'
    GROUP BY T0.recibo, pr.nome
	ORDER BY pr.nome;
END;

SET ANSI_NULLS ON
GO
