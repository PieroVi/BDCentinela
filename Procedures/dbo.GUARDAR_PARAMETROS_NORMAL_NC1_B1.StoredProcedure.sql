/****** Object:  StoredProcedure [dbo].[GUARDAR_PARAMETROS_NORMAL_NC1_B1]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_PARAMETROS_NORMAL_NC1_B1]
@cNombreCorto1 varchar(500),
@bBooleano1 bit,
@cGrupo1 varchar(500),
@bEstado bit
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	Insert Into [dbo].[PARAMETROS]
		(
 			[cNombreCorto1],
			bBooleano1,
 			[cGrupo1],
 			[bEstado]
 		)
	Values
		(
 			@cNombreCorto1,
 			@bBooleano1,
			@cGrupo1,
 			@bEstado
 		)

	declare @iCodigoParametro  int= (Select Ident_Current('PARAMETROS'))

	select 'MenSys_SaveOK', @iCodigoParametro

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
