/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_PARAMETROS_GEOLOGICOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_CM_PARAMETROS_GEOLOGICOS]
@iCodigo int,
@cCodigoEstadistica varchar(200),
@cCodigoFisica varchar(200),
@cDescripcion varchar(400),
@cAlias varchar(50),
@iTipo int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	UPDATE [dbo].[CM_PARAMETROS_GEOLOGICOS] SET	
		cCodigoEstadistica = @cCodigoEstadistica,
		cCodigoFisica = @cCodigoFisica,
		cDescripcion = @cDescripcion,
		cAlias = @cAlias,
		iTipo = @iTipo
	WHERE 
		iCodigo = @iCodigo

	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
