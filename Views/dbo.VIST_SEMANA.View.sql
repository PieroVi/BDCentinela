/****** Object:  View [dbo].[VIST_SEMANA]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_SEMANA]
as
select
	iCodigoParametro,
	cNombreCorto1,
	cNombreCorto2,
	iEntero1,
	iEntero2
from
	PARAMETROS
where
	cGrupo1 = 'SEMANA'
GO
