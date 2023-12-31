/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_POR_CODIGO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_POR_CODIGO]
@iCodigo int
as
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
		deto.cDescripcion cDescripcionOrigen,
		deto.cAlias cAliasOrigen,
		deto.cTipo cTipoOrigen,
		d.iCodigoDestino,
		d.nEastingDestino,
		d.nNorthingDestino,
		d.nElevationDestino,
		d.nLongitudDestino,
		d.nLatitudDestino,
		detd.cDescripcion cDescripcionDestino,
		detd.cAlias cAliasDestino,
		detd.cTipo cTipoDestino
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_LEY l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join CM_UBICACIONES deto with(nolock) on
				o.iCodigoOrigen = deto.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
where	
	g.iCodigo = @iCodigo
GO
