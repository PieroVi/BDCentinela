/****** Object:  StoredProcedure [dbo].[MOSTRAR_ROLES_SISTEMAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_ROLES_SISTEMAS]
as
	select 
		iCodigoParametro,
		cNombreCorto1,
		cNombreCorto2,
		cNombreMedio1,
		cGrupo1,
		cGrupo2,
		bEstado,
		iEntero1
	from 
		PARAMETROS 
	where cGrupo1 = 'ROLES'
GO
