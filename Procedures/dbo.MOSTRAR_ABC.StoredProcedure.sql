/****** Object:  StoredProcedure [dbo].[MOSTRAR_ABC]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MOSTRAR_ABC]
as
select 
	iCodigoABC,
	cABC
from
	ABC
GO
