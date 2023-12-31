/****** Object:  Table [dbo].[CM_IMPORTACION_OXIDOS_MOVIMIENTOS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_IMPORTACION_OXIDOS_MOVIMIENTOS](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dFecha] [date] NOT NULL,
	[cTurno] [varchar](10) NOT NULL,
	[cOrigen] [varchar](100) NOT NULL,
	[cDestino] [varchar](100) NOT NULL,
	[cCamion] [varchar](50) NOT NULL,
	[cPala] [varchar](50) NOT NULL,
	[nTonelaje] [float] NOT NULL,
	[cRegion] [varchar](100) NOT NULL,
	[bMezcla] [bit] NOT NULL,
	[dFechaHorafull] [datetime] NOT NULL,
	[dFechaHoraEmpty] [datetime] NOT NULL,
	[cTronada] [varchar](100) NOT NULL,
	[iCodigoUsuario] [int] NOT NULL,
 CONSTRAINT [PK_CM_IMPORTACION_OXIDOS_MOVIMIENTOS] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
