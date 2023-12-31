/****** Object:  StoredProcedure [dbo].[GUARDAR_PARAMETROS_JERARQUIA_NC1_NM1_E1_E2_POSICIONES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_PARAMETROS_JERARQUIA_NC1_NM1_E1_E2_POSICIONES]
	@xml xml
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @Table table(
		iCodigoParametro int,
		iCodigoParametroPadre int,
		iOrden int
	)

	insert into @Table
	select
		nref.value('iCodigoParametro[1]','int'),
		nref.value('iCodigoParametroPadre[1]','int'),
		nref.value('iOrden[1]','int')
	from @xml.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@xml = NULL))

	Update a
	Set
		a.iEntero2 = t.iCodigoParametroPadre,
		a.iEntero1 = t.iOrden
	from PARAMETROS a
		inner join @Table t on
			a.iCodigoParametro = t.iCodigoParametro

	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
