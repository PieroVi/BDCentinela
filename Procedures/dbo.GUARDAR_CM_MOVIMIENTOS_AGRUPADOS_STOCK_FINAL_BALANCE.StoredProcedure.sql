/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL_BALANCE]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL_BALANCE] --1,335
@iTipoMovimiento int,
@iCodigoDestinoCombo int,
@dFecha date

WITH RECOMPILE
--BALANCE 333
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

declare @iCodigoOrigenCombo int = 333

set nocount on;

select * from CM_MOVIMIENTOS_DESTINO_STOCK_MOVIMIENTOS where iCodigoDestinoCombo = @iCodigoDestinoCombo

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	set nocount on;
END CATCH
END
GO
