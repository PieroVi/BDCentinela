/****** Object:  View [dbo].[VIST_TURNOS_GENERAL]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_TURNOS_GENERAL]
AS
SELECT        
	iCodigoParametro, 
	cNombreCorto1,
	iEntero1,
	cGrupo1, 
	bEstado, 
	CASE WHEN bEstado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS cEstado
FROM            
	dbo.PARAMETROS
WHERE        
	(cGrupo1 = 'TURNOS - GENERAL')
GO
