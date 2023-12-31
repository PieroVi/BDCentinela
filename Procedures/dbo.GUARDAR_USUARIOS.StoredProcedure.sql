/****** Object:  StoredProcedure [dbo].[GUARDAR_USUARIOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_USUARIOS]
@iTipo int,
@cUsuario varchar(200),
@vContraseña varchar(max),
@cCodigo varchar(200),
@cDNI varchar(8),
@cNombres varchar(200),
@cApellidos varchar(200),
@iCodigoArea int,
@iCodigoCargo int,
@dCumpleaños date,
@cCorreo varchar(200),
@cTelefono varchar(200),
@bEstado bit,
@cRoles xml,
@vFoto varbinary(max) = NULL,
@vFirma varbinary(max) = NULL,
@cMac varchar(20),
@iCodigoEmpresa int

as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	INSERT INTO [dbo].[USUARIOS]
           (iTipo,
		    cUsuario,
			vContraseña,
			cCodigo,
			cDNI,
			cNombres,
			cApellidos,
			iCodigoArea,
			iCodigoCargo,
			dCumpleaños,
			cCorreo,
			cTelefono,
			bEstado,
			vFoto,
			vFirma,
			cMac,
			iCodigoEmpresa)
     VALUES
           (@iTipo,
		    @cUsuario,
			dbo.FN_GENERAR_CLAVE(@VContraseña),
			@cCodigo,
			@cDNI,
			@cNombres,
			@cApellidos,
			@iCodigoArea,
			@iCodigoCargo,
			@dCumpleaños,
			@cCorreo,
			@cTelefono,
			@bEstado,
			@vFoto,
			@vFirma,
			@cMac,
			@iCodigoEmpresa)

	declare @iCodigoUsuario int= (Select Ident_Current('USUARIOS'))

	insert into USUARIOS_MODULOS
	select
		@iCodigoUsuario,
		nref.value('iCodigoModulos[1]','int') iCodigoModulos
	from @cRoles.nodes('/NewDataSet/Table1') as R(nref)
	OPTION (OPTIMIZE FOR (@cRoles = NULL))

	select 'MenSys_SaveOK', @iCodigoUsuario

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
