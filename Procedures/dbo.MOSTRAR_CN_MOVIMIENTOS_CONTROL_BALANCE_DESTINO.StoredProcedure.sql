/****** Object:  StoredProcedure [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL_BALANCE_DESTINO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL_BALANCE_DESTINO]-- 2022,1,335
@iAnio int,
@iTipo int,
@iCodigoDestino int
as

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES with(nolock) where cCodigoEstadistica = 'BALANCE')

select 
	g.dFechaRPT
into #fechasConBalance
from 
	CM_MOVIMIENTOS_GENERAL g with(nolock) 
		inner join CM_MOVIMIENTOS_LEY s with(nolock) on 
			g.iCodigo = S.iCodigo 
		inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on 
			s.iCodigo = o.iCodigo 
		INNER JOIN CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on 
			g.iCodigo = d.iCodigo 
where 
	year(G.dFechaRPT) = @iAnio and 
	d.iCodigoDestino = @iCodigoDestino and 
o.iCodigoOrigen = @iBalance


create table #TablaFechas (dFecha date, Anio int, Mes int, Dia int, Cantidad int NULL)
create table #TablaResultados (dFecha date, Anio int, Mes int, Dia int, cFecha varchar(3), cEstado varchar(3), Cantidad int )
create table #TablaFuentes (id int identity(1,1), iCodigoFuente int, cFuente varchar(100))
create table #TablaObservacion (dFecha date, cEstado varchar(3))

create table #TablaResultadosFinal (
	iCodigoFuente int, 
	cFuente varchar(100), 
	Anio int, 
	Mes varchar(100), 
	cFecha varchar(3),
	Cantidad int, 
	[1] varchar(3),
	[2] varchar(3),
	[3] varchar(3),
	[4] varchar(3),
	[5] varchar(3),
	[6] varchar(3),
	[7] varchar(3),
	[8] varchar(3),
	[9] varchar(3),
	[10] varchar(3),
	[11] varchar(3),
	[12] varchar(3),
	[13] varchar(3),
	[14] varchar(3),
	[15] varchar(3),
	[16] varchar(3),
	[17] varchar(3),
	[18] varchar(3),
	[19] varchar(3),
	[20] varchar(3),
	[21] varchar(3),
	[22] varchar(3),
	[23] varchar(3),
	[24] varchar(3),
	[25] varchar(3),
	[26] varchar(3),
	[27] varchar(3),
	[28] varchar(3),
	[29] varchar(3),
	[30] varchar(3),
	[31] varchar(3), 
	cFila varchar(100))

declare @Cursor date = convert(date,convert(varchar(4),@iAnio)+'-01-01')
declare @dHasta date = convert(date,convert(varchar(4),@iAnio)+'-12-31')

while @Cursor < = @dHasta
begin
	insert into #TablaFechas
	values(
		@Cursor,
		year(@Cursor),
		month(@Cursor),
		day(@Cursor),
		NULL)


	--if exists(select 1 from CM_MOVIMIENTOS_GENERAL g with(nolock) inner join CM_MOVIMIENTOS_LEY s with(nolock) on g.iCodigo = S.iCodigo inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on s.iCodigo = o.iCodigo INNER JOIN CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on g.iCodigo = d.iCodigo where G.dFechaRPT = @Cursor and d.iCodigoDestino = @iCodigoDestino and o.iCodigoOrigen = @iBalance)
	if exists(select 1 from #fechasConBalance where dFechaRPT = @Cursor)
	begin
		insert into #TablaObservacion
		values(@Cursor, 'S')
	end
	else
	begin
		insert into #TablaObservacion
		values(@Cursor, '')
	end

	set @Cursor = dateadd(DAY,1,@Cursor)
end

insert into #TablaFuentes
select 
	@iTipo,
	case when @iTipo = 1 then 'SULFUROS' else 'OXIDOS' end

declare @columnas varchar(max)
set @columnas = ''

update t set
	t.Cantidad = f.Cantidad
from 
	#TablaFechas t 
		inner join (select Anio, Mes, count(1) Cantidad from #TablaFechas group by Anio, Mes) f on
			t.Anio = f.Anio and
			t.Mes = f.Mes

select @columnas =  coalesce(@columnas + '[' + cast(Dia as varchar(2)) + '],', '')
FROM (select distinct Dia from #TablaFechas) as DTM

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
		t.dFecha,
		year(t.dFecha) Anio, 
		month(t.dFecha) Mes, 
		day(t.dFecha) Dia, 
		convert(varchar(3),t.dFecha,107),
		f.cEstado,
		t.Cantidad
	from (select * from #TablaFechas) t
		left join #TablaObservacion f on
			t.dFecha = f.dFecha

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
									cEstado
								FROM #TablaResultados) sourceData 
						PIVOT(	max(cEstado) FOR [Dia] IN ('+ @columnas +')) pivotrReport'

	insert into #TablaResultadosFinal
	EXECUTE sp_executesql @SQLString

	set @Contador = @Contador + 1
end

select * from #TablaResultadosFinal

drop table #TablaFuentes
drop table #TablaResultados
drop table #TablaResultadosFinal
GO
