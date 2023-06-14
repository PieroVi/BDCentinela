/****** Object:  StoredProcedure [dbo].[ELIMINAR_SCM_DASHBOARD_POR_USUARIO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELIMINAR_SCM_DASHBOARD_POR_USUARIO]
@iCodigoDB int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	delete from SCM_DASHBOARD
	where
		iCodigoDB = @iCodigoDB

	select 'MenSys_DeleteOk',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END





GO
