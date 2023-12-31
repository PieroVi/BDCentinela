/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS] --'2023-05-01'
@dFechaRPT date --= '2023-02-12'

as

declare @Leyes table(
	dFecha date,
	cRegion varchar(1000),
	cRajo varchar(20),
	cOrigen varchar(500),
	cSCM varchar(500),
	nCut float,
	nCus float,	
	nCo3 float,
	nNo3 float,
	nHum float,
	nRec_Heap float,
	nRec_Rom float,
	nCan_Heap float,
	nCan_Rom float,
	nM100 float,
	nM400 float
)

insert into @Leyes
exec MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_LEYES_AGRUPADAS @dFechaRPT

select * from @Leyes

declare @Movimientos table(
	cUbicacion varchar(1000),
	cSCM varchar(1000),
	cTipo varchar(100)
)

insert into @Movimientos
exec MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_MOVIMIENTOS_AGRUPADAS @dFechaRPT

--CRUCE
select 
	m.cUbicacion,
	m.cSCM,
	m.cTipo,
	case	when m.cTipo = 'Origen' then
				case	
						when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 2) = 'S' then 'NA'
						when (select p.bEstado from CM_UBICACIONES u inner join PARAMETROS p on u.iCalidadMineral = p.iCodigoParametro and u.cCodigoEstadistica = m.cSCM and iTipoMineral = 2) = 0 then 'NA' 
						when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 2) = 'O' then 'SI'
						when l.cSCM is null then '-' end 
			else '' end cJigSaw_Vulkan
from @Movimientos m
	left join @Leyes l on
		m.cSCM = l.cSCM





GO
