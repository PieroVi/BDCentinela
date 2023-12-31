/****** Object:  Table [dbo].[CN_MOVIMIENTOS_IMPORTACION_REGISTROS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CN_MOVIMIENTOS_IMPORTACION_REGISTROS](
	[iCodGen] [bigint] IDENTITY(1,1) NOT NULL,
	[Id] [int] NOT NULL,
	[iTipoMovimiento] [int] NOT NULL,
	[dFechaRPT] [date] NOT NULL,
	[cTurno] [varchar](1) NULL,
	[dFechaHora] [datetime] NOT NULL,
	[cObservaciones] [varchar](max) NULL,
	[bAuto] [bit] NULL,
	[cCodigoPala] [varchar](100) NULL,
	[cCodigoFlotaPala] [varchar](100) NULL,
	[cCodigoCamion] [varchar](100) NULL,
	[cCodigoFlotaCamion] [varchar](100) NULL,
	[nToneladas] [float] NULL,
	[nToneladasFlat] [float] NULL,
	[cOrigen] [varchar](200) NULL,
	[nEastingOrigen] [float] NULL,
	[nNorthingOrigen] [float] NULL,
	[nElevationOrigen] [float] NULL,
	[nLongitudOrigen] [float] NULL,
	[nLatitudOrigen] [float] NULL,
	[cDestino] [varchar](200) NULL,
	[nEastingDestino] [float] NULL,
	[nNorthingDestino] [float] NULL,
	[nElevationDestino] [float] NULL,
	[nLongitudDestino] [float] NULL,
	[nLatitudDestino] [float] NULL,
	[cCodigoTipoRoca_GROCK] [varchar](100) NULL,
	[cCodigoTipoAlteracion_AROCK] [varchar](100) NULL,
	[cCodigoZonaMineral_MROCK] [varchar](100) NULL,
	[cCodigoDurezaRelativa_DUREZA] [varchar](100) NULL,
	[cCodigoMaterial] [varchar](100) NULL,
	[cCodigoBloque] [varchar](100) NULL,
	[nAu] [float] NULL,
	[nAg] [float] NULL,
	[nAs] [float] NULL,
	[nHg] [float] NULL,
	[nCu] [float] NULL,
	[nPb] [float] NULL,
	[nZn] [float] NULL,
	[nS] [float] NULL,
	[nDensidad] [float] NULL,
 CONSTRAINT [PK_CN_MOVIMIENTOS_IMPORTACION_REGISTROS] PRIMARY KEY CLUSTERED 
(
	[iCodGen] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
