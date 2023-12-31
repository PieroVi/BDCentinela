/****** Object:  Table [dbo].[CM_MOVIMIENTOS_LEY]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_LEY](
	[iCodigo] [int] NOT NULL,
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
	[nHum] [float] NULL,
	[nRec_Heap] [float] NULL,
	[nRec_Rom] [float] NULL,
	[nCan_Heap] [float] NULL,
	[nCan_Rom] [float] NULL,
	[nM100] [float] NULL,
	[nM400] [float] NULL,
	[bCondicion] [bit] NULL,
	[cCondicion] [varchar](500) NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_LEY] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
