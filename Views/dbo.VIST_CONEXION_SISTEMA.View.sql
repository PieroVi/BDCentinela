/****** Object:  View [dbo].[VIST_CONEXION_SISTEMA]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_CONEXION_SISTEMA]
AS
SELECT        iCodigoParametro AS iCodigo, cNombreCorto1 AS cUsuario, cNombreCorto2 AS cContraseña, cNombreCorto3 AS cServidor, cNombreCorto4 AS cBaseDatos
FROM            dbo.PARAMETROS AS c WITH (nolock)
WHERE        (cGrupo1 = 'CREDENCIALES CONEXION SISTEMA')
GO
