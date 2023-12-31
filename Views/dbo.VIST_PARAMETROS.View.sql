/****** Object:  View [dbo].[VIST_PARAMETROS]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_PARAMETROS]
AS
SELECT        iCodigoParametro, cNombreCorto1, cNombreCorto2, cNombreCorto3, cNombreCorto4, cNombreMedio1, cNombreMedio2, cNombreMedio3, cNombreMedio4, cNombreLargo1, cNombreLargo2, cNombreLargo3, cNombreLargo4, 
                         iEntero1, iEntero2, iEntero3, iEntero4, nFlotante1, nFlotante2, nFlotante3, nFlotante4, dFecha1, dFecha2, dFecha3, dFecha4, dtFechaHora1, dtFechaHora2, dtFechaHora3, dtFechaHora4, bBooleano1, bBooleano2, bBooleano3, 
                         bBooleano4, cGrupo1, cGrupo2, cGrupo3, cGrupo4, bEstado, CASE WHEN bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado
FROM            dbo.PARAMETROS
GO
