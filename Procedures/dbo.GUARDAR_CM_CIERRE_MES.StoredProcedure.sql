/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_CIERRE_MES]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CM_CIERRE_MES] --'2022-01-01','2023-01-01'
@xml xml
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @tabla table(
		dFecha date,
		bCierre bit
	)
	insert into @tabla
	select
		nref.value('dFecha[1]','date'),
		nref.value('bCierre[1]','bit')
	from @xml.nodes('/NewDataSet/Table') as R(nref)
	OPTION (OPTIMIZE FOR (@xml = NULL))
	
	delete from CM_CIERRE
	where dFecha in (select dFecha from @tabla)

	insert into CM_CIERRE
	select * from @tabla

	select 'MenSys_EditOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
