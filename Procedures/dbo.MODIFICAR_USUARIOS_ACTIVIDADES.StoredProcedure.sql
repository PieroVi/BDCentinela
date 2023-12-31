/****** Object:  StoredProcedure [dbo].[MODIFICAR_USUARIOS_ACTIVIDADES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_USUARIOS_ACTIVIDADES]
@iCodigoActividades int,
@iCodigoUsuario int,
@cActividad varchar(500),
@cObservacion varchar(max),
@cDocumento varchar(100),
@vDocumento varbinary(max) = null,
@iPrioridad int,
@bEstado bit

as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	update USUARIOS_ACTIVIDADES set
		iCodigoUsuario = iCodigoUsuario,
		cActividad = @cActividad,
		cObservacion = @cObservacion,
		cDocumento = @cDocumento,
		vDocumento = @vDocumento,
		iPrioridad = @iPrioridad,
		bEstado = @bEstado
	where
		iCodigoActividades = @iCodigoActividades

	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
