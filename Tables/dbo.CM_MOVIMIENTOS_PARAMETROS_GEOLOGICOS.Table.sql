/****** Object:  Table [dbo].[CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS](
	[iCodigo] [int] NOT NULL,
	[iCodigoLito] [int] NULL,
	[iCodigoAlte] [int] NULL,
	[cCodigoBloque] [varchar](100) NULL
) ON [PRIMARY]
GO
