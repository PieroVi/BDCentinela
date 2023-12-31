/****** Object:  UserDefinedFunction [dbo].[FN_TABLA_FECHAS]    Script Date: 14/06/2023 08:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TABLA_FECHAS](
	@dFechaInicio date, 
	@dFechaFin date
)
returns 
	@TablaFechas table(
		dFecha date, 
		Anio int, 
		Mes int, 
		Dia int
)
as
begin
	declare @Cursor date = @dFechaInicio

	while @Cursor < = @dFechaFin
	begin
		insert into @TablaFechas
		values(
			@Cursor,
			year(@Cursor),
			month(@Cursor),
			day(@Cursor))
	
		set @Cursor = dateadd(DAY,1,@Cursor)
	end

	RETURN

end
GO
