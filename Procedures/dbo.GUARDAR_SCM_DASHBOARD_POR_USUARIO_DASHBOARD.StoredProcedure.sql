/****** Object:  StoredProcedure [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_DASHBOARD]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_DASHBOARD]
@iCodigoDB int,
@vArchivo varbinary(max),
@xArchivo varbinary(max)
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	update SCM_DASHBOARD set
		vArchivo = @vArchivo,
		xArchivo = @xArchivo
	where
		iCodigoDB = @iCodigoDB

	select 'MenSys_SaveOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END


GO
