/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_PARAMETROS_GEOLOGICOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_PARAMETROS_GEOLOGICOS]
as
select
	iCodigo,
	cCodigoEstadistica,
	cCodigoFisica,
	cDescripcion,
	cAlias,
	iTipo,
	case	when iTipo = 1 then 'TIPO ROCA / GROCK'
			when iTipo = 2 then 'TIPO DE ALTERACION / AROCK'
			when iTipo = 3 then 'ZONA DE MINERAL / MROCK'
			when iTipo = 4 then 'DUREZA RELATIVA / DUREZA' 
			when iTipo = 5 then 'MATERIAL' end cTipoDescripcion
from
	CM_PARAMETROS_GEOLOGICOS with(nolock)
GO
