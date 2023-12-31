/****** Object:  StoredProcedure [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_COPIAR]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_SCM_DASHBOARD_POR_USUARIO_COPIAR]
@iCodigoDB int,
@iCodigoUsuario int
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
		'Copia_'+(select cNombre from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		(select cObservacion from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		0,
		0,
		(select iMinutos from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		@iCodigoUsuario,
		(select vArchivo from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		0,
		(select dFechaInicio from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		(select bAhora from SCM_DASHBOARD where iCodigoDB = @iCodigoDB),
		(select dFechaFin from SCM_DASHBOARD where iCodigoDB = @iCodigoDB))

	declare @iCodigoDB_Copia int= (Select Ident_Current('SCM_DASHBOARD'))

	select 'MenSys_SaveOK', @iCodigoDB_Copia

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END



GO
