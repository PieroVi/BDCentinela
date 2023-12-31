/****** Object:  View [dbo].[VIST_SCM_DASHBOARD_NO_ARCHIVO]    Script Date: 14/06/2023 08:18:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIST_SCM_DASHBOARD_NO_ARCHIVO]
as
select 
	emd.iCodigoDB,
	'COD'+convert(varchar(max),emd.iCodigoDB) cCodigoDB,
	emd.cNombre,
	emd.cObservacion,
	emd.iOrden,
	emd.bPublico,
	case when emd.bPublico = 1 then 'PUBLICO' else 'PRIVADO' end cPublico,
	emd.iMinutos,
	emd.iCodigoUsuario,
	u.cNombresApellidos,
	u.cArea,
	u.cCargo,
	emd.bPresentacion,
	case when emd.bPublico = 1 then 'SI' else 'NO' end cPresentacion,
	emd.dFechaInicio,
	emd.bAhora,
	emd.dFechaFin
from 
	SCM_DASHBOARD emd
		inner join VIST_USUARIOS u on
			emd.iCodigoUsuario = u.iCodigoUsuario





GO
