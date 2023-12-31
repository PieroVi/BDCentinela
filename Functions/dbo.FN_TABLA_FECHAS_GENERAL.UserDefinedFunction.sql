/****** Object:  UserDefinedFunction [dbo].[FN_TABLA_FECHAS_GENERAL]    Script Date: 14/06/2023 08:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TABLA_FECHAS_GENERAL]()
returns 
	@TablaFechas table(
		dFecha date
)
as
begin
	declare @dFechaInicio date = '2000-01-01'
	declare @dFechaFin date = getdate()

	declare @Cursor date = @dFechaInicio

	while @Cursor < = @dFechaFin
	begin
		insert into @TablaFechas
		select
			@Cursor

		set @Cursor = dateadd(DAY,1,@Cursor)
	end

	RETURN

end
GO
