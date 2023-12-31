/****** Object:  View [dbo].[VIST_USUARIOS_CON_IMAGENES]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_USUARIOS_CON_IMAGENES]
AS
SELECT        
	u.iCodigoUsuario, 
	u.iTipo, 
	t.cNombreCorto1 AS cTipo, 
	u.cUsuario, 
	u.vContraseña, 
	dbo.FN_OBTENER_CLAVE(u.vContraseña) AS cContraseña, 
	u.cCodigo, 
	u.cDNI, 
	u.cNombres, 
	u.cApellidos, 
	u.iCodigoArea, 
	a.cNombreMedio1 AS cArea, 
	u.iCodigoCargo, 
	c.cNombreMedio1 AS cCargo, 
	u.dCumpleaños, u.cCorreo, 
	u.cTelefono, 
	u.bEstado, 
	CASE WHEN u.bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado, 
	u.vFoto, 
	u.vFirma, 
	a.cArea AS cAreaDetalle, 
	c.cCargo AS cCargoDetalle, 
	u.cNombres + ' ' + u.cApellidos AS cNombresApellidos,
	cMac,
	u.iCodigoEmpresa,
	e.cNombreCorto1 cEmpresa
FROM            dbo.USUARIOS AS u INNER JOIN
                         dbo.VIST_USUARIOS_AREA AS a ON u.iCodigoArea = a.iCodigoParametro INNER JOIN
                         dbo.VIST_USUARIOS_CARGO AS c ON u.iCodigoCargo = c.iCodigoParametro INNER JOIN
                         dbo.VIST_USUARIOS_TIPO AS t ON u.iTipo = t.iCodigoParametro INNER JOIN
						 dbo.VIST_USUARIOS_EMPRESAS AS e ON u.iCodigoEmpresa = e.iCodigoParametro
GO
