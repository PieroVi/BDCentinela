/****** Object:  StoredProcedure [dbo].[MOSTRAR_CN_MOVIMIENTOS_IMPORTACION_REGISTROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CN_MOVIMIENTOS_IMPORTACION_REGISTROS] --1, '2023-02-12'
@iTipo int,
@dFechaRPT date
as

if @iTipo = 1
begin
	select
		*
	from
		CM_IMPORTACION_SULFUROS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT

	select
		l.*, p.cNombreMedio1 cRajoDescripcion
	from
		CM_IMPORTACION_SULFUROS_LEYES l
			left join PARAMETROS p on 
				l.cRajo = p.cNombreCorto1 and
				p.cGrupo1 = 'SCM - TAJO'
	where
		dFecha = @dFechaRPT

	exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS @dFechaRPT
end
else
begin
	select
		*
	from
		CM_IMPORTACION_OXIDOS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT

	select
		l.*, p.cNombreMedio1 cRajoDescripcion
	from
		CM_IMPORTACION_OXIDOS_LEYES l
			left join PARAMETROS p on 
				l.cRajo = p.cNombreCorto1 and
				p.cGrupo1 = 'SCM - TAJO'
	where
		dFecha = @dFechaRPT

	exec MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS @dFechaRPT
end

select 
	o.*,
	u.cUsuario
from 
	CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES o
		inner join VIST_USUARIOS u on
			o.iCodigoUsuario = u.iCodigoUsuario
where 
	o.iTipo = @iTipo and 
	o.dFechaRPT = @dFechaRPT
GO
