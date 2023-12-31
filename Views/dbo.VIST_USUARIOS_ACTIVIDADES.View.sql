/****** Object:  View [dbo].[VIST_USUARIOS_ACTIVIDADES]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_USUARIOS_ACTIVIDADES]
AS
SELECT        iCodigoActividades, iCodigoUsuario, cActividad, cObservacion, cDocumento, vDocumento, iPrioridad, bEstado, CASE WHEN ua.bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado
FROM            dbo.USUARIOS_ACTIVIDADES AS ua
GO
