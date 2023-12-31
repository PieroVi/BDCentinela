/****** Object:  Table [dbo].[SCM_DASHBOARD]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCM_DASHBOARD](
	[iCodigoDB] [int] IDENTITY(1,1) NOT NULL,
	[cNombre] [varchar](200) NOT NULL,
	[cObservacion] [varchar](max) NOT NULL,
	[iOrden] [int] NOT NULL,
	[bPublico] [bit] NOT NULL,
	[iMinutos] [int] NOT NULL,
	[iCodigoUsuario] [int] NULL,
	[vArchivo] [varbinary](max) NOT NULL,
	[bPresentacion] [bit] NOT NULL,
	[dFechaInicio] [date] NOT NULL,
	[bAhora] [bit] NULL,
	[dFechaFin] [date] NULL,
	[xArchivo] [varbinary](max) NULL,
 CONSTRAINT [PK_TICA_DASHBOARD] PRIMARY KEY CLUSTERED 
(
	[iCodigoDB] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
