/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_PARAMETROS_GEOLOGICOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CM_PARAMETROS_GEOLOGICOS]
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

	INSERT INTO [dbo].[CM_PARAMETROS_GEOLOGICOS]
           (cCodigoEstadistica,
			cCodigoFisica,
			cDescripcion,
			cAlias,
			iTipo)
     VALUES
           (@cCodigoEstadistica,
			@cCodigoFisica,
			@cDescripcion,
			@cAlias,
			@iTipo)

	declare @iCodigo int= (Select Ident_Current('CM_PARAMETROS_GEOLOGICOS'))

	
	select 'MenSys_SaveOK', @iCodigo

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
