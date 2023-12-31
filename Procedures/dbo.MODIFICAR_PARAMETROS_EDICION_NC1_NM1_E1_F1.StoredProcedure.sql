/****** Object:  StoredProcedure [dbo].[MODIFICAR_PARAMETROS_EDICION_NC1_NM1_E1_F1]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MODIFICAR_PARAMETROS_EDICION_NC1_NM1_E1_F1]
	@xml xml
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @Table table(
		iCodigoParametro int,
		cNombreCorto1 varchar(100),
		cNombreMedio1 varchar(500),
		iEntero1 int,
		nFlotante1 float,
		cGrupo1 varchar(500),	
		bEstado bit
	)
	insert into @Table
	select
		nref.value('iCodigoParametro[1]','int'),
		nref.value('cNombreCorto1[1]','varchar(100)'),
		nref.value('cNombreMedio1[1]','varchar(500)'),
		nref.value('iEntero1[1]','int'),
		nref.value('nFlotante1[1]','float'),
		nref.value('cGrupo1[1]','varchar(500)'),
		nref.value('bEstado[1]','bit')
	from @xml.nodes('/NewDataSet/Table') as R(nref)	
	OPTION (OPTIMIZE FOR (@xml = NULL))

	update p set 
		p.cNombreCorto1 = r.cNombreCorto1,
		p.cNombreMedio1 = r.cNombreMedio1,
		p.iEntero1 = r.iEntero1,
		p.nFlotante1 = r.nFlotante1,
		p.bEstado = r.bEstado
	from PARAMETROS p
		inner join @Table r on
			p.iCodigoParametro = r.iCodigoParametro

	select 'MenSys_EjecutionOK',''

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
