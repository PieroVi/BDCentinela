/****** Object:  StoredProcedure [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL_DILUCION]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL_DILUCION] --2022,1
@iAnio int,
@iTipo int
as

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

create table #TablaDatos (dFecha date, Anio int, Mes int, Dia int,nMovimientos float, nToneladasFlat float, nMovimientosDilucion float, nToneladasFlatDilucion float, nPorcentaje float, Cantidad int NULL)
create table #TablaResultados (dFecha date, Anio int, Mes int, Dia int, cFecha varchar(3), nPorcentaje float, Cantidad int)
create table #TablaFuentes (id int identity(1,1), iCodigoFuente int, cFuente varchar(100))
create table #TablaResultadosFinal (
	iCodigoFuente int, 
	cFuente varchar(100), 
	Anio int, 
	Mes varchar(100), 
	cFecha varchar(3),
	Cantidad int, 
	[1] float,
	[2] float,
	[3] float,
	[4] float,
	[5] float,
	[6] float,
	[7] float,
	[8] float,
	[9] float,
	[10] float,
	[11] float,
	[12] float,
	[13] float,
	[14] float,
	[15] float,
	[16] float,
	[17] float,
	[18] float,
	[19] float,
	[20] float,
	[21] float,
	[22] float,
	[23] float,
	[24] float,
	[25] float,
	[26] float,
	[27] float,
	[28] float,
	[29] float,
	[30] float,
	[31] float, 
	cFila varchar(100))

declare @Cursor date = convert(date,convert(varchar(4),@iAnio)+'-01-01')
declare @dHasta date = convert(date,convert(varchar(4),@iAnio)+'-12-31')

insert into #TablaDatos
select 
	f.*,
	isnull(m.nMovimientos,0) nMovimientos,
	isnull(m.nTonaladasFlat,0) nToneladasFloat,
	isnull(d.nMovimientos,0) nMovimientosDilucion,
	isnull(d.nTonaladasFlat,0) nToneladasFloatDilucion,
	case when isnull(m.nTonaladasFlat,0) = 0 then null else isnull(d.nTonaladasFlat,0) * 100.0 / isnull(m.nTonaladasFlat,0) end nPorcentaje,
	NULL
from 
	FN_TABLA_FECHAS(@Cursor,@dHasta) f
		left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d on g.iCodigo = d.iCodigo where g.dFechaRPT between @Cursor and @dHasta and g.iTipo = @iTipo and d.iCodigoDestino <> @iBalance group by g.dFechaRPT) m on
			f.dFecha = m.dFechaRPT
		left join (select g.dFechaRPT, count(1) nMovimientos, sum(e.nToneladasFlat) nTonaladasFlat from CM_MOVIMIENTOS_GENERAL g inner join CM_MOVIMIENTOS_EQUIPOS e on g.iCodigo = e.iCodigo inner join CM_MOVIMIENTOS_LEY l on g.iCodigo = l.iCodigo inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d on g.iCodigo = d.iCodigo where g.dFechaRPT between @Cursor and @dHasta and l.bCondicion = 1 and g.iTipo = @iTipo  and d.iCodigoDestino <> @iBalance group by g.dFechaRPT) d on
			f.dFecha = d.dFechaRPT
order by
	f.dFecha asc

insert into #TablaFuentes
select 
	@iTipo,
	case when @iTipo = 1 then 'SULFUROS' else 'OXIDOS' end

declare @columnas varchar(max)
set @columnas = ''

update t set
	t.Cantidad = f.Cantidad
from 
	#TablaDatos t 
		inner join (select Anio, Mes, count(1) Cantidad from #TablaDatos group by Anio, Mes) f on
			t.Anio = f.Anio and
			t.Mes = f.Mes
			
select @columnas =  coalesce(@columnas + '[' + cast(Dia as varchar(2)) + '],', '')
FROM (select distinct Dia from #TablaDatos) as DTM

set @columnas = left(@columnas,LEN(@columnas)-1)

declare @Contador int = 1
declare @iCodigoFuenteCursor int
declare @cFuenteCursor varchar(100) = ''
declare @SQLString nvarchar(max);

while @Contador < = (select count(1) from #TablaFuentes)
begin
	delete from #TablaResultados

	select
		@iCodigoFuenteCursor = iCodigoFuente,
		@cFuenteCursor = cFuente
	from 
		#TablaFuentes
	where
		id = @Contador

	insert into #TablaResultados
	select 
		dFecha,
		Anio, 
		Mes, 
		Dia, 
		convert(varchar(3),dFecha,107),
		nPorcentaje,
		Cantidad
	from #TablaDatos

	set @SQLString = '	SELECT '+
							convert(varchar(max),@iCodigoFuenteCursor)+' iCodigoFuenteCursor, ''' + 
							@cFuenteCursor+''' cFuente, 
							*, '''+
							convert(varchar(max),@iCodigoFuenteCursor)+'''+''-''+cFecha cFila 
						FROM
							(	SELECT 
									Anio, 
									Mes, 
									cFecha, 
									Dia, 
									Cantidad,
									nPorcentaje
								FROM #TablaResultados) sourceData 
						PIVOT(	max(nPorcentaje) FOR [Dia] IN ('+ @columnas +')) pivotrReport'

	insert into #TablaResultadosFinal
	EXECUTE sp_executesql @SQLString

	set @Contador = @Contador + 1
end

select * from #TablaResultadosFinal

drop table #TablaFuentes
drop table #TablaDatos
drop table #TablaResultados
drop table #TablaResultadosFinal
GO
