/****** Object:  StoredProcedure [dbo].[MODIFICAR_PARAMETRO_PERSONALIZADO_CORREO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_PARAMETRO_PERSONALIZADO_CORREO]
	@cNombreCorto1 varchar(100), --Servidor
	@cNombreCorto2 varchar(100), --Usuario
	@cNombreCorto3 varchar(100), --Contraseña
	@iEntero1 int, -- Puerto
	@bBooleano1 bit, --SSL
	@bBooleano2	bit --Credenciales Default,
as

BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

update PARAMETROS set
	cNombreCorto1 = @cNombreCorto1,
	cNombreCorto2 = @cNombreCorto2,
	cNombreCorto3 = @cNombreCorto3,
	iEntero1 = @iEntero1,
	bBooleano1 = @bBooleano1,
	bBooleano2 = @bBooleano2
where
	cGrupo1 = 'CONFIGURACION - PARAMETROS - CORREO ENVIO'

select 'MenSys_SaveOK', 0

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
