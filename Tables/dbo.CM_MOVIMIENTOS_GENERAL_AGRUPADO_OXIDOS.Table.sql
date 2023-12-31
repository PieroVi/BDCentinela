/****** Object:  Table [dbo].[CM_MOVIMIENTOS_GENERAL_AGRUPADO_OXIDOS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_GENERAL_AGRUPADO_OXIDOS](
	[iCodigo] [int] IDENTITY(1,1) NOT NULL,
	[dFechaRPT] [date] NOT NULL,
	[iCodigoOrigen] [int] NOT NULL,
	[iCodigoDestino] [int] NOT NULL,
	[nToneladas] [float] NULL,
	[nToneladasFlat] [float] NULL,
	[iViajes] [int] NULL,
	[nCut] [float] NULL,
	[nCus] [float] NULL,
	[nCo3] [float] NULL,
	[nNo3] [float] NULL,
	[nHum] [float] NULL,
	[nRec_Heap] [float] NULL,
	[nRec_Rom] [float] NULL,
	[nCan_Heap] [float] NULL,
	[nCan_Rom] [float] NULL,
	[nM100] [float] NULL,
	[nM400] [float] NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_GENERAL_AGRUPADO_OXIDOS_iCodigo] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
