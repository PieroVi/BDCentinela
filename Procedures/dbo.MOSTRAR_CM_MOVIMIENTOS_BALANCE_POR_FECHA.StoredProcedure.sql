/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_BALANCE_POR_FECHA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_BALANCE_POR_FECHA]
@dFechaRPT date,
@iCodigoDestinoCombo int
as

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

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
		l.bCondicion,
		l.cCondicion,
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
		s.nCueqStock,
		s.nCutStock,
		s.nCusStock,
		s.nAuStock,
		s.nAgStock,
		s.nMoStock,
		s.nAsStock,
		s.nCo3Stock,
		s.nNo3Stock,
		s.nFetStock,
		s.nPy_AuxStock,
		s.nLeyc_CutStock,
		s.nLeyc_AuStock,
		s.nRecg_CuStock,
		s.nRecg_AuStock,
		s.nBwiStock,
		s.nTph_SagStock,
		s.nCpy_AjusStock,
		s.nCccv_AjusStock,
		s.nBo_AjusStock,
		s.nAxbStock,
		s.nVsed_EStock,
		s.nCp_PondStock,
		s.nLey_Con_RouStock,
		s.nDominioStock,
		s.nInsStock,
		s.nHumStock,
		s.nRec_HeapStock,
		s.nRec_RomStock,
		s.nCan_HeapStock,
		s.nCan_RomStock,
		s.nM100Stock,
		s.nM400Stock,
		s.nToneladasAcum,
		s.iOrdenDesc,
		s.bUltimo,
		s.iOrden,
		s.iCodigoDestinoStock iCodigoDestinoCombo
from
	CM_MOVIMIENTOS_LEY_STOCK s
		inner join CM_MOVIMIENTOS_GENERAL g with(nolock) on
			s.iCodigo = g.iCodigo
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
	g.dFechaRPT = @dFechaRPT and
	o.iCodigoOrigen = @iBalance and
	d.iCodigoDestino = @iCodigoDestinoCombo
GO
