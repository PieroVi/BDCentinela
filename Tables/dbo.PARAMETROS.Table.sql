/****** Object:  Table [dbo].[PARAMETROS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARAMETROS](
	[iCodigoParametro] [int] IDENTITY(1,1) NOT NULL,
	[cNombreCorto1] [varchar](100) NULL,
	[cNombreCorto2] [varchar](100) NULL,
	[cNombreCorto3] [varchar](100) NULL,
	[cNombreCorto4] [varchar](100) NULL,
	[cNombreMedio1] [varchar](500) NULL,
	[cNombreMedio2] [varchar](500) NULL,
	[cNombreMedio3] [varchar](500) NULL,
	[cNombreMedio4] [varchar](500) NULL,
	[cNombreLargo1] [varchar](max) NULL,
	[cNombreLargo2] [varchar](max) NULL,
	[cNombreLargo3] [varchar](max) NULL,
	[cNombreLargo4] [varchar](max) NULL,
	[iEntero1] [int] NULL,
	[iEntero2] [int] NULL,
	[iEntero3] [int] NULL,
	[iEntero4] [int] NULL,
	[nFlotante1] [float] NULL,
	[nFlotante2] [float] NULL,
	[nFlotante3] [float] NULL,
	[nFlotante4] [float] NULL,
	[dFecha1] [date] NULL,
	[dFecha2] [date] NULL,
	[dFecha3] [date] NULL,
	[dFecha4] [date] NULL,
	[dtFechaHora1] [datetime] NULL,
	[dtFechaHora2] [datetime] NULL,
	[dtFechaHora3] [datetime] NULL,
	[dtFechaHora4] [datetime] NULL,
	[bBooleano1] [bit] NULL,
	[bBooleano2] [bit] NULL,
	[bBooleano3] [bit] NULL,
	[bBooleano4] [bit] NULL,
	[cGrupo1] [varchar](500) NULL,
	[cGrupo2] [varchar](500) NULL,
	[cGrupo3] [varchar](500) NULL,
	[cGrupo4] [varchar](500) NULL,
	[bEstado] [bit] NULL,
 CONSTRAINT [PK_PARAMETROS] PRIMARY KEY CLUSTERED 
(
	[iCodigoParametro] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
