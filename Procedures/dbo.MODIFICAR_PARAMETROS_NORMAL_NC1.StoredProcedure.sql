/****** Object:  StoredProcedure [dbo].[MODIFICAR_PARAMETROS_NORMAL_NC1]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_PARAMETROS_NORMAL_NC1]
@iCodigoParametro int,
@cNombreCorto1 varchar(100),
@cGrupo1 varchar(500),
@bEstado bit
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	update PARAMETROS set
		[cNombreCorto1] = @cNombreCorto1,
 		[cGrupo1] = @cGrupo1,
 		[bEstado] = @bEstado
 	where
		iCodigoParametro = @iCodigoParametro	

	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
