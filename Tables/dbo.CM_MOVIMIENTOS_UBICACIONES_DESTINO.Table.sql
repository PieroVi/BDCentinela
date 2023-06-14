/****** Object:  Table [dbo].[CM_MOVIMIENTOS_UBICACIONES_DESTINO]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CM_MOVIMIENTOS_UBICACIONES_DESTINO](
	[iCodigo] [int] NOT NULL,
	[iCodigoDestino] [int] NOT NULL,
	[nEastingDestino] [float] NULL,
	[nNorthingDestino] [float] NULL,
	[nElevationDestino] [float] NULL,
	[nLongitudDestino] [float] NULL,
	[nLatitudDestino] [float] NULL,
 CONSTRAINT [PK_CM_MOVIMIENTOS_UBICACIONES_DESTINO] PRIMARY KEY CLUSTERED 
(
	[iCodigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CM_MOVIMIENTOS_UBICACIONES_DESTINO]  WITH CHECK ADD  CONSTRAINT [FK_CM_MOVIMIENTOS_UBICACIONES_DESTINO_CM_UBICACIONES] FOREIGN KEY([iCodigoDestino])
REFERENCES [dbo].[CM_UBICACIONES] ([iCodigo])
GO
ALTER TABLE [dbo].[CM_MOVIMIENTOS_UBICACIONES_DESTINO] CHECK CONSTRAINT [FK_CM_MOVIMIENTOS_UBICACIONES_DESTINO_CM_UBICACIONES]
GO
