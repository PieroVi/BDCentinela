/****** Object:  Table [dbo].[CM_MOVIMIENTOS_EQUIPOS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_EQUIPOS](
	[iCodigo] [int] NOT NULL,
	[cCodigoPala] [varchar](100) NULL,
	[cCodigoFlotaPala] [varchar](100) NULL,
	[cCodigoCamion] [varchar](100) NULL,
	[cCodigoFlotaCamion] [varchar](100) NULL,
	[nToneladas] [float] NULL,
	[nToneladasFlat] [float] NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_EQUIPOS] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
