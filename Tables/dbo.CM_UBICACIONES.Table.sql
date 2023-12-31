/****** Object:  Table [dbo].[CM_UBICACIONES]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_UBICACIONES](
	[iCodigo] [int] IDENTITY(1,1) NOT NULL,
	[cCodigoEstadistica] [varchar](200) NOT NULL,
	[cCodigoFisica] [varchar](200) NOT NULL,
	[cDescripcion] [varchar](400) NOT NULL,
	[cAlias] [varchar](50) NOT NULL,
	[cTipo] [char](1) NOT NULL,
	[bAplica] [bit] NOT NULL,
	[bEstado] [bit] NOT NULL,
	[cCondicion] [varchar](500) NOT NULL,
	[iTajo] [int] NOT NULL,
	[iCalidadMineral] [int] NOT NULL,
	[nLeyPromedio] [float] NOT NULL,
	[cObservacion] [varchar](500) NOT NULL,
	[cMinaCancha] [varchar](50) NULL,
	[cFase] [varchar](20) NULL,
	[cBanco] [varchar](20) NULL,
	[cMalla] [varchar](20) NULL,
	[cTmat] [varchar](20) NULL,
	[cPoligono] [varchar](20) NULL,
	[iTipoMineral] [int] NULL,
 CONSTRAINT [PK_CM_UBICACIONES] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cCodigoEstadistica] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
