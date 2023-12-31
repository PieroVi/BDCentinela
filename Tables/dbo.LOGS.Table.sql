/****** Object:  Table [dbo].[LOGS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOGS](
	[iCodigo] [int] NOT NULL,
	[dFechaHora] [datetime] NULL,
	[cPC] [varchar](100) NULL,
	[cIP] [varchar](20) NULL,
	[cUsuario] [varchar](200) NULL,
	[cNombresApellidos] [varchar](400) NULL,
	[cTabla] [varchar](100) NULL,
	[cOperacion] [varchar](20) NULL,
	[cRegistros] [varchar](max) NULL,
	[cTransaccion] [varchar](300) NULL,
 CONSTRAINT [PK_AUDITORIA] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
