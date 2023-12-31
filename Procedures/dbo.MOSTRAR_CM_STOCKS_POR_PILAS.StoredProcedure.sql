/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_STOCKS_POR_PILAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_STOCKS_POR_PILAS] --9,2023,1
	@iCodigoDestinoStock int,-- = 9
	@iAnio int,-- = 2023
	@iTipo int --= 1

as

declare @dInicio date = convert(date,convert(varchar(4),@iAnio) + '-01-01')
declare @dFin date = convert(date,convert(varchar(4),@iAnio) + '-12-31')

--Datos Movimientos
select 
	s.dFechaRPT,
	ROW_NUMBER() OVER(PARTITION BY s.iCodigoDestinoStock ORDER BY s.dFechaHora asc) Orden,
	u.cCodigoEstadistica cStockUbicacion,
	case when g.iTipo = 1 then 'SULFUROS' else 'OXIDOS' end cTipo,
	g.iTipo,
	l.nCueq,
	--l.nCut,
	--l.nCus,
	--l.nAu,
	--l.nAg,
	--l.nMo,
	--l.nAs,
	--l.nCo3,
	--l.nNo3,
	--l.nFet,
	--l.nPy_Aux,
	--l.nLeyc_Cut,
	--l.nLeyc_Au,
	--l.nRecg_Cu,
	--l.nRecg_Au,
	--l.nBwi,
	--l.nTph_Sag,
	--l.nCpy_Ajus,
	--l.nCccv_Ajus,
	--l.nBo_Ajus,
	--l.nAxb,
	--l.nVsed_E,
	--l.nCp_Pond,
	--l.nLey_Con_Rou,
	--l.nDominio,
	--l.nIns,
	--l.nHum,
	--l.nRec_Heap,
	--l.nRec_Rom,
	--l.nCan_Heap,
	--l.nCan_Rom,
	--l.nM100,
	--l.nM400,
	--l.bCondicion,
	--l.cCondicion,
	--t.nToneladas,
	t.nToneladasFlat,
	d.cCodigoEstadistica cDestino,
	d.cFase cFaseDestino,
	d.cBanco cBancoDestino,
	d.cMalla cMallaDestino,
	d.cTmat cTmatDestino,
	d.cPoligono cPoligonoDestino,

	o.cCodigoEstadistica cOrigen,
	o.cFase cFaseOrigen,
	o.cBanco cBancoOrigen,
	o.cMalla cMallaOrigen,
	o.cTmat cTmatOrigen,
	o.cPoligono cPoligonoOrigen,

	case	when o.cCodigoEstadistica = 'BALANCE' then 'BALANCE'
			when d.cCodigoEstadistica = 'NA' or o.cCodigoEstadistica = 'NA' then 'FALTANTE'
			when d.cCodigoEstadistica = o.cCodigoEstadistica then 'ELIMINACION'
			when d.cCodigoEstadistica = u.cCodigoEstadistica then 'INGRESO'
			when o.cCodigoEstadistica = u.cCodigoEstadistica then 'SALIDA' end cTipoMOvimiento,
	u.cRegion,
	u.cTajo
into #tempAll
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
		inner join VIST_CM_UBICACIONES o on
			ori.iCodigoOrigen = o.iCodigo
		inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO dest on
			g.iCodigo = dest.iCodigo
		inner join VIST_CM_UBICACIONES d on
			dest.iCodigoDestino = d.iCodigo
where
	s.iCodigoDestinoStock = @iCodigoDestinoStock and
	year(g.dFechaRPT) = @iAnio and
	g.iTipo = @iTipo and
	o.cCodigoEstadistica not in ('BALANCE','NA') and
	d.cCodigoEstadistica  not in ('BALANCE','NA')

--Datos Tipos de Movimientos
select distinct 
	@iAnio Anio,
	cTipoMOvimiento,
	cStockUbicacion
into #tempTipoMovimientos
from #tempAll

--Datos Año - Mes
select 
	f.cNombreCorto1,
	f.iEntero1,
	f.cGrupo1,
	m.Anio,
	convert(date,convert(varchar(4),m.Anio) +'-'+ convert(varchar(2), f.iEntero1) + '-1') dFecha,
	m.cTipoMovimiento
into #tempMeses
from #tempTipoMovimientos m cross join VIST_MESES f

--Datos Dias
select 
	d.dFecha,
	d.Anio,
	d.Mes,
	d.Dia,
	m.cTipoMovimiento
into #tempDias
from #tempTipoMovimientos m cross join dbo.FN_TABLA_FECHAS(@dInicio,@dFin) d

--Mostramos Agrupado por año
select 
	m.Anio,
	m.cTipoMovimiento,
	m.cStockUbicacion,
	case when sum(a.nToneladasFlat) = 0 then NULL else sum(a.nToneladasFlat * a.nCueq) / sum(a.nToneladasFlat) end nCueq,
	
	sum(a.nToneladasFlat) nToneladas
from
	#tempTipoMovimientos m
		left join #tempAll a on
			m.Anio = year(a.dFechaRPT) and
			m.cTipoMOvimiento = a.cTipoMovimiento
group by
	m.Anio,
	m.cTipoMOvimiento,
	m.cStockUbicacion
order by
	m.Anio,
	m.cTipoMOvimiento

--Mostramos Agrupado por año y mes
select 
	m.Anio,
	m.iEntero1 iMes,
	m.dFecha dMes,
	m.cTipoMovimiento,
	case when sum(nToneladasFlat) = 0 then 0 else sum(nToneladasFlat * nCueq) / sum(nToneladasFlat) end nCueq,
	sum(nToneladasFlat) nToneladas
from
	#tempMeses m
		left join #tempAll a on
			m.Anio = year(a.dFechaRPT) and
			m.cTipoMOvimiento = a.cTipoMovimiento and
			m.iEntero1 = month(a.dFechaRPT)			
group by
	m.Anio,
	m.iEntero1,
	m.dFecha,
	m.cTipoMovimiento
order by
	m.Anio,
	m.cTipoMOvimiento,
	m.iEntero1

--Mostramos Agrupado por año, mes y dia
--select 
--	m.Anio,
--	m.Mes iMes,
--	m.dFecha,
--	m.cTipoMovimiento,
--	case when sum(nToneladasFlat) = 0 then 0 else sum(nToneladasFlat * nCueq) / sum(nToneladasFlat) end nCueq,
--	sum(nToneladasFlat) nToneladas
--from
--	#tempDias m
--		left join #tempAll a on
--			m.Anio = year(a.dFechaRPT) and
--			m.cTipoMOvimiento = a.cTipoMovimiento and
--			m.Mes = month(a.dFechaRPT) and
--			m.dFecha = a.dFechaRPT
--group by
--	m.Anio,
--	m.Mes,
--	m.dFecha,
--	m.cTipoMovimiento
--order by
--	m.Anio,
--	m.cTipoMOvimiento,
--	m.Mes,
--	m.dFecha

--Mostramos Agrupados x Fase
--select 
--	m.cTipoMovimiento,
--	m.cFaseOrigen cFase,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--into #tempAgrupadosFase
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'INGRESO'
--group by
--	m.cTipoMovimiento,
--	m.cFaseOrigen
--union all
--select 
--	m.cTipoMovimiento,
--	m.cFaseDestino cFase,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'SALIDA'
--group by
--	m.cTipoMovimiento,
--	m.cFaseDestino

--select * from #tempAgrupadosFase order by cTipoMOvimiento, cFase

--Mostramos Agrupados x Fase x Banco
--select 
--	m.cTipoMovimiento,
--	m.cFaseOrigen cFase,
--	m.cBancoOrigen cBanco,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--into #tempAgrupadosFaseBanco
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'INGRESO'
--group by
--	m.cTipoMovimiento,
--	m.cFaseOrigen,
--	m.cBancoOrigen
--union all
--select 
--	m.cTipoMovimiento,
--	m.cFaseDestino cFase,
--	m.cBancoDestino cBanco,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'SALIDA'
--group by
--	m.cTipoMovimiento,
--	m.cFaseDestino,
--	m.cBancoDestino

--select * from #tempAgrupadosFaseBanco order by cTipoMOvimiento, cFase, cBanco

--Mostramos Agrupados x Fase x Banco x Malla
--select 
--	m.cTipoMovimiento,
--	m.cFaseOrigen cFase,
--	m.cBancoOrigen cBanco,
--	m.cMallaOrigen cMalla,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--into #tempAgrupadosFaseBancoMalla
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'INGRESO'
--group by
--	m.cTipoMovimiento,
--	m.cFaseOrigen,
--	m.cBancoOrigen,
--	m.cMallaOrigen
--union all
--select 
--	m.cTipoMovimiento,
--	m.cFaseDestino cFase,
--	m.cBancoDestino cBanco,
--	m.cMallaDestino cMalla,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'SALIDA'
--group by
--	m.cTipoMovimiento,
--	m.cFaseDestino,
--	m.cBancoDestino,
--	m.cMallaDestino

--select * from #tempAgrupadosFaseBancoMalla order by cTipoMOvimiento, cFase, cBanco, cMalla

--Mostramos Agrupados x Fase x Banco x Malla x Ubicacion
--select 
--	m.cTipoMovimiento,
--	m.cFaseOrigen cFase,
--	m.cBancoOrigen cBanco,
--	m.cMallaOrigen cMalla,
--	m.cOrigen cUbicacion,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--into #tempAgrupadosFaseBancoMallaUbicacion
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'INGRESO'
--group by
--	m.cTipoMovimiento,
--	m.cFaseOrigen,
--	m.cBancoOrigen,
--	m.cMallaOrigen,
--	m.cOrigen
--union all
--select 
--	m.cTipoMovimiento,
--	m.cFaseDestino cFase,
--	m.cBancoDestino cBanco,
--	m.cMallaDestino cMalla,
--	m.cDestino cUbicacion,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'SALIDA'
--group by
--	m.cTipoMovimiento,
--	m.cFaseDestino,
--	m.cBancoDestino,
--	m.cMallaDestino,
--	m.cDestino

--select * from #tempAgrupadosFaseBancoMallaUbicacion order by cTipoMOvimiento, cFase, cBanco, cMalla, cUbicacion

--Mostramos Agrupados x Fase x Banco x Malla x Ubicacion x Dia
--select 
--	m.cTipoMovimiento,
--	m.cFaseOrigen cFase,
--	m.cBancoOrigen cBanco,
--	m.cMallaOrigen cMalla,
--	m.cOrigen cUbicacion,
--	m.dFechaRPT,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--into #tempAgrupadosFaseBancoMallaUbicacionDia
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'INGRESO'
--group by
--	m.cTipoMovimiento,
--	m.cFaseOrigen,
--	m.cBancoOrigen,
--	m.cMallaOrigen,
--	m.cOrigen,
--	m.dFechaRPT
--union all
--select 
--	m.cTipoMovimiento,
--	m.cFaseDestino cFase,
--	m.cBancoDestino cBanco,
--	m.cMallaDestino cMalla,
--	m.cDestino cUbicacion,
--	m.dFechaRPT,
--	case when sum(m.nToneladasFlat) = 0 then 0 else sum(m.nToneladasFlat * m.nCueq) / sum(m.nToneladasFlat) end nCueq,
--	sum(m.nToneladasFlat) nToneladas
--from
--	#tempAll m
--where
--	m.cTipoMOvimiento = 'SALIDA'
--group by
--	m.cTipoMovimiento,
--	m.cFaseDestino,
--	m.cBancoDestino,
--	m.cMallaDestino,
--	m.cDestino,
--	m.dFechaRPT

--select * from #tempAgrupadosFaseBancoMallaUbicacionDia order by cTipoMOvimiento, cFase, cBanco, cMalla, cUbicacion, dFechaRPT


--select * from #tempAll

drop table #tempAll
drop table #tempTipoMovimientos
drop table #tempMeses
drop table #tempDias
--drop table #tempAgrupadosFase
--drop table #tempAgrupadosFaseBanco
--drop table #tempAgrupadosFaseBancoMalla
--drop table #tempAgrupadosFaseBancoMallaUbicacion
--drop table #tempAgrupadosFaseBancoMallaUbicacionDia
--INGRESO
--SALIDA
--FALTANTE
--BALANCE


GO
