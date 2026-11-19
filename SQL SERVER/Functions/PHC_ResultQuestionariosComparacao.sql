SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[PHC_ResultQuestionariosComparacao]
(	
)
RETURNS TABLE 
AS
RETURN 
(
select * from (

select 
'Nome' = pe1.nome,
'Func_Status'= pe1.status,
'isAvaliador' = (select qur.lresp from qur where codigo='FormAvalCGen' and qur.pergunta='isAvaliador' and qur.oristamp=pe1.pestamp),
'NumAvaliador' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='NumAvaliador' and qur.oristamp=pe1.pestamp),
'Departamento' = (select qur.cresp from qur where codigo='FormAvalCGen' and qur.pergunta='Departamento' and qur.oristamp=pe1.pestamp), 
'Questionario' = 'Avaliação',
'Comp_DiscEtica' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaDisciplina_media' and qur.oristamp=pe1.pestamp),
'Comp_SentResp' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaSentido_media' and qur.oristamp=pe1.pestamp), 
'Comp_EspEquipa' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaEspirito_media' and qur.oristamp=pe1.pestamp), 
'Comp_RelInterp' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaRelInterp_media' and qur.oristamp=pe1.pestamp), 
'Comp_Comunicacao' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaComunicacao_media' and qur.oristamp=pe1.pestamp), 
'Comp_PlanOrg' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaPlaneamento_media' and qur.oristamp=pe1.pestamp), 
'Comp_ResolProb' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaResolucao_media' and qur.oristamp=pe1.pestamp), 
'Comp_MotivDed' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaMotivacao_media' and qur.oristamp=pe1.pestamp), 
'Comp_SegAmb' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaSeguranca_media' and qur.oristamp=pe1.pestamp), 
'Comp_QualidProd' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaQualidade_media' and qur.oristamp=pe1.pestamp),
'Comp_AdapDesProf' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaAdaptacao_media' and qur.oristamp=pe1.pestamp),
'Comp_ConhecComp' = (select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaConhecimentos_media' and qur.oristamp=pe1.pestamp),
'RespDep_Lid' =  NULLIF((select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaLideranca_media' and qur.oristamp=pe1.pestamp),0), 
'RespDep_VisaoEst' =  NULLIF((select qur.nresp from qur where codigo='FormAvalCGen' and  qur.pergunta='TabelaVisao_media' and qur.oristamp=pe1.pestamp),0), 
    CASE 
        WHEN (SELECT qur.lresp 
              FROM qur 
              WHERE codigo = 'FormAvalCGen' 
                AND qur.pergunta = 'isAvaliador' 
                AND qur.oristamp = pe1.pestamp
             ) = 0
        THEN (SELECT qur.nresp 
              FROM qur 
              WHERE codigo = 'FormAvalCGen' 
                AND qur.pergunta = 'TabelaGlobal1_media' 
                AND qur.oristamp = pe1.pestamp
             )
        ELSE (SELECT qur.nresp 
              FROM qur 
              WHERE codigo = 'FormAvalCGen' 
                AND qur.pergunta = 'TabelaGlobal2_media' 
                AND qur.oristamp = pe1.pestamp
             )
    END AS AvGlobal
from pe pe1
left join pe2 on pe1.pestamp=pe2.pe2stamp
where pe1.pestamp in (select oristamp from qur)
and ((select qur.lresp from qur where codigo='FormAvalCGen' and qur.pergunta='Fechado' and qur.oristamp=pe1.pestamp)=1)   --questionario fechado
and ((select qur.lresp from qur where codigo='FormAutoavCGen' and qur.pergunta='Fechado'  and qur.oristamp=pe1.pestamp)=1)   --questionario fechado

UNION ALL

select 
'Nome' = pe1.nome,
'Func_Status'= pe1.status,
'isAvaliador' = (select qur.lresp from qur where codigo='FormAutoavCGen' and qur.pergunta='isAvaliador' and qur.oristamp=pe1.pestamp),
'NumAvaliador' = (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='NumAvaliador' and qur.oristamp=pe1.pestamp),
'Departamento' = (select qur.cresp from qur where codigo='FormAutoavCGen' and qur.pergunta='Departamento' and qur.oristamp=pe1.pestamp),
'Questionario' = 'Autoavaliação',
'Comp_DiscEtica' = (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaDisciplina_media' and qur.oristamp=pe1.pestamp),
'Comp_SentResp' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaSentido_media' and qur.oristamp=pe1.pestamp), 
'Comp_EspEquipa' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaEspirito_media' and qur.oristamp=pe1.pestamp), 
'Comp_RelInterp' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaRelInterp_media' and qur.oristamp=pe1.pestamp), 
'Comp_Comunicacao' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaComunicacao_media' and qur.oristamp=pe1.pestamp), 
'Comp_PlanOrg' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaPlaneamento_media' and qur.oristamp=pe1.pestamp), 
'Comp_ResolProb' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaResolucao_media' and qur.oristamp=pe1.pestamp), 
'Comp_MotivDed' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaMotivacao_media' and qur.oristamp=pe1.pestamp), 
'Comp_SegAmb' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaSeguranca_media' and qur.oristamp=pe1.pestamp), 
'Comp_QualidProd' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaQualidade_media' and qur.oristamp=pe1.pestamp),
'Comp_AdapDesProf' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaAdaptacao_media' and qur.oristamp=pe1.pestamp),
'Comp_ConhecComp' = (select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaConhecimentos_media' and qur.oristamp=pe1.pestamp),
'RespDep_Lid' =  NULLIF((select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaLideranca_media' and qur.oristamp=pe1.pestamp),0), 
'RespDep_VisaoEst' =  NULLIF((select qur.nresp from qur where codigo='FormAutoavCGen' and  qur.pergunta='TabelaVisao_media' and qur.oristamp=pe1.pestamp),0), 
    CASE 
        WHEN (SELECT qur.lresp 
              FROM qur 
              WHERE codigo = 'FormAutoavCGen' 
                AND qur.pergunta = 'isAvaliador' 
                AND qur.oristamp = pe1.pestamp
             ) = 0
        THEN (SELECT qur.nresp 
              FROM qur 
              WHERE codigo = 'FormAutoavCGen' 
                AND qur.pergunta = 'TabelaGlobal1_media' 
                AND qur.oristamp = pe1.pestamp
             )
        ELSE (SELECT qur.nresp 
              FROM qur 
              WHERE codigo = 'FormAutoavCGen' 
                AND qur.pergunta = 'TabelaGlobal2_media' 
                AND qur.oristamp = pe1.pestamp
             )
    END AS AvGlobal
from pe pe1
left join pe2 on pe1.pestamp=pe2.pe2stamp
where pe1.pestamp in (select oristamp from qur)
and ((select qur.lresp from qur where codigo='FormAvalCGen' and qur.pergunta='Fechado' and qur.oristamp=pe1.pestamp)=1)   --questionario fechado
and ((select qur.lresp from qur where codigo='FormAutoavCGen' and qur.pergunta='Fechado'  and qur.oristamp=pe1.pestamp)=1)   --questionario fechado

UNION ALL

select 
'Nome' = pe1.nome,
'Func_Status'= pe1.status,
'isAvaliador' = (select qur.lresp from qur where codigo='FormAvalCGen' and qur.pergunta='isAvaliador' and qur.oristamp=pe1.pestamp),
'NumAvaliador' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='NumAvaliador' and qur.oristamp=pe1.pestamp),
'Departamento' = (select qur.cresp from qur where codigo='FormAvalCGen' and qur.pergunta='Departamento' and qur.oristamp=pe1.pestamp),
'Questionario' = 'Comparação',
'Comp_DiscEtica' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaDisciplina_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaDisciplina_media' and qur.oristamp=pe1.pestamp),
'Comp_SentResp' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaSentido_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaSentido_media' and qur.oristamp=pe1.pestamp),
'Comp_EspEquipa' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaEspirito_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaEspirito_media' and qur.oristamp=pe1.pestamp),
'Comp_RelInterp' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaRelInterp_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaRelInterp_media' and qur.oristamp=pe1.pestamp),
'Comp_Comunicacao' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaComunicacao_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaComunicacao_media' and qur.oristamp=pe1.pestamp),
'Comp_PlanOrg' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaPlaneamento_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaPlaneamento_media' and qur.oristamp=pe1.pestamp),
'Comp_ResolProb' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaResolucao_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaResolucao_media' and qur.oristamp=pe1.pestamp),
'Comp_MotivDed' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaMotivacao_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaMotivacao_media' and qur.oristamp=pe1.pestamp),
'Comp_SegAmb' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaSeguranca_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaSeguranca_media' and qur.oristamp=pe1.pestamp),
'Comp_QualidProd' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaQualidade_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaQualidade_media' and qur.oristamp=pe1.pestamp),
'Comp_AdapDesProf' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaAdaptacao_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaAdaptacao_media' and qur.oristamp=pe1.pestamp),
'Comp_ConhecComp' = (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaConhecimentos_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaConhecimentos_media' and qur.oristamp=pe1.pestamp),
'RespDep_Lid' =  (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaLideranca_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaLideranca_media' and qur.oristamp=pe1.pestamp),
'RespDep_VisaoEst' =  (select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaVisao_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaVisao_media' and qur.oristamp=pe1.pestamp),
CASE 
        WHEN (SELECT qur.lresp 
              FROM qur 
              WHERE codigo = 'FormAvalCGen' 
                AND qur.pergunta = 'isAvaliador' 
                AND qur.oristamp = pe1.pestamp
             ) = 0
        THEN
		(select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaGlobal1_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaGlobal1_media' and qur.oristamp=pe1.pestamp)
		ELSE
		(select qur.nresp from qur where codigo='FormAvalCGen' and qur.pergunta='TabelaGlobal2_media' and qur.oristamp=pe1.pestamp) - (select qur.nresp from qur where codigo='FormAutoavCGen' and qur.pergunta='TabelaGlobal2_media' and qur.oristamp=pe1.pestamp)
END AS AvGlobal
from pe pe1
left join pe2 on pe1.pestamp=pe2.pe2stamp
where pe1.pestamp in (select oristamp from qur) 
and ((select qur.lresp from qur where codigo='FormAvalCGen' and qur.pergunta='Fechado' and qur.oristamp=pe1.pestamp)=1)   --questionario fechado
and ((select qur.lresp from qur where codigo='FormAutoavCGen' and qur.pergunta='Fechado'  and qur.oristamp=pe1.pestamp)=1)   --questionario fechado

)subquery
)
GO
