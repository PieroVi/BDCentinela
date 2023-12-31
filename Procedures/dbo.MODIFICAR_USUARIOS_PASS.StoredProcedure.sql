/****** Object:  StoredProcedure [dbo].[MODIFICAR_USUARIOS_PASS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_USUARIOS_PASS]
@iCodigoUsuario int,
@vContraseña varchar(max),
@vContraseñaNueva varchar(max),
@vContraseñaRepetida varchar(max)
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	if exists(select 1 from USUARIOS where iCodigoUsuario = @iCodigoUsuario and dbo.FN_OBTENER_CLAVE(vContraseña) = @vContraseña)
	begin
		if @vContraseñaNueva <> @vContraseñaRepetida
		begin
			select 'MenSys_Validation', 'Contraseña nueva no coincide con contraseña de validación'
		end
		else
		begin
			UPDATE [dbo].[USUARIOS] SET	
				vContraseña = dbo.FN_GENERAR_CLAVE(@vContraseñaNueva)
			WHERE 
				iCodigoUsuario = @iCodigoUsuario

			select 'MenSys_EditOK' , 'Actualización correcta'
		end
	end
	else
	begin
		Select 'MenSys_Validation', 'Contraseña actual no coincide'
	end


	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
