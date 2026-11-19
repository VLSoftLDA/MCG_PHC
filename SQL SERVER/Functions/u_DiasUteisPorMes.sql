SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION u_DiasUteisPorMes
(
    @Ano INT
)
RETURNS TABLE 
AS
RETURN 
(
    WITH MonthRange AS (
        SELECT 
            DATEFROMPARTS(@Ano, Month, 1) AS StartDate,
            EOMONTH(DATEFROMPARTS(@Ano, Month, 1)) AS EndDate,
            Month
        FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS Months(Month)
    )
    SELECT 
        MonthRange.Month,
        (DATEDIFF(DAY, StartDate, EndDate) + 1) 
        - (DATEDIFF(WEEK, StartDate, EndDate) * 2) 
        - (CASE WHEN DATENAME(WEEKDAY, StartDate) = 'Sunday' THEN 1 ELSE 0 END) 
        - (CASE WHEN DATENAME(WEEKDAY, EndDate) = 'Saturday' THEN 1 ELSE 0 END)
        - ISNULL((
            SELECT SUM(CASE 
                WHEN DATEPART(dw, data) = 1 OR DATEPART(dw, data) = 7 THEN 0 
                ELSE 1 
            END) 
            FROM ff (NOLOCK)
            WHERE data >= StartDate AND data <= EndDate
        ), 0) AS Workdays
    FROM MonthRange
)
GO
