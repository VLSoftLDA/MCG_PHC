SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Phc_WorkerSalary_Cadastro]
(
    @DataInicial date,
    @DataFinal   date,
    @Internos bit,
    @Externos bit,
    @Ativos bit,
    @Inativos bit
)
RETURNS TABLE 
AS
RETURN 
(
    SELECT 
        CAST(pr.Recibo AS char(15))                      AS 'Recibo',
        pr.CCusto,
        CAST(pe.Estab AS char(15))                       AS 'Estab',
        CONVERT(char(10),@DataInicial,120)               AS 'DataInicial',
        CONVERT(char(10),@DataFinal,120)                 AS 'DataFinal',
        CONVERT(char(10),pr.data,120)                    AS 'DataRecibo',
        CAST(pr.No AS char(15))                          AS 'Número',
        pr.Nome,
        IIF(pe.u_interno=1,'Sim','Não')                  AS 'Interno',
        pr.Ncont                                         AS 'Nif',
        pe2.nmdpt                                        AS 'Departamento',
        CAST(pe.nfilhos AS char(15))                     AS 'Filhos',
        pe.ECIVIL                                        AS 'Ecivil',
        CAST((DATEDIFF(month,pe.nasc,GETDATE())/12) AS char(15)) AS 'Idade',
        pe.Sexo                                          AS 'Sexo',
        pe.morada                                        AS 'Morada',
        pe.local                                         AS 'Localidade',
        pe.codpost                                       AS 'CodigoPostal',
        pe2.CODPAIS                                      AS 'Nacionalidade',
        SUM(TL.SujeitoSS)                                AS 'SujeitoSS',
        SUM(TL.SujeitoIRS)                               AS 'SujeitoIRS',
        pr.txssp                                         AS 'TxSSFuncionario',
        pr.txsse                                         AS 'TxSSEmpresa',
        CONVERT(decimal(9,2),pr.ESSEVALOR)               AS 'SSEmpresa',
        SUM(IIF(T1.ss=1 OR (T1.ss=0 AND T1.sr=1),TL.SujeitoSS,0))*(pr.txssp/100) AS 'SSFuncionário',
        SUM(IIF(T1.codirs=1,TL.Total,0))                 AS 'IRS',
        pr.eliquido                                      AS 'Liquido',
        pr.dias                                          AS 'DiasTrabalho',
        SUM(IIF(TL.Tipo='Remuneração',TL.Total,0))      AS 'Ilíquido',
        SUM(IIF(TL.Codigo=1,TL.Total,0))                AS 'BaseRecibo',
        SUM(IIF(T1.sr=1 AND T1.genero=0,TL.Total,0))    AS 'SubRefeição',
        SUM(IIF(T1.sr=1 AND T1.genero=1,TL.Total,0))    AS 'SubRefeiçãoCartão',
        SUM(IIF(TL.Codigo=4,TL.Total,0))                AS 'IsençãoHorário',
        SUM(IIF(T1.ferias=1,TL.Total,0))                AS 'SubFérias',
        SUM(IIF(T1.natal=1,TL.Total,0))                 AS 'SubNatal',
        SUM(IIF(T1.codhe=1,TL.Total,0))                 AS 'HorasExtras',
        SUM(IIF(T1.nocturno=1,TL.Total,0))              AS 'SubNoturno',
        SUM(IIF(TL.Codigo=21,TL.Total,0))               AS 'FundoMina',
        SUM(IIF(TL.codigo=22 or TL.codigo=39,TL.Total,0))               AS 'Kms',
        SUM(IIF(TL.Codigo=20,TL.Total,0))               AS 'OutrasGratificações',
        SUM(IIF(T1.ajcusto=1 ,TL.Total,0))              AS 'AjCustoNacionais',
        SUM(IIF(T1.eajcusto=1,TL.Total,0))              AS 'AjCustoEstrangeiro',
        SUM(IIF(T1.indemn=1 ,TL.Total,0))               AS 'Indemnização',
        SUM(IIF(TL.Codigo=32 ,TL.Total,0))              AS 'GratificaçõesBalanço',
        SUM(IIF(TL.Codigo=34,TL.Total,0))               AS 'PrémioFunção',
        SUM(IIF(TL.Codigo=89 ,TL.Total,0))              AS 'PrémioSegurança',
        SUM(IIF(TL.Codigo=35 ,TL.Total,0))              AS 'ComplementoDestacamento',
        SUM(IIF(T1.especie=1 ,TL.Total,0))              AS 'RendimentoEspécie',
        SUM(IIF(TL.Codigo=100 ,TL.Total,0))             AS 'FériasNãoGozadas',
        SUM(IIF(TL.Codigo=101 ,TL.Total,0))             AS 'RetOrdBase',
        SUM(IIF(TL.Codigo=117 ,TL.Total,0))             AS 'RetSubFérias',
        SUM(IIF(TL.Codigo=172 ,TL.Total,0))             AS 'RetSubNatal',
        SUM(IIF(TL.Codigo=50 ,TL.Total,0))              AS 'PrémioProdutividade',
        SUM(IIF(TL.codigo=45,TL.Total,0))               AS 'SubsídioPernoita',
        SUM(IIF(TL.codigo=91,TL.Total,0))               AS 'SuplementoPiquete',
        SUM(IIF(TL.codigo=44,TL.Total,0))               AS 'BolsaEstágio',
        SUM(IIF(T1.flthora=1 OR T1.fltdia=1 OR T1.fltmes=1,TL.Total,0)) AS 'Faltas',
        SUM(IIF(TL.codigo=506,TL.Total,0))              AS 'Adiantamento',
        SUM(IIF(TL.codigo=507,TL.Total,0))              AS 'PenhoraVencimento',
        SUM(IIF(TL.codigo=505,TL.Total,0))              AS 'PenhoraJudicial',
        SUM(IIF(TL.codigo=777,TL.Total,0))              AS 'DescontoSeguro',
        SUM(IIF(TL.codigo=56,TL.Total,0))               AS 'SubSegurançaParagem',
        SUM(IIF(TL.codigo=57,TL.Total,0))               AS 'SubSegurançaS/Pernoita',
        SUM(IIF(TL.codigo=58,TL.Total,0))               AS 'SubSegurançaC/Pernoita',
        SUM(IIF(TL.codigo=30,TL.Total,0))               AS 'CompensaçãoP/CessaçãoCT',
        SUM(IIF(TL.Tipo='Remuneração',TL.Total,0)) + pr.ESSEVALOR AS 'TotalCusto',
        pe2.dcategoria                                  AS 'Categoria Recibo',
		pe.dataadm as 'Data de Admissão',
        tpcontrato.tpcontrato                            AS 'TipoContrato',
        CONVERT(char(10),ISNULL(hp_inicio.datainicontrato, hp_mes.datainicontrato),120)  AS 'ContratoInicio',
        CASE 
            WHEN hp_mes.datafimcontrato <> '19000101'
                 AND hp_mes.datafimcontrato BETWEEN limites.DataInicioMes AND limites.DataFimMes
            THEN hp_mes.datafimcontrato
            ELSE CONVERT(date,'19000101')
        END                                               AS 'ContratoFim',
        hp_mes.CODMOTIVOSENTR                             AS 'MotEntrada',
        CASE 
            WHEN hp_mes.datafimcontrato <> '19000101'
                 AND hp_mes.datafimcontrato BETWEEN limites.DataInicioMes AND limites.DataFimMes
            THEN hp_mes.CODMOTIVOSSAID
            ELSE ''
        END                                               AS 'MotSaida'

    FROM pr (NOLOCK)

    LEFT JOIN (
        SELECT prstamp,'Remuneração' Tipo,cr Codigo,rem Designacao,
               SUM(rqtt) Quantidade,SUM(ervu) PUnit,SUM(ere) Total,
               SUM(ereirs) SujeitoIRS,SUM(esujss) SujeitoSS
        FROM prre (NOLOCK)
        WHERE cr>0
        GROUP BY prstamp,cr,rem

        UNION ALL

        SELECT prstamp,'Desconto',cd,des,
               SUM(dqtt),SUM(ede),SUM(ede),
               0,0
        FROM prde (NOLOCK)
        WHERE cd>0
        GROUP BY prstamp,cd,des
    ) TL ON pr.prstamp = TL.prstamp

    LEFT JOIN cm6 (NOLOCK) T1 ON TL.codigo = T1.cm AND T1.inactivo=0
    LEFT JOIN pe (NOLOCK)  ON pe.no=pr.no 
    LEFT JOIN pe2 (NOLOCK) ON pe.pestamp=pe2.pe2stamp

    -- Limites do mês do recibo
    OUTER APPLY (
        SELECT 
            DATEFROMPARTS(YEAR(pr.data), MONTH(pr.data), 1) AS DataInicioMes,
            EOMONTH(pr.data)                                AS DataFimMes
    ) limites

    -- Contrato ativo no mês
    OUTER APPLY (
        SELECT TOP 1 *
        FROM hp (NOLOCK)
        WHERE hp.tipo=1
          AND hp.no=pe.no
          AND hp.renova IN (0,1)
          AND hp.datainicontrato <= limites.DataFimMes
          AND (hp.datafimcontrato='19000101' OR hp.datafimcontrato>=limites.DataInicioMes)
        ORDER BY hp.datafimcontrato DESC,
                 hp.datainicontrato DESC,
                 hp.usrhora DESC,
                 hp.data DESC
    ) hp_mes

    -- Início real da cadeia
    OUTER APPLY (
        SELECT TOP 1 hp_base.datainicontrato
        FROM hp hp_base (NOLOCK)
        WHERE hp_base.no = pe.no
          AND hp_base.contrato = hp_mes.contrato
          AND hp_base.renova = 0
          AND hp_base.datafimcontrato = DATEADD(DAY,-1,hp_mes.datainicontrato)
        ORDER BY hp_base.datainicontrato ASC
    ) hp_inicio

    LEFT JOIN tpcontrato (NOLOCK)
           ON hp_mes.contrato = tpcontrato.codcontrato

    WHERE pr.data BETWEEN @DataInicial AND @DataFinal

    AND (
               (@Internos = 1 AND pe.u_interno = 1)
               OR
               (@Externos = 1 AND pe.u_interno = 0)
         )

    AND (
               (@Ativos = 1 AND ISNULL(pe.status,0) <> 3)
               OR
               (@Inativos = 1 AND pe.status = 3)
         )

    GROUP BY 
        pr.Recibo,pr.CCusto,pe.Estab,pr.data,pr.No,pr.ESSEVALOR,
        pr.eliquido,pr.Nome,pe.u_interno,pr.Ncont,pe2.nmdpt,
        pe.nfilhos,pe.ECIVIL,pe.nasc,pr.txssp,pr.txsse,
        pe2.dcategoria,pe.dataadm,pe.sexo,pe.morada,pe.local,pe.codpost,pe2.codpais,pr.dias,
        tpcontrato.tpcontrato,
        hp_inicio.datainicontrato,
        hp_mes.datainicontrato,
        hp_mes.datafimcontrato,
        hp_mes.CODMOTIVOSENTR,
        hp_mes.CODMOTIVOSSAID,
        limites.DataInicioMes,
        limites.DataFimMes
)
GO
