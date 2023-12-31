/****** Object:  View [dbo].[VIST_CM_MOVIMIENTOS_STOCK]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VIST_CM_MOVIMIENTOS_STOCK]
as
select 
	s.*,
	ROW_NUMBER() OVER(PARTITION BY s.iCodigoDestinoStock ORDER BY s.dFechaHora asc) Orden,
	u.cCodigoEstadistica cStockUbicacion,
	case when g.iTipo = 1 then 'SULFUROS' else 'OXIDOS' end cTipo,
	g.iTipo,
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
	t.nToneladas,
	t.nToneladasFlat,
	d.cCodigoEstadistica cDestino,
	o.cCodigoEstadistica cOrigen,
	case	when o.cCodigoEstadistica = 'BALANCE' then 'BALANCE'
			when d.cCodigoEstadistica = 'NA' or o.cCodigoEstadistica = 'NA' then 'FALTANTE'
			when d.cCodigoEstadistica = o.cCodigoEstadistica then 'ELIMINACION'
			when d.cCodigoEstadistica = u.cCodigoEstadistica then 'INGRESO'
			when o.cCodigoEstadistica = u.cCodigoEstadistica then 'SALIDA' end cTipoMOvimiento,
	u.cRegion,
	u.cTajo
from 
	CM_MOVIMIENTOS_LEY_STOCK s
		inner join CM_MOVIMIENTOS_GENERAL g on
			s.iCodigo = g.iCodigo
		inner join VIST_CM_UBICACIONES u on
			s.iCodigoDestinoStock = u.iCodigo
		inner join CM_MOVIMIENTOS_LEY l on
			g.iCodigo = l.iCodigo
		inner join CM_MOVIMIENTOS_EQUIPOS t on
			g.iCodigo = t.iCodigo 
		inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN ori on
			g.iCodigo = ori.iCodigo
		inner join CM_UBICACIONES o on
			ori.iCodigoOrigen = o.iCodigo
		inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO dest on
			g.iCodigo = dest.iCodigo
		inner join CM_UBICACIONES d on
			dest.iCodigoDestino = d.iCodigo



GO
