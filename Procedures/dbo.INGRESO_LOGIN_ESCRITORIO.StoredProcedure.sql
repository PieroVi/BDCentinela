/****** Object:  StoredProcedure [dbo].[INGRESO_LOGIN_ESCRITORIO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INGRESO_LOGIN_ESCRITORIO]  --'aacosta','aacosta'
@cUsuario as varchar(200),
@vContraseña as varchar(max)
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

if exists(	select 
				1 
			from USUARIOS u 
				inner join USUARIOS_MODULOS r on 
					u.iCodigoUsuario = r.iCodigoUsuario 
				inner join (select * from PARAMETROS where cNombreCorto2 = 'Escritorio') p on
					r.iCodigoModulos = p.iCodigoParametro
			where 
				u.cUsuario = @cUsuario and 
				dbo.FN_OBTENER_CLAVE(u.vContraseña) = @vContraseña and 
				u.bEstado = 1 and
				p.bEstado = 1)
begin

	select
		iCodigoUsuario,
		cNombres,
		cApellidos,
		cUsuario,
		cCargo,
		cArea,
		vFoto,
		cMac,
		cEmpresa
	from VIST_USUARIOS_CON_IMAGENES u
	where 
		u.cUsuario = @cUsuario and 
		dbo.FN_OBTENER_CLAVE(u.vContraseña) = @vContraseña and
		bEstado = 1

	--select 
	--	m.iCodigoModulos,
	--	p.cNombreCorto1 cCodigoFormulario,
	--	p.cNombreMedio1 cModulos
	--from USUARIOS_MODULOS m
	--	inner join (select * from PARAMETROS where cNombreCorto2 = 'Escritorio') p on
	--		m.iCodigoModulos = p.iCodigoParametro
	--	inner join USUARIOS u on
	--		m.iCodigoUsuario = u.iCodigoUsuario
	--where 
	--	u.cUsuario = @cUsuario and 
	--	dbo.FN_OBTENER_CLAVE(u.vContraseña) = @vContraseña and 
	--	u.bEstado = 1 and
	--	p.bEstado = 1

	select 
		p.iCodigoParametro iCodigoModulos,
		p.cNombreCorto1 cCodigoFormulario,
		p.cNombreMedio1 cModulos,
		case when isnull(u.iCodigoModulos,0) = 0 then 0 else 1 end iEstado
	from (select * from PARAMETROS where cNombreCorto2 = 'ESCRITORIO') p
		left join (select x.*,x2.iCodigoModulos from USUARIOS x inner join USUARIOS_MODULOS x2 on x.iCodigoUsuario = x2.iCodigoUsuario where x.cUsuario = @cUsuario and dbo.FN_OBTENER_CLAVE(x.vContraseña) = @vContraseña and x.bEstado = 1) u on
			p.iCodigoParametro = u.iCodigoModulos
	where
		p.bEstado = 1 and
		case when isnull(u.iCodigoModulos,0) = 0 then 0 else 1 end = 1

	--select 
	--	distinct
	--	p.cNombreCorto1 cCodigoFormulario
	--from (select * from PARAMETROS where cNombreCorto2 = 'ESCRITORIO') p
	--	left join (select x.*,x2.iCodigoModulos from USUARIOS x inner join USUARIOS_MODULOS x2 on x.iCodigoUsuario = x2.iCodigoUsuario where x.cUsuario = @cUsuario and dbo.FN_OBTENER_CLAVE(x.vContraseña) = @vContraseña and x.bEstado = 1) u on
	--		p.iCodigoParametro = u.iCodigoModulos
	--where
	--	p.bEstado = 1 and
	--	case when isnull(u.iCodigoModulos,0) = 0 then 0 else 1 end = 1

	select 'MenSys_EjecutionOK' 
end
else
begin
	select 'MenSys_Validation', 'No se encontró Usuario, Contraseña y/o Permiso a Módulos'
end
COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
