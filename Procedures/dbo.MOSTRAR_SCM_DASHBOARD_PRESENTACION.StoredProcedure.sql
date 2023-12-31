/****** Object:  StoredProcedure [dbo].[MOSTRAR_SCM_DASHBOARD_PRESENTACION]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_SCM_DASHBOARD_PRESENTACION]
@iCodigoUsuario int
as
select * from (
SELECT
	iCodigoDB,
	cCodigoDB,
	cNombre,
	cObservacion,
	iOrden,
	bPublico,
	cPublico,
	iMinutos,
	iCodigoUsuario,
	cNombresApellidos,
	cArea,
	cCargo,
	'MIS DASHBOARDS' cTipo,
	0 iTipoOrden,
	bPresentacion,
	dFechaInicio,
	bAhora,
	dFechaFin
  FROM VIST_SCM_DASHBOARD_NO_ARCHIVO
  WHERE
	iCodigoUsuario = @iCodigoUsuario

union all

SELECT
	iCodigoDB,
	cCodigoDB,
	cNombre,
	cObservacion,
	iOrden,
	bPublico,
	cPublico,
	iMinutos,
	iCodigoUsuario,
	cNombresApellidos,
	cArea,
	cCargo,
	'COMPARTIDOS' cTipo,
	1 iTipoOrden,
	convert(bit,0) bPresentacion,
	dFechaInicio,
	bAhora,
	dFechaFin
  FROM VIST_SCM_DASHBOARD_NO_ARCHIVO
  WHERE
	bPublico = 1 and
	iCodigoUsuario <> @iCodigoUsuario
) p
order by
	iTipoOrden asc,
	iOrden asc

GO
