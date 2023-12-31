/****** Object:  Table [dbo].[CM_MOVIMIENTOS_LEY_STOCK]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_LEY_STOCK](
	[iCodigoDestinoStock] [int] NOT NULL,
	[iOrden] [int] NULL,
	[iCodigo] [int] NOT NULL,
	[dFechaRPT] [date] NOT NULL,
	[dFechaHora] [datetime] NOT NULL,
	[cTurno] [varchar](1) NOT NULL,
	[nCueqStock] [float] NULL,
	[nCutStock] [float] NULL,
	[nCusStock] [float] NULL,
	[nAuStock] [float] NULL,
	[nAgStock] [float] NULL,
	[nMoStock] [float] NULL,
	[nAsStock] [float] NULL,
	[nCo3Stock] [float] NULL,
	[nNo3Stock] [float] NULL,
	[nFetStock] [float] NULL,
	[nPy_AuxStock] [float] NULL,
	[nLeyc_CutStock] [float] NULL,
	[nLeyc_AuStock] [float] NULL,
	[nRecg_CuStock] [float] NULL,
	[nRecg_AuStock] [float] NULL,
	[nBwiStock] [float] NULL,
	[nTph_SagStock] [float] NULL,
	[nCpy_AjusStock] [float] NULL,
	[nCccv_AjusStock] [float] NULL,
	[nBo_AjusStock] [float] NULL,
	[nAxbStock] [float] NULL,
	[nVsed_EStock] [float] NULL,
	[nCp_PondStock] [float] NULL,
	[nLey_Con_RouStock] [float] NULL,
	[nDominioStock] [float] NULL,
	[nInsStock] [float] NULL,
	[nHumStock] [float] NULL,
	[nRec_HeapStock] [float] NULL,
	[nRec_RomStock] [float] NULL,
	[nCan_HeapStock] [float] NULL,
	[nCan_RomStock] [float] NULL,
	[nM100Stock] [float] NULL,
	[nM400Stock] [float] NULL,
	[nToneladasAcum] [float] NULL,
	[iOrdenDesc] [int] NULL,
	[bUltimo] [bit] NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_LEY_STOCK] PRIMARY KEY CLUSTERED 
(
	[iCodigoDestinoStock] ASC,
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CM_MOVIMIENTOS_LEY_STOCK]  WITH CHECK ADD  CONSTRAINT [FK_CM_MOVIMIENTOS_LEY_STOCK_CM_UBICACIONES] FOREIGN KEY([iCodigoDestinoStock])
REFERENCES [dbo].[CM_UBICACIONES] ([iCodigo])
GO
ALTER TABLE [dbo].[CM_MOVIMIENTOS_LEY_STOCK] CHECK CONSTRAINT [FK_CM_MOVIMIENTOS_LEY_STOCK_CM_UBICACIONES]
GO
