/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_UBICACIONES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CM_UBICACIONES]
@cCodigoEstadistica varchar(200),
@cCodigoFisica varchar(200),
@cDescripcion varchar(400),
@cAlias varchar(50),
@cTipo varchar(1),
@bAplica bit,
@bEstado bit,
@cCondicion varchar(500),
@iTajo int,
@iCalidadMineral int,
@nLeyPromedio float,
@cObservacion varchar(500),
@cMinaCancha varchar(50),
@cFase varchar(20),
@cBanco varchar(20),
@cMalla varchar(20),
@cTmat varchar(20),
@cPoligono varchar(20),
@iTipoMineral int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	INSERT INTO [dbo].[CM_UBICACIONES]
           (cCodigoEstadistica,
			cCodigoFisica,
			cDescripcion,
			cAlias,
			cTipo,
			bAplica,
			bEstado,
			cCondicion,
			iTajo,
			iCalidadMineral,
			nLeyPromedio,
			cObservacion,
			cMinaCancha,
			cFase,
			cBanco,
			cMalla,
			cTmat,
			cPoligono,
			iTipoMineral)
     VALUES
           (@cCodigoEstadistica,
			@cCodigoFisica,
			@cDescripcion,
			@cAlias,
			@cTipo,
			@bAplica,
			@bEstado,
			@cCondicion,
			@iTajo,
			@iCalidadMineral,
			@nLeyPromedio,
			@cObservacion,
			@cMinaCancha,
			@cFase,
			@cBanco,
			@cMalla,
			@cTmat,
			@cPoligono,
			@iTipoMineral)

	declare @iCodigo int= (Select Ident_Current('CM_UBICACIONES'))

	
	select 'MenSys_SaveOK', @iCodigo

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
