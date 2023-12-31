/****** Object:  StoredProcedure [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL_AUTOMATICO_RANGO_FECHAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL_AUTOMATICO_RANGO_FECHAS]
@iTipoMovimiento int,
@dInicio date,
@dFin date
as

while @dInicio < = @dFin
begin

	exec GUARDAR_CN_MOVIMIENTOS_CONTROL_AUTOMATICO @iTipoMovimiento, @dInicio
	
	set @dInicio = dateadd(dd,1,@dInicio)
end
GO
