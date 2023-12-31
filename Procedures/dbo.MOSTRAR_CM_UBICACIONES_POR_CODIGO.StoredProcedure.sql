/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_UBICACIONES_POR_CODIGO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_UBICACIONES_POR_CODIGO]
@iCodigo int
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
	p.cNombreCorto1 cTajoCodigo,
	p.cNombreMedio1 cTajo,
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
	u.cPoligono
from
	CM_UBICACIONES u with(nolock)
		inner join PARAMETROS p with(nolock) on
			u.iTajo = p.iCodigoParametro
		inner join PARAMETROS c with(nolock) on
			u.iCalidadMineral = c.iCodigoParametro
where
	iCodigo = @iCodigo
GO
