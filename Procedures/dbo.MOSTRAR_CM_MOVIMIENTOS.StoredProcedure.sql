/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS]-- 1,335,'2022-01-01','2024-01-01',1
@iTipo int,
@iCodigoDestinoCombo int,
@dInicio date,
@dFin date,
@bTodos bit
--WITH RECOMPILE
as

set nocount on;

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

if @bTodos = 0
begin
	select 
		g.iCodigo,
		g.iTipo,
		case when g.iTipo = 1 then 'SULFUROS' else 'OXIDOS' end cTipo,
		g.dFechaRPT,
		g.cTurno,
		g.dFechaHora,
		g.cObservaciones,
		g.bAuto,
		case when g.bAuto = 1 then 'AUTOMATICO' else 'MANUAL' end cAuto,
		l.nCueq,
		l.nCut,
		l.nCus,
		l.nAu,
		l.nAg,
		l.nMo,
		l.nAs,
		l.nCo3,
		l.nNo3,
		l.nFet,
		l.nPy_Aux,
		l.nLeyc_Cut,
		l.nLeyc_Au,
		l.nRecg_Cu,
		l.nRecg_Au,
		l.nBwi,
		l.nTph_Sag,
		l.nCpy_Ajus,
		l.nCccv_Ajus,
		l.nBo_Ajus,
		l.nAxb,
		l.nVsed_E,
		l.nCp_Pond,
		l.nLey_Con_Rou,
		l.nDominio,
		l.nIns,
		l.nHum,
		l.nRec_Heap,
		l.nRec_Rom,
		l.nCan_Heap,
		l.nCan_Rom,
		l.nM100,
		l.nM400,
		e.cCodigoPala,
		e.cCodigoFlotaPala,
		e.cCodigoCamion,
		e.cCodigoFlotaCamion,
		e.nToneladas,
		e.nToneladasFlat,
		o.iCodigoOrigen,
		o.nEastingOrigen,
		o.nNorthingOrigen,
		o.nElevationOrigen,
		o.nLongitudOrigen,
		o.nLatitudOrigen,
		deto.cCodigoEstadistica cDescripcionOrigen,
		deto.cCalidadMineral cCalidadOrigen,
		deto.cRegionTajo cRegionTajoOrigen,
		deto.cTipo cTipoOrigen,
		d.iCodigoDestino,
		d.nEastingDestino,
		d.nNorthingDestino,
		d.nElevationDestino,
		d.nLongitudDestino,
		d.nLatitudDestino,
		detd.cCodigoEstadistica cDescripcionDestino,
		detd.cCalidadMineral cCalidadDestino,
		detd.cRegionTajo cRegionTajoDestino,
		detd.cTipo cTipoDestino,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		@bTodos bTodos,
		l.bCondicion,
		l.cCondicion
    into #TempGeneral
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_LEY l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join VIST_CM_UBICACIONES deto with(nolock) on
				o.iCodigoOrigen = deto.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join VIST_CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
	where
		iTipo = @iTipo and
		(iCodigoOrigen = @iCodigoDestinoCombo or iCodigoDestino = @iCodigoDestinoCombo) and
		dFechaRPT between @dInicio and @dFin

	select ROW_NUMBER() OVER(ORDER BY dFechaHora ASC , cDescripcionOrigen ASC) AS Id, * from #TempGeneral order by 1 asc

	declare @nTotal1 float = (select sum(nToneladasFlat) from #TempGeneral where iCodigoDestino <> @iBalance)
	select 1 nOrden, 'Total' cConcepto, sum(nToneladasFlat) nToneladasFlat, count(1) nMovimientos, 100 nPorcentaje from #TempGeneral where iCodigoDestino <> @iBalance
	union all
	select 2 nOrden, 'Condición' cConcepto, sum(nToneladasFlat) nToneladasFlat, count(1) nMovimientos, case when isnull(@nTotal1,0) = 0 then 0 else sum(nToneladasFlat) * 100.0 / @nTotal1 end nPorcentaje  from #TempGeneral where bCondicion = 1 and iCodigoDestino <> @iBalance

	select ROW_NUMBER() OVER(ORDER BY dFechaHora ASC , cDescripcionOrigen ASC) AS Id, * from #TempGeneral where bCondicion = 1 order by 1 asc
end
else
begin
	select 
		g.iCodigo,
		g.iTipo,
		case when g.iTipo = 1 then 'SULFUROS' else 'OXIDOS' end cTipo,
		g.dFechaRPT,
		g.cTurno,
		g.dFechaHora,
		g.cObservaciones,
		g.bAuto,
		case when g.bAuto = 1 then 'AUTOMATICO' else 'MANUAL' end cAuto,
		l.nCueq,
		l.nCut,
		l.nCus,
		l.nAu,
		l.nAg,
		l.nMo,
		l.nAs,
		l.nCo3,
		l.nNo3,
		l.nFet,
		l.nPy_Aux,
		l.nLeyc_Cut,
		l.nLeyc_Au,
		l.nRecg_Cu,
		l.nRecg_Au,
		l.nBwi,
		l.nTph_Sag,
		l.nCpy_Ajus,
		l.nCccv_Ajus,
		l.nBo_Ajus,
		l.nAxb,
		l.nVsed_E,
		l.nCp_Pond,
		l.nLey_Con_Rou,
		l.nDominio,
		l.nIns,
		l.nHum,
		l.nRec_Heap,
		l.nRec_Rom,
		l.nCan_Heap,
		l.nCan_Rom,
		l.nM100,
		l.nM400,
		e.cCodigoPala,
		e.cCodigoFlotaPala,
		e.cCodigoCamion,
		e.cCodigoFlotaCamion,
		e.nToneladas,
		e.nToneladasFlat,
		o.iCodigoOrigen,
		o.nEastingOrigen,
		o.nNorthingOrigen,
		o.nElevationOrigen,
		o.nLongitudOrigen,
		o.nLatitudOrigen,
		deto.cCodigoEstadistica cDescripcionOrigen,
		deto.cCalidadMineral cCalidadOrigen,
		deto.cRegionTajo cRegionTajoOrigen,
		deto.cTipo cTipoOrigen,
		d.iCodigoDestino,
		d.nEastingDestino,
		d.nNorthingDestino,
		d.nElevationDestino,
		d.nLongitudDestino,
		d.nLatitudDestino,
		detd.cCodigoEstadistica cDescripcionDestino,
		detd.cCalidadMineral cCalidadDestino,
		detd.cRegionTajo cRegionTajoDestino,
		detd.cTipo cTipoDestino,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		@bTodos bTodos,
		l.bCondicion,
		l.cCondicion
	into #TempDestino
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			left join CM_MOVIMIENTOS_LEY l with(nolock) on
				g.iCodigo = l.iCodigo
			left join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			left join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			left join VIST_CM_UBICACIONES deto with(nolock) on
				o.iCodigoOrigen = deto.iCodigo
			left join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			left join VIST_CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
	where
		iTipo = @iTipo and
		dFechaRPT between @dInicio and @dFin

	select ROW_NUMBER() OVER(ORDER BY dFechaHora ASC , cDescripcionOrigen ASC) AS Id, * from #TempDestino order by Id asc

	declare @nTotal2 float = (select sum(nToneladasFlat) from #TempDestino where iCodigoDestino <> @iBalance)
	select 1 nOrden, 'Total' cConcepto, sum(nToneladasFlat) nToneladasFlat, count(1) nMovimientos, 100 nPorcentaje from #TempDestino where iCodigoDestino <> @iBalance
	union all
	select 2 nOrden, 'Condición' cConcepto, sum(nToneladasFlat) nToneladasFlat, count(1) nMovimientos, case when isnull(@nTotal2,0) = 0 then 0 else sum(nToneladasFlat) * 100.0 / @nTotal2 end nPorcentaje  from #TempDestino where bCondicion = 1 and iCodigoDestino <> @iBalance

	select ROW_NUMBER() OVER(ORDER BY dFechaHora ASC , cDescripcionOrigen ASC) AS Id, * from #TempDestino where bCondicion = 1 order by 1 asc
end
GO
