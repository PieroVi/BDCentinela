/****** Object:  StoredProcedure [dbo].[MOSTRAR_UBIGEO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_UBIGEO]
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
	iTipo
from VIST_UBIGEO
GO
