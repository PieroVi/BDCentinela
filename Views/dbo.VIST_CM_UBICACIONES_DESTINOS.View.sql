/****** Object:  View [dbo].[VIST_CM_UBICACIONES_DESTINOS]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VIST_CM_UBICACIONES_DESTINOS]
as
select * from CM_UBICACIONES where cTipo in ('D','S')
GO
