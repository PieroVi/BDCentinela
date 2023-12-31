/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_ESQUEMA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_USUARIOS_ESQUEMA]
@iCodigoUsuario int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @vDashBoard varbinary(max)
	set @vDashBoard = (SELECT vDashBoard FROM [USUARIOS] WHERE iCodigoUsuario = @iCodigoUsuario)

	select 'MenSys_EjecutionOK', @vDashBoard

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
