/****** Object:  StoredProcedure [dbo].[MOSTRAR_USUARIOS_ROLES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_USUARIOS_ROLES]
	@iCodigoUsuario int
as
select 
	m.iCodigoModulos
from USUARIOS_MODULOS m
where 
	m.iCodigoUsuario = @iCodigoUsuario
GO
