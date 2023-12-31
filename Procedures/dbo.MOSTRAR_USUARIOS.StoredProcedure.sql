/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_USUARIOS] --12
@iTipo int
as
if @iTipo = 12
begin
	select 
		u.iCodigoUsuario,
		u.iTipo,
		u.cTipo,
		u.cUsuario,
		u.vContraseña,
		u.cContraseña,
		u.cCodigo,
		u.cDNI,
		u.cNombres,
		u.cApellidos,
		u.iCodigoArea,
		u.cArea,
		u.iCodigoCargo,
		u.cCargo,
		u.dCumpleaños,
		u.cCorreo,
		u.cTelefono,
		u.bEstado,
		u.cEstado,
		cAreaDetalle,
		cCargoDetalle,
		cNombresApellidos,
		u.cMac,
		u.iCodigoEmpresa,
		u.cEmpresa
	from VIST_USUARIOS u
end
if @iTipo = 13
begin
	select
		iCodigoUsuario,
		iTipo,
		cTipo,
		cUsuario,
		vContraseña,
		cContraseña,
		cCodigo,
		cDNI,
		cNombres,
		cApellidos,
		iCodigoArea,
		cArea,
		iCodigoCargo,
		cCargo,
		dCumpleaños,
		cCorreo,
		cTelefono,
		bEstado,
		cEstado,
		vFoto,
		vFirma,
		cAreaDetalle,
		cCargoDetalle,
		cNombresApellidos,
		cMac,
		iCodigoEmpresa,
		cEmpresa
	from
		VIST_USUARIOS_CON_IMAGENES
end
GO
