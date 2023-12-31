/****** Object:  Table [dbo].[CM_IMPORTACION_OXIDOS_LEYES]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_IMPORTACION_OXIDOS_LEYES](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dFecha] [date] NOT NULL,
	[cSource] [varchar](1000) NULL,
	[cRegion] [varchar](1000) NULL,
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
	[nTotal_Volume] [float] NULL,
	[nTotal_Mass] [float] NULL,
	[cRajo] [varchar](50) NULL,
	[iCodigoUsuario] [int] NULL,
 CONSTRAINT [PK_CM_IMPORTACION_OXIDOS_LEYES_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
