/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_FOTO_FIRMA_POR_ID]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MOSTRAR_USUARIOS_FOTO_FIRMA_POR_ID]
@iCodigoUsuario int
as
select
	vFoto,
	vFirma
from
	USUARIOS
where
	iCodigoUsuario = @iCodigoUsuario
GO
