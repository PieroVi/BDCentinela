/****** Object:  StoredProcedure [dbo].[ELIMINAR_CM_MOVIMIENTOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ELIMINAR_CM_MOVIMIENTOS] --171577
@iCodigo int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	declare @iTipo int
	declare @dFechaRPT date
	declare @iCodigoDestino int

	select 
		@iTipo = iTipo,
		@dFechaRPT = dFechaRPT
	from CM_MOVIMIENTOS_GENERAL
	WHERE 
		iCodigo = @iCodigo 

	DELETE CM_MOVIMIENTOS_LEY
	WHERE 
		iCodigo = @iCodigo

	DELETE CM_MOVIMIENTOS_EQUIPOS
	WHERE 
		iCodigo = @iCodigo

	DELETE CM_MOVIMIENTOS_UBICACIONES_ORIGEN
	WHERE 
		iCodigo = @iCodigo

	SELECT
		@iCodigoDestino = iCodigoDestino
	FROM
		CM_MOVIMIENTOS_UBICACIONES_DESTINO
	WHERE 
		iCodigo = @iCodigo

	DELETE CM_MOVIMIENTOS_UBICACIONES_DESTINO
	WHERE 
		iCodigo = @iCodigo

	DELETE CM_MOVIMIENTOS_GENERAL
	WHERE 
		iCodigo = @iCodigo

	if @iTipo = 1
	begin
		exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_SULFUROS @dFechaRPT
		exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS @iCodigoDestino, @dFechaRPT
	end
	else
	begin
		
		exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_OXIDOS @dFechaRPT 
		exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS @iCodigoDestino, @dFechaRPT
	end


	select 'MenSys_DeleteOk',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
