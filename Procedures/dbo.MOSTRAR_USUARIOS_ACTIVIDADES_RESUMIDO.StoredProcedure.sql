/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_ACTIVIDADES_RESUMIDO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_USUARIOS_ACTIVIDADES_RESUMIDO]
@iCodigoUsuario int
as
SELECT 
	iCodigoActividades,
	cActividad,
	bEstado
FROM 
	VIST_USUARIOS_ACTIVIDADES ua
where 
	ua.iCodigoUsuario = @iCodigoUsuario
order by
	ua.iPrioridad asc,
	ua.iCodigoActividades asc
GO
