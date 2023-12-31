/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_DILUCION_FECHAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_MOVIMIENTOS_DILUCION_FECHAS] --'2022-01-01','2023-01-01'
@dFechaInicio date,
@dFechaFin date
as

select 
	f.*,
	isnull(m.nMovimientos,0) nMovimientos,
	isnull(m.nTonaladasFlat,0) nToneladasFloat,
	isnull(d.nMovimientos,0) nMovimientosDilucion,
	isnull(d.nTonaladasFlat,0) nToneladasFloatDilucion,
	case when isnull(m.nTonaladasFlat,0) = 0 then 0 else isnull(d.nTonaladasFlat,0) * 100.0 / isnull(m.nTonaladasFlat,0) end nPorcentaje
from 
	FN_TABLA_FECHAS(@dFechaInicio,@dFechaFin) f
		left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo where g.dFechaRPT between @dFechaInicio and @dFechaFin group by g.dFechaRPT) m on
			f.dFecha = m.dFechaRPT
		left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_LEYES l on g.iCodigo = l.iCodigo where g.dFechaRPT between @dFechaInicio and @dFechaFin and l.bCondicion = 1 group by g.dFechaRPT) d on
			f.dFecha = d.dFechaRPT
order by
	f.dFecha asc
GO
