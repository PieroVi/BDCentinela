/****** Object:  View [dbo].[VIST_USUARIOS_AREA]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_USUARIOS_AREA]
AS
SELECT        mo.iCodigoParametro, mo.cNombreMedio1, mo.cGrupo1, mo.bEstado, CASE WHEN mo.bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado, CASE WHEN isnull(ma.cNombremedio1, '') 
                         = '' THEN mo.cNombremedio1 ELSE ma.cNombremedio1 + ' - ' + mo.cNombremedio1 END AS cArea
FROM            dbo.PARAMETROS AS mo LEFT OUTER JOIN
                         dbo.PARAMETROS AS ma WITH (nolock) ON mo.iEntero2 = ma.iCodigoParametro
WHERE        (mo.cGrupo1 = 'USUARIOS - AREAS')
GO
