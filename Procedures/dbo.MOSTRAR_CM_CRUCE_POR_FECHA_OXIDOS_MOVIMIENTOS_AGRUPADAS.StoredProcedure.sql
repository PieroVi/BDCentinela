/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_MOVIMIENTOS_AGRUPADAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_MOVIMIENTOS_AGRUPADAS] --'2023-02-12'
@dFechaRPT date
as

select distinct 
	cOrigen cUbicacion,
	case	when (select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = cOrigen and iTipoMineral = 2) is null then 
				(select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = (select Name from dbo.splitstringV2(cOrigen,'/') r where r.id = 2) and iTipoMineral = 2) 
			else 
				(select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = cOrigen and iTipoMineral = 2) end cSCM,
	'Origen' cTipo
into #TempMovimienos
from
	CM_IMPORTACION_OXIDOS_MOVIMIENTOS
where
	dFecha = @dFechaRPT
union all
select distinct 
	cDestino cUbicacion,
	(select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = cDestino and iTipoMineral = 2) cSCM,
	'Destino' cTipo
from
	CM_IMPORTACION_OXIDOS_MOVIMIENTOS
where
	dFecha = @dFechaRPT

select
	*
from
	#TempMovimienos



GO
