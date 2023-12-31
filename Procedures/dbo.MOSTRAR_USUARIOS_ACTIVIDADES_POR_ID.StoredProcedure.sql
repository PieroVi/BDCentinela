/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_ACTIVIDADES_POR_ID]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_USUARIOS_ACTIVIDADES_POR_ID]
@iCodigoActividades int
as
SELECT 
	ua.iCodigoActividades,
	ua.iCodigoUsuario,
	ua.cActividad,
	ua.cObservacion,
	ua.cDocumento,
	ua.vDocumento,
	ua.iPrioridad,
	ua.bEstado
FROM 
	VIST_USUARIOS_ACTIVIDADES ua
where 
	ua.iCodigoActividades = @iCodigoActividades
GO
