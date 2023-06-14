/****** Object:  StoredProcedure [dbo].[MODIFICAR_USUARIOS_ACTIVIDADES_ESTADO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_USUARIOS_ACTIVIDADES_ESTADO]
@iCodigoActividades int,
@bEstado bit
as
update USUARIOS_ACTIVIDADES set
	bEstado = @bEstado
where
	iCodigoActividades = @iCodigoActividades
GO
