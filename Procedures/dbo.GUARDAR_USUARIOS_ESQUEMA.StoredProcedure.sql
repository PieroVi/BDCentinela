/****** Object:  StoredProcedure [dbo].[GUARDAR_USUARIOS_ESQUEMA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_USUARIOS_ESQUEMA]
@iCodigoUsuario int,
@vDashBoard varbinary(max)
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	update [USUARIOS] set
		vDashBoard = @vDashBoard
	where 
		iCodigoUsuario = @iCodigoUsuario

	select 'MenSys_SaveOK', ''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
