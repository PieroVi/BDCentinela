/****** Object:  Table [dbo].[CM_MOVIMIENTOS_DESTINO_STOCK_PARAMETROS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_DESTINO_STOCK_PARAMETROS](
	[Id] [int] NOT NULL,
	[iTipoMovimiento] [int] NOT NULL,
	[iCodigoDestino] [int] NOT NULL,
	[cParametroGeologico] [varchar](100) NOT NULL,
	[nPorcentual] [float] NULL,
	[cCodigo] [varchar](200) NULL,
	[nAu] [float] NULL,
	[nAg] [float] NULL,
	[nAs] [float] NULL,
	[nHg] [float] NULL,
	[nCu] [float] NULL,
	[nPb] [float] NULL,
	[nZn] [float] NULL,
	[nS] [float] NULL,
	[nDensidad] [float] NULL,
	[nTonelaje] [float] NULL,
	[nViajes] [int] NULL
) ON [PRIMARY]
GO
