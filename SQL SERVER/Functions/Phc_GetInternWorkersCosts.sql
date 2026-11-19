SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_GetInternWorkersCosts] (
	@DtInicial as Date,
	@DtFinal as Date
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
	'Trabalhador' = rtrim(pr.nome),
	'Janeiro' = iif(month(pr.data)=1,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Fevereiro' = iif(month(pr.data)=2,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Marco' = iif(month(pr.data)=3,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Abril' = iif(month(pr.data)=4,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Maio' = iif(month(pr.data)=5,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Junho' = iif(month(pr.data)=6,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Julho' = iif(month(pr.data)=7,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Agosto' = iif(month(pr.data)=8,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Setembro' = iif(month(pr.data)=9,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Outubro' = iif(month(pr.data)=10,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Novembro' = iif(month(pr.data)=11,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'Dezembro' = iif(month(pr.data)=12,isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0),
					0),
	'TOTAL' = isnull((convert(decimal(9,2),pr.ESSEVALOR))
					+isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=506 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=502 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(convert(decimal(9,2),CASE WHEN cr=1 THEN prre.ErE ELSE 0 END)) from prre where prre.prstamp=pr.prstamp  and pr.no NOT IN (1,2,14))*0.01),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=501 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(convert(decimal(9,2),(SELECT sum(ere) FROM prre WHERE prre.prstamp=pr.prstamp)- (SELECT sum(ede) FROM prde WHERE prde.prstamp=pr.prstamp)))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=505 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0))
					+(isnull(convert(decimal(9,2),(select sum(CASE WHEN CD=777 THEN prde.EDE ELSE 0 END) from prde where prde.prstamp=pr.prstamp)),0)),0)			
	FROM pr (nolock) 
		INNER JOIN pe(nolock) ON pr.no=pe.no
	WHERE pe.u_obra NOT IN ('','0')  AND pr.data BETWEEN @DtInicial AND @DtFinal
)
GO
