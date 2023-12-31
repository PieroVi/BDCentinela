/****** Object:  View [dbo].[VIST_PARAMETROS_JERARQUIA_NM1_E1_E2]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_PARAMETROS_JERARQUIA_NM1_E1_E2]
AS
SELECT        a.iCodigoParametro, a.cNombreMedio1 AS cDescripcion, a.iEntero1 AS iOrden, a.bEstado, CASE WHEN a.bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado, ISNULL(a.iEntero2, 0) AS iCodigoParametroPadre, 
                         ISNULL(p.cNombreMedio1, 'PRINCIPAL') AS cDescripcionPadre, 1 AS iImagen, a.cGrupo1
FROM            dbo.PARAMETROS AS a LEFT OUTER JOIN
                         dbo.PARAMETROS AS p ON a.iEntero2 = p.iCodigoParametro
GO
