/****** Object:  StoredProcedure [dbo].[ELIMINAR_PARAMETROS_JERARQUIA_NM1_E1_E2]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELIMINAR_PARAMETROS_JERARQUIA_NM1_E1_E2]
@iCodigoParametro int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	
	update PARAMETROS set
		iEntero2 = 0
	where
		iEntero2 = @iCodigoParametro

	delete from PARAMETROS
 	where
		iCodigoParametro = @iCodigoParametro	

	select 'MenSys_DeleteOk',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
