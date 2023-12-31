/****** Object:  StoredProcedure [dbo].[MOSTRAR_FECHAS_POR_RANGO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_FECHAS_POR_RANGO]
@dDesde date,
@dHasta date
as

declare @TablaFechas table(dFecha date, Anio int, Mes int, Dia int)
declare @Cursor date = @dDesde

while @Cursor < = @dHasta
begin
	insert into @TablaFechas
	values(
		@Cursor,
		year(@Cursor),
		month(@Cursor),
		day(@Cursor))
	
	set @Cursor = dateadd(DAY,1,@Cursor)
end

select 
	dFecha,
	Anio,
	Mes,
	Dia
from @TablaFechas
GO
