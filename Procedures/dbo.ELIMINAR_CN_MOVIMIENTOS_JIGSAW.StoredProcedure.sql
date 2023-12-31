/****** Object:  StoredProcedure [dbo].[ELIMINAR_CN_MOVIMIENTOS_JIGSAW]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ELIMINAR_CN_MOVIMIENTOS_JIGSAW]
@dFechaRPT date,
@iTipo int,
@cXMLRegistros xml
with recompile
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

SET LANGUAGE spanish;  

if @iTipo = 1 
begin
	select
		nref.value('id[1]','int') id
	into #TempRegistros1
	from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

	delete from CM_IMPORTACION_SULFUROS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT and
		id not in (select id from #TempRegistros1)

	select 'MenSys_DeleteOk',1

	select
		*
	from
		CM_IMPORTACION_SULFUROS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT

	exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS @dFechaRPT
end
else
begin
	select
		nref.value('id[1]','int') id
	into #TempRegistros2
	from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

	delete from CM_IMPORTACION_OXIDOS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT and
		id not in (select id from #TempRegistros2)

	select 'MenSys_DeleteOk',1

	select
		*
	from
		CM_IMPORTACION_OXIDOS_MOVIMIENTOS
	where
		dFecha = @dFechaRPT

	exec MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS @dFechaRPT
end




COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
