/****** Object:  StoredProcedure [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CN_MOVIMIENTOS_CONTROL] --2023,1
@iAnio int,
@iTipo int
as
create table #TablaFechas (dFecha date, Anio int, Mes int, Dia int, Cantidad int NULL)
create table #TablaResultados (dFecha date, Anio int, Mes int, Dia int, cFecha varchar(3), cEstado varchar(3), Cantidad int )
create table #TablaFuentes (id int identity(1,1), iTipo int, cFuente varchar(100))
create table #TablaObservacion (dFecha date, cEstado varchar(3))
create table #TablaResultadosFinal (
	iTipo int, 
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

	if exists(select 1 from CM_CIERRE where dFecha = @Cursor and bCierre = 1)
	begin
		insert into #TablaObservacion
		values(@Cursor, 'C')
	end
	else
	begin
		if exists(select 1 from CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES where dFechaRPT = @Cursor and iTipo = @iTipo)
		begin
			insert into #TablaObservacion
			values(@Cursor, (select top 1 case when cObservacion = 'OK' then 'B' else 'V' end from CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES where dFechaRPT = @Cursor and iTipo = @iTipo order by dFechaEjecucion desc))
		end
		else
		begin
			if @iTipo = 1
			begin
				if exists(select 1 from CM_IMPORTACION_SULFUROS_LEYES where dFecha = @Cursor union all select 1 from CM_IMPORTACION_SULFUROS_MOVIMIENTOS where dFecha = @Cursor)
				begin
					insert into #TablaObservacion
					values(@Cursor, 'I')
				end
				else
				begin
					insert into #TablaObservacion
					values(@Cursor, '')
				end
			end
			else
			begin
				if exists(select 1 from CM_IMPORTACION_OXIDOS_LEYES where dFecha = @Cursor union all select 1 from CM_IMPORTACION_OXIDOS_MOVIMIENTOS where dFecha = @Cursor)
				begin
					insert into #TablaObservacion
					values(@Cursor, 'I')
				end
				else
				begin
					insert into #TablaObservacion
					values(@Cursor, '')
				end
			end
		end
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
declare @iTipoCursor bit
declare @cFuenteCursor varchar(100) = ''
declare @SQLString nvarchar(max);

while @Contador < = (select count(1) from #TablaFuentes)
begin
	delete from #TablaResultados

	select
		@iTipoCursor = iTipo,
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
							convert(varchar(max),@iTipoCursor)+' iTipoCursor, ''' + 
							@cFuenteCursor+''' cFuente, 
							*, '''+
							convert(varchar(max),@iTipoCursor)+'''+''-''+cFecha cFila 
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

drop table #TablaFechas
drop table #TablaResultados
drop table #TablaResultadosFinal


select '' cEstado, 'Sin Registros' cDescripcion, 1 iOrden 
union all
select 'V' cEstado, 'Falta Validar' cDescripcion, 2 iOrden 
union all
select 'B' cEstado, 'Registros Correctos' cDescripcion, 3 iOrden 
union all
select 'I' cEstado, 'Sólo Importación' cDescripcion, 4 iOrden 
union all
select 'C' cEstado, 'Cerrado' cDescripcion, 5 iOrden
GO
