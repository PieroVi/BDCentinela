/****** Object:  StoredProcedure [dbo].[MOSTRAR_PARAMETROS_NORMAL_NC1_NM1_E1_F1]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_PARAMETROS_NORMAL_NC1_NM1_E1_F1]
	@cGrupo1 varchar(500)
as
select 
	p.iCodigoParametro,
	p.cNombreCorto1,
	p.cNombreMedio1,
	p.iEntero1,
	p.nFlotante1,
	p.cGrupo1,	
	p.bEstado,
	p.cEstado
from VIST_PARAMETROS p
where
	p.cGrupo1 = @cGrupo1
GO
