/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_AGRUPADOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_AGRUPADOS]-- 1,335,'2022-11-12','2022-11-12',1
@iTipoMovimiento int,
@iCodigoDestinoCombo int,
@dInicio date,
@dFin date,
@bTodos bit
WITH RECOMPILE
as

set nocount on;

if @bTodos = 0
begin
	select 
		g.iCodigo,
		g.iTipoMovimiento,
		case when g.iTipoMovimiento = 1 then 'ESTADISTICA - WENCO' else 'FISICA - VULCAN' end cTipoMovimiento,
		g.dFechaRPT,
		g.nAu,
		g.nAg,
		g.nAs,
		g.nHg,
		g.nCu,
		g.nPb,
		g.nZn,
		g.nS,
		g.nDensidad,
		g.nToneladas,
		g.nToneladasFlat,
		g.iCodigoOrigen,
		deto.cDescripcion cDescripcionOrigen,
		deto.cAlias cAliasOrigen,
		deto.cTipo cTipoOrigen,
		g.iCodigoDestino,
		detd.cDescripcion cDescripcionDestino,
		detd.cAlias cAliasDestino,
		detd.cTipo cTipoDestino,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		@bTodos bTodos,
		g.iViajes
	into #TempGeneral
	from 
		CM_MOVIMIENTOS_GENERAL_AGRUPADO g with(nolock) 
			inner join CM_UBICACIONES deto with(nolock) on
				g.iCodigoOrigen = deto.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				g.iCodigoDestino = detd.iCodigo
	where
		iTipoMovimiento = @iTipoMovimiento and
		(iCodigoOrigen = @iCodigoDestinoCombo or iCodigoDestino = @iCodigoDestinoCombo) and
		dFechaRPT between @dInicio and @dFin

	select 
		ROW_NUMBER() OVER(ORDER BY f.dFechaRPT ASC , f.cDescripcionOrigen ASC) AS Id, 
		f.iCodigo,
		f.iTipoMovimiento,
		f.cTipoMovimiento,
		f.dFechaRPT,
		case when f.nAu = 0 then NULL else f.nAu end nAu,
		case when f.nAg = 0 then NULL else f.nAg end nAg,
		case when f.nAs = 0 then NULL else f.nAs end nAs,
		case when f.nHg = 0 then NULL else f.nHg end nHg,
		case when f.nCu = 0 then NULL else f.nCu end nCu,
		case when f.nPb = 0 then NULL else f.nPb end nPb,
		case when f.nZn = 0 then NULL else f.nZn end nZn,
		case when f.nS = 0 then NULL else f.nS end nS,
		case when f.nDensidad = 0 then NULL else f.nDensidad end nDensidad,
		f.nToneladas,
		f.nToneladasFlat,
		f.iCodigoOrigen,
		f.cDescripcionOrigen,
		f.cAliasOrigen,
		f.cTipoOrigen,
		f.iCodigoDestino,
		f.cDescripcionDestino,
		f.cAliasDestino,
		f.cTipoDestino,
		f.iCodigoDestinoCombo,
		f.bTodos,
		f.iViajes--,
		--isnull(m.nMovimientos,0) nMovimientos,
		--isnull(m.nTonaladasFlat,0) nToneladasFloat,
		--isnull(d.nMovimientos,0) nMovimientosDilucion,
		--isnull(d.nTonaladasFlat,0) nToneladasFloatDilucion,
		--case when isnull(m.nTonaladasFlat,0) = 0 then 0 else isnull(d.nTonaladasFlat,0) * 100.0 / isnull(m.nTonaladasFlat,0) end nPorcentaje
	from 
		#TempGeneral f
			--left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d on g.iCodigo = d.iCodigo where d.iCodigoDestino = @iCodigoDestinoCombo and g.dFechaRPT between @dInicio and @dFin and iTipoMovimiento = @iTipoMovimiento group by g.dFechaRPT) m on
			--	f.dFechaRPT = m.dFechaRPT
			--left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_LEYES l on g.iCodigo = l.iCodigo inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d on g.iCodigo = d.iCodigo where d.iCodigoDestino = @iCodigoDestinoCombo and  g.dFechaRPT between @dInicio and @dFin and l.bCondicion = 1 and iTipoMovimiento = @iTipoMovimiento group by g.dFechaRPT) d on
			--	f.dFechaRPT = d.dFechaRPT
	order by 1 asc

end
else
begin
	select 
		g.iCodigo,
		g.iTipoMovimiento,
		case when g.iTipoMovimiento = 1 then 'ESTADISTICA - WENCO' else 'FISICA - VULCAN' end cTipoMovimiento,
		g.dFechaRPT,
		--g.cTurno,
		g.nAu,
		g.nAg,
		g.nAs,
		g.nHg,
		g.nCu,
		g.nPb,
		g.nZn,
		g.nS,
		g.nDensidad,
		g.nToneladas,
		g.nToneladasFlat,
		g.iCodigoOrigen,
		deto.cDescripcion cDescripcionOrigen,
		deto.cAlias cAliasOrigen,
		deto.cTipo cTipoOrigen,
		g.iCodigoDestino,
		detd.cDescripcion cDescripcionDestino,
		detd.cAlias cAliasDestino,
		detd.cTipo cTipoDestino,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		@bTodos bTodos,
		g.iViajes
	into #TempDestino
	from 
		CM_MOVIMIENTOS_GENERAL_AGRUPADO g with(nolock) 
			inner join CM_UBICACIONES deto with(nolock) on
				g.iCodigoOrigen = deto.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				g.iCodigoDestino = detd.iCodigo
	where
		iTipoMovimiento = @iTipoMovimiento and
		dFechaRPT between @dInicio and @dFin

	select 
		ROW_NUMBER() OVER(ORDER BY f.dFechaRPT ASC , f.cDescripcionOrigen ASC) AS Id, 
		f.iCodigo,
		f.iTipoMovimiento,
		f.cTipoMovimiento,
		f.dFechaRPT,
		case when f.nAu = 0 then NULL else f.nAu end nAu,
		case when f.nAg = 0 then NULL else f.nAg end nAg,
		case when f.nAs = 0 then NULL else f.nAs end nAs,
		case when f.nHg = 0 then NULL else f.nHg end nHg,
		case when f.nCu = 0 then NULL else f.nCu end nCu,
		case when f.nPb = 0 then NULL else f.nPb end nPb,
		case when f.nZn = 0 then NULL else f.nZn end nZn,
		case when f.nS = 0 then NULL else f.nS end nS,
		case when f.nDensidad = 0 then NULL else f.nDensidad end nDensidad,
		f.nToneladas,
		f.nToneladasFlat,
		f.iCodigoOrigen,
		f.cDescripcionOrigen,
		f.cAliasOrigen,
		f.cTipoOrigen,
		f.iCodigoDestino,
		f.cDescripcionDestino,
		f.cAliasDestino,
		f.cTipoDestino,
		f.iCodigoDestinoCombo,
		f.bTodos,
		f.iViajes--,
		--isnull(m.nMovimientos,0) nMovimientos,
		--isnull(m.nTonaladasFlat,0) nToneladasFloat,
		--isnull(d.nMovimientos,0) nMovimientosDilucion,
		--isnull(d.nTonaladasFlat,0) nToneladasFloatDilucion,
		--case when isnull(m.nTonaladasFlat,0) = 0 then 0 else isnull(d.nTonaladasFlat,0) * 100.0 / isnull(m.nTonaladasFlat,0) end nPorcentaje
	from 
		#TempDestino f
			--left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo where g.dFechaRPT between @dInicio and @dFin and iTipoMovimiento = @iTipoMovimiento group by g.dFechaRPT) m on
			--	f.dFechaRPT = m.dFechaRPT
			--left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_LEYES l on g.iCodigo = l.iCodigo where g.dFechaRPT between @dInicio and @dFin and l.bCondicion = 1 and iTipoMovimiento = @iTipoMovimiento group by g.dFechaRPT) d on
			--	f.dFechaRPT = d.dFechaRPT
	order by Id asc

end
GO
