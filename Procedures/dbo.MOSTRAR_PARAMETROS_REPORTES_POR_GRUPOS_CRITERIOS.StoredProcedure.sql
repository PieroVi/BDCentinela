/****** Object:  StoredProcedure [dbo].[MOSTRAR_PARAMETROS_REPORTES_POR_GRUPOS_CRITERIOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_PARAMETROS_REPORTES_POR_GRUPOS_CRITERIOS]  --'Reportes - TAGS'
@cGrupo1 varchar(100)
as
select 
	iCodigoParametro,
	cNombreCorto2 cTipo,
	cNombreMedio1 cReporte,
	cNombreCorto1 cFormulario,
	case 
		when cNombreCorto2 = 'Pivot' then 0
		when cNombreCorto2 = 'Tabla' then 1
		when cNombreCorto2 = 'Gráfica' then 2
		when cNombreCorto2 = 'Reporte' then 3 end iTipoOrden,
	iEntero1 iReporteOrden,
	cNombreCorto3 cCriterio
from 
	PARAMETROS P
where 
	P.cGrupo1 = @cGrupo1
	
order by
	5 asc,
	6 asc
GO
