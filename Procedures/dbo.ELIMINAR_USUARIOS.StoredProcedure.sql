/****** Object:  StoredProcedure [dbo].[ELIMINAR_USUARIOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELIMINAR_USUARIOS]
@iCodigoUsuario int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	DELETE USUARIOS_ACTIVIDADES
	WHERE 
		iCodigoUsuario = @iCodigoUsuario

	DELETE USUARIOS_MODULOS
	WHERE 
		iCodigoUsuario = @iCodigoUsuario
	
	DELETE USUARIOS
	WHERE 
		iCodigoUsuario = @iCodigoUsuario

	select 'MenSys_DeleteOk',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
