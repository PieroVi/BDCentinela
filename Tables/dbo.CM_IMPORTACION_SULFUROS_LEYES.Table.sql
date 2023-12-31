/****** Object:  Table [dbo].[CM_IMPORTACION_SULFUROS_LEYES]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_IMPORTACION_SULFUROS_LEYES](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dFecha] [date] NOT NULL,
	[cSource] [varchar](1000) NULL,
	[cRegion] [varchar](1000) NULL,
	[nLito] [float] NULL,
	[nAlte] [float] NULL,
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
	[nTotal_Volume] [float] NULL,
	[nTotal_Mass] [float] NULL,
	[cRajo] [varchar](50) NULL,
	[iCodigoUsuario] [int] NOT NULL,
 CONSTRAINT [PK_CM_IMPORTACION_SULFUROS_LEYES] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
