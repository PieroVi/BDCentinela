/****** Object:  StoredProcedure [dbo].[MODIFICAR_SCM_DASHBOARD_POR_USUARIO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_SCM_DASHBOARD_POR_USUARIO]
@iCodigoUsuario int,
@cData xml
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @tabla table(
		iCodigoDB int,
		cNombre varchar(500),
		cObservacion varchar(max),
		iOrden int,
		bPublico bit,
		iMinutos int,
		bPresentacion bit,
		dFechaInicio date,
		bAhora bit,
		dFechaFin date
	)
	insert into @tabla
	select
		nref.value('iCodigoDB[1]','Int') iCodigoDB,
		nref.value('cNombre[1]','varchar(500)') cNombre,
		nref.value('cObservacion[1]','varchar(max)') cObservacion,
		nref.value('iOrden[1]','Int') iOrden,
		nref.value('bPublico[1]','bit') bPublico,
		nref.value('iMinutos[1]','Int') iMinutos,
		nref.value('bPresentacion[1]','bit') bPresentacion,
		nref.value('dFechaInicio[1]','date') dFechaInicio,
		nref.value('bAhora[1]','bit') bAhora,
		nref.value('dFechaFin[1]','date') dFechaFin
	from @cData.nodes('/NewDataSet/Table') as R(nref)
	OPTION (OPTIMIZE FOR (@cData = NULL))

	update t Set
 		t.cNombre = r.cNombre,
 		t.cObservacion = r.cObservacion,
 		t.iOrden = r.iOrden,
 		t.bPublico = r.bPublico,
 		t.iMinutos = r.iMinutos,
		t.bPresentacion = r.bPresentacion,
		t.dFechaInicio = r.dFechaInicio,
		t.bAhora = r.bAhora,
		t.dFechaFin = r.dFechaFin
	from 
		SCM_DASHBOARD t
			inner join @tabla r on
				t.iCodigoDB = r.iCodigoDB
	where
		iCodigoUsuario = @iCodigoUsuario
	
	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END







GO
