/****** Object:  StoredProcedure [dbo].[MOSTRAR_CARGA]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CARGA]
as
SELECT [iCodigo]
      ,[iCodigoEquipo]
      ,[dFechaIngreso]
      ,[nAserrinCantidad]
      ,[nAserrinLitros]
      ,[nVirutaCantidad]
      ,[nVirutaLitros]
      ,[nRROOCantidad]
      ,[nRROOLitros]
      ,[dFechaMaduración]
      ,[dFechaFin]
      ,[cObservacion]
	  ,P.cNombreCorto1 EquipoDescripcion
	  ,CONVERT (varchar(10),[dFechaIngreso], 103)  + ' - ' + P.cNombreCorto1 cNombre
  FROM [dbo].[COMPOSTAJE] C
  inner join PARAMETROS P ON P.iCodigoParametro = C.iCodigoEquipo
GO
