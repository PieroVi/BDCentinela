/****** Object:  View [dbo].[VIST_UBIGEO]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_UBIGEO]
as
select
	cCodigoUbigeo,
	cCodigoUbigeoPadre,
	cDescripcion,
	bDepartamento,
	cCodigoDepartamento,
	cDepartamento,
	bProvincia,
	cCodigoProvincia,
	cProvincia,
	bDistrito,
	cCodigoDistrito,
	cDistrito,
	cDescripcionGeneral,
	iTipo,
	iCodigoUbigeo,
	iCodigoUbigeoPadre
from 
	UBIGEO
GO
