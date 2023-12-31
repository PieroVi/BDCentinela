/****** Object:  StoredProcedure [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_NUEVO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_NUEVO]
@iCodigoUsuario int,
@vArchivo varbinary(max) = NULL
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @dFecha datetime = getdate()
	declare @cNombre varchar(max) = convert(varchar(4),year(@dFecha))+convert(varchar(4),month(@dFecha))+convert(varchar(4),day(@dFecha))+convert(varchar(4),datepart(HH,@dFecha))+convert(varchar(4),datepart(MI,@dFecha))+convert(varchar(4),datepart(S,@dFecha)
)
	INSERT INTO [dbo].SCM_DASHBOARD(
		cNombre,
		cObservacion,
		iOrden,
		bPublico,
		iMinutos,
		iCodigoUsuario,
		vArchivo,
		bPresentacion,
		dFechaInicio,
		bAhora,
		dFechaFin)
     VALUES(
		'Nuevo_'+@cNombre,
		'',
		0,
		0,
		10,
		@iCodigoUsuario,
		@vArchivo,
		0,
		DATEADD(day,-30,getdate()),
		1,
		NULL)

	declare @iCodigoDB int= (Select Ident_Current('SCM_DASHBOARD'))

	select 'MenSys_SaveOK', @iCodigoDB

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END

GO
