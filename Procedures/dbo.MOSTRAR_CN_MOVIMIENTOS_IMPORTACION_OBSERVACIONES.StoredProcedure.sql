/****** Object:  StoredProcedure [dbo].[MOSTRAR_CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES]-- 1, '2022-10-02'
@iTipoMovimiento int,
@dFechaRPT date
as
	select 
		o.*,
		u.cUsuario
	from 
		CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES o
			inner join VIST_USUARIOS u on
				o.iCodigoUsuario = u.iCodigoUsuario
	where 
		iTipoMovimiento = @iTipoMovimiento and 
		dFechaRPT = @dFechaRPT
GO
