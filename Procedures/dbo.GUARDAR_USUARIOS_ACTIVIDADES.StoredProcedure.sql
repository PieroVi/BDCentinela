/****** Object:  StoredProcedure [dbo].[GUARDAR_USUARIOS_ACTIVIDADES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_USUARIOS_ACTIVIDADES]
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

	insert into USUARIOS_ACTIVIDADES
	values(
		@iCodigoUsuario,
		@cActividad,
		@cObservacion,
		@cDocumento,
		@vDocumento,
		@iPrioridad,
		@bEstado
	)

	select 'MenSys_SaveOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
