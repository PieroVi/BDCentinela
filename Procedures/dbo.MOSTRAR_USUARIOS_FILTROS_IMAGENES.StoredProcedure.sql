/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_FILTROS_IMAGENES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_USUARIOS_FILTROS_IMAGENES]
	@cGrupo1 varchar(500)
as
select 
	p.iCodigoParametro,
	p.cNombreCorto1,
	p.iEntero1,
	p.cGrupo1,	
	p.bEstado,
	p.cEstado
from VIST_PARAMETROS p
where
	p.cGrupo1 = @cGrupo1
GO
