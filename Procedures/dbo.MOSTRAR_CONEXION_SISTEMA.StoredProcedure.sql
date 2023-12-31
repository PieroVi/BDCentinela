/****** Object:  StoredProcedure [dbo].[MOSTRAR_CONEXION_SISTEMA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CONEXION_SISTEMA]
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	select
		iCodigo,
		cUsuario,
		cContraseña,
		cServidor,
		cBaseDatos
	from
		VIST_CONEXION_SISTEMA

	select 1

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
