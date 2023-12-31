/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS] --'2023-02-12'
@dFechaRPT date --= '2023-02-12'

as

declare @Leyes table(
	dFecha	date,
	cRegion	varchar(1000),
	cRajo varchar(20),
	cOrigen varchar(500),
	cSCM varchar(500),
	nCueq float,
	nCut float,
	nCus float,
	nAu float,
	nAg float,
	nMo float,
	nAs float,
	nCo3 float,
	nNo3 float,
	nFet float,
	nPy_Aux float,
	nLeyc_Cut float,
	nLeyc_Au float,
	nRecg_Cu float,
	nRecg_Au float,
	nBwi float,
	nTph_Sag float,
	nCpy_Ajus float,
	nCccv_Ajus float,
	nBo_Ajus float,
	nAxb float,
	nVsed_E float,
	nCp_Pond float,
	nLey_Con_Rou float,
	nDominio float,
	nIns float
)
insert into @Leyes
exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_LEYES_AGRUPADAS @dFechaRPT

select * from @Leyes

declare @Movimientos table(
	cUbicacion varchar(1000),
	cSCM varchar(1000),
	cTipo varchar(100)
)
insert into @Movimientos
exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_MOVIMIENTOS_AGRUPADAS @dFechaRPT

--CRUCE
select 
	m.cUbicacion,
	m.cSCM,
	m.cTipo,
	case	when m.cTipo = 'Origen' then
				case	
						when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 'S' then 'NA'
						when (select p.bEstado from CM_UBICACIONES u inner join PARAMETROS p on u.iCalidadMineral = p.iCodigoParametro and u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 0 then 'NA' 
						when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 'O' then 'SI'
						when l.cSCM is null then '-' end 
			else '' end cJigSaw_Vulkan
from @Movimientos m
	left join @Leyes l on
		m.cSCM = l.cSCM
--Ubicaciones que no se encuentran
--Ubicaciones sin leyes en origen no bot
--select * from CM_UBICACIONES


GO
