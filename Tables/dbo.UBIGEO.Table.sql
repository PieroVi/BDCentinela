/****** Object:  Table [dbo].[UBIGEO]    Script Date: 14/06/2023 08:45:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UBIGEO](
	[iCodigoUbigeo] [int] NOT NULL,
	[iCodigoUbigeoPadre] [int] NULL,
	[cCodigoUbigeo] [varchar](6) NOT NULL,
	[cCodigoUbigeoPadre] [varchar](6) NULL,
	[cDescripcion] [varchar](100) NOT NULL,
	[bDepartamento] [bit] NOT NULL,
	[cCodigoDepartamento] [varchar](6) NULL,
	[cDepartamento] [varchar](100) NULL,
	[bProvincia] [bit] NOT NULL,
	[cCodigoProvincia] [varchar](6) NULL,
	[cProvincia] [varchar](100) NULL,
	[bDistrito] [bit] NOT NULL,
	[cCodigoDistrito] [varchar](6) NULL,
	[cDistrito] [varchar](100) NULL,
	[cDescripcionGeneral] [varchar](300) NOT NULL,
	[iTipo] [int] NOT NULL,
	[sCodigoUbigeo] [smallint] NULL,
 CONSTRAINT [PK_UBIGEO] PRIMARY KEY CLUSTERED 
(
	[iCodigoUbigeo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
