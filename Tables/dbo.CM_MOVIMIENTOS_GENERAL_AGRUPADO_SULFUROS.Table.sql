/****** Object:  Table [dbo].[CM_MOVIMIENTOS_GENERAL_AGRUPADO_SULFUROS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_GENERAL_AGRUPADO_SULFUROS](
	[iCodigo] [int] IDENTITY(1,1) NOT NULL,
	[dFechaRPT] [date] NOT NULL,
	[iCodigoOrigen] [int] NOT NULL,
	[iCodigoDestino] [int] NOT NULL,
	[nToneladas] [float] NULL,
	[nToneladasFlat] [float] NULL,
	[iViajes] [int] NULL,
	[nCueq] [float] NULL,
	[nCut] [float] NULL,
	[nCus] [float] NULL,
	[nAu] [float] NULL,
	[nAg] [float] NULL,
	[nMo] [float] NULL,
	[nAs] [float] NULL,
	[nCo3] [float] NULL,
	[nNo3] [float] NULL,
	[nFet] [float] NULL,
	[nPy_Aux] [float] NULL,
	[nLeyc_Cut] [float] NULL,
	[nLeyc_Au] [float] NULL,
	[nRecg_Cu] [float] NULL,
	[nRecg_Au] [float] NULL,
	[nBwi] [float] NULL,
	[nTph_Sag] [float] NULL,
	[nCpy_Ajus] [float] NULL,
	[nCccv_Ajus] [float] NULL,
	[nBo_Ajus] [float] NULL,
	[nAxb] [float] NULL,
	[nVsed_E] [float] NULL,
	[nCp_Pond] [float] NULL,
	[nLey_Con_Rou] [float] NULL,
	[nDominio] [float] NULL,
	[nIns] [float] NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_GENERAL_AGRUPADO] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
