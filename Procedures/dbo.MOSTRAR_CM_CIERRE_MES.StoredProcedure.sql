/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CIERRE_MES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CIERRE_MES] --'2022-01-01','2023-01-01'
@dFechaInicio date,
@dFechaFin date
as

set language 'spanish'

select 
	f.dFecha,
	f.Anio,
	f.Mes,
	f.Dia,
	datename(month,f.dFecha) cMes,
	isnull(c.bCierre,0) bCierre
from 
	dbo.FN_TABLA_FECHAS(@dFechaInicio, @dFechaFin) f
		left join CM_CIERRE c on
			f.dFecha = c.dFecha
GO
