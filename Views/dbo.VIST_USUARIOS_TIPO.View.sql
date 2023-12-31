/****** Object:  View [dbo].[VIST_USUARIOS_TIPO]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_USUARIOS_TIPO]
AS
SELECT        iCodigoParametro, cNombreCorto1, cGrupo1, bEstado, CASE WHEN bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado
FROM            dbo.PARAMETROS
WHERE        (cGrupo1 = 'USUARIOS - TIPOS')
GO
