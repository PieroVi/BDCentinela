/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_UBICACIONES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_UBICACIONES]
@iTipoMineral int
as
select
	u.iCodigo,
	u.cCodigoEstadistica,
	u.cCodigoFisica,
	u.cDescripcion,
	u.cAlias,
	u.cTipo,
	case	when u.cTipo = 'O' then 'ORIGEN'
			when u.cTipo = 'D' then 'DESTINO'
			when u.cTipo = 'S' then 'STOCK' end cTipoDescripcion,
	u.bAplica,
	case	when u.bAplica = 1 then 'APLICA' else 'NO APLICA' end cAplica,
	u.bEstado,
	case	when u.bEstado = 1 then 'ACTIVO' else 'INACTIVO' end cEstado,
	u.cCondicion,
	u.iTajo,
	p.cDescripcion cTajoCodigo,
	p.cDescripcion2 cTajo,
	u.iCalidadMineral,
	c.cNombreCorto1 cCalidadMineralCodigo,
	c.cNombreMedio1 cCalidadMineral,
	u.nLeyPromedio,
	u.cObservacion,
	u.cMinaCancha,
	u.cFase,
	u.cBanco,
	u.cMalla,
	u.cTmat,
	u.cPoligono,
	case when p.iCodigoParametroPadre = 0 then p.cDescripcion else (select cNombreCorto1 from PARAMETROS pp where pp.iCodigoParametro = p.iCodigoParametroPadre) + ' - ' + p.cDescripcion end cRegionTajo,
	case when p.iCodigoParametroPadre = 0 then p.cDescripcion else (select cNombreCorto1 from PARAMETROS pp where pp.iCodigoParametro = p.iCodigoParametroPadre) end cRegion,
	u.iTipoMineral,
	case when u.iTipoMineral = 1 then 'SULFUROS' when u.iTipoMineral = 2 then 'OXIDOS'  else 'GENERAL' end cTipoMineral
from
	CM_UBICACIONES u with(nolock)
		inner join VIST_PARAMETROS_JERARQUIA_NC1_NM1_E1_E2 p with(nolock) on
			u.iTajo = p.iCodigoParametro
		inner join PARAMETROS c with(nolock) on
			u.iCalidadMineral = c.iCodigoParametro
where 
	iTipoMineral = @iTipoMineral
GO
