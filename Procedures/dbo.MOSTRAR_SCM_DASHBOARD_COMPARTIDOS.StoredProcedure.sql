/****** Object:  StoredProcedure [dbo].[MOSTRAR_SCM_DASHBOARD_COMPARTIDOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_SCM_DASHBOARD_COMPARTIDOS]
@iCodigoUsuario int
as
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
	dFechaInicio,
	bAhora,
	dFechaFin
  FROM VIST_SCM_DASHBOARD_NO_ARCHIVO
  WHERE
	bPublico = 1 and
	iCodigoUsuario <> @iCodigoUsuario


GO
