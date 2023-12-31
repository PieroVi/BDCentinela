/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_COMBOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_COMBOS]
@iTipo int
as
select --ORIGEN
	iCodigo,
	cCodigoEstadistica,
	cCodigoFisica,
	cDescripcion,
	cAlias,
	cTipo,
	case	when cTipo = 'O' then 'ORIGEN'
			when cTipo = 'D' then 'DESTINO'
			when cTipo = 'S' then 'STOCK' end cTipoDescripcion,
	bAplica,
	case	when bAplica = 1 then 'APLICA' else 'NO APLICA' end cAplica,
	bEstado,
	case	when bEstado = 1 then 'ACTIVO' else 'INACTIVO' end cEstado,
	cCondicion,
	cRegionTajo,
	cCalidadMineral
from
	VIST_CM_UBICACIONES with(nolock)
where
	cTipo in ('O','S') and
	iTipoMineral in (@iTipo,3)

select --DESTINO
	iCodigo,
	cCodigoEstadistica,
	cCodigoFisica,
	cDescripcion,
	cAlias,
	cTipo,
	case	when cTipo = 'O' then 'ORIGEN'
			when cTipo = 'D' then 'DESTINO'
			when cTipo = 'S' then 'STOCK' end cTipoDescripcion,
	bAplica,
	case	when bAplica = 1 then 'APLICA' else 'NO APLICA' end cAplica,
	bEstado,
	case	when bEstado = 1 then 'ACTIVO' else 'INACTIVO' end cEstado,
	cCondicion,
	cRegionTajo,
	cCalidadMineral
from
	VIST_CM_UBICACIONES with(nolock)
where
	cTipo in ('D','S') and
	iTipoMineral in (@iTipo,3)
GO
