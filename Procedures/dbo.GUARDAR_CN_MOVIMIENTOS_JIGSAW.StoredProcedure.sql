/****** Object:  StoredProcedure [dbo].[GUARDAR_CN_MOVIMIENTOS_JIGSAW]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CN_MOVIMIENTOS_JIGSAW]
@dFechaRPT date,
@iCodigoUsuario int,
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

select
	nref.value('Dia[1]','varchar(500)') Dia,
	nref.value('turno[1]','varchar(500)') turno,
	nref.value('grade_new[1]','varchar(500)') grade_new,
	nref.value('textbox21[1]','varchar(500)') textbox21,
	nref.value('camion[1]','varchar(500)') camion,
	nref.value('palas[1]','varchar(500)') palas,
	convert(float,nref.value('factor[1]','varchar(500)')) factor,
	nref.value('name[1]','varchar(500)') name,
	convert(bit,nref.value('mezcla[1]','varchar(500)')) mezcla,
	nref.value('time_full2[1]','varchar(500)') time_full2,
	nref.value('time_empty2[1]','varchar(500)') time_empty2,
	nref.value('Tronada[1]','varchar(500)') Tronada
into #TempRegistros
from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

if @iTipo = 1 
begin

	insert into CM_IMPORTACION_SULFUROS_MOVIMIENTOS
	select
		Dia,
		turno,
		grade_new,
		textbox21,
		camion,
		palas,
		factor,
		name,
		mezcla,
		time_full2,
		time_empty2,
		Tronada,
		@iCodigoUsuario
	from
		#TempRegistros

	select 'MenSys_SaveOK',1

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

	insert into CM_IMPORTACION_OXIDOS_MOVIMIENTOS
	select
		Dia,
		turno,
		grade_new,
		textbox21,
		camion,
		palas,
		factor,
		name,
		mezcla,
		time_full2,
		time_empty2,
		Tronada,
		@iCodigoUsuario
	from
		#TempRegistros

	select 'MenSys_SaveOK',1

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
