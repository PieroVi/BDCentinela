/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CIERRE_MES_VALIDAR_POR_HORA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CIERRE_MES_VALIDAR_POR_HORA] --'2022-01-01','2023-01-01'
@dFechaInicio datetime,
@iTipo int
as

	declare @dFechaRPT date

	if @iTipo = 1 --Fecha y Hora
	begin
		set @dFechaRPT  = case	when datepart(hh,@dFechaInicio) between 8 and 19 then convert(date,@dFechaInicio) 
								when datepart(hh,@dFechaInicio) between 0 and 7 then dateadd(dd,-1,convert(date,@dFechaInicio))
								when datepart(hh,@dFechaInicio) between 20 and 23 then convert(date,@dFechaInicio) end
	end
	else
	begin
		set @dFechaRPT = convert(date,@dFechaInicio)
	end

	if exists(select 1 from CM_CIERRE where dFecha = @dFechaRPT and bCierre = 1)
	begin
		select 0
	end
	else
	begin
		select 1
	end
GO
