/****** Object:  StoredProcedure [dbo].[MOSTRAR_PARAMETRO_PERSONALIZADO_CORREO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_PARAMETRO_PERSONALIZADO_CORREO]
as

BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

select 
	cNombreCorto1 cServidor,
	cNombreCorto2 cUsuario,
	cNombreCorto3 cContraseña,
	iEntero1 iPuerto,
	bBooleano1 bSSL,
	bBooleano2 bCredencialesDefault
from
	PARAMETROS
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
