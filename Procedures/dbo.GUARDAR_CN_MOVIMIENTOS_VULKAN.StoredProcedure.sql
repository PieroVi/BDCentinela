/****** Object:  StoredProcedure [dbo].[GUARDAR_CN_MOVIMIENTOS_VULKAN]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CN_MOVIMIENTOS_VULKAN]
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

if @iTipo = 1 
begin

	select
		nref.value('SOURCE[1]','varchar(1000)') [SOURCE],
		nref.value('REGION[1]','varchar(1000)') REGION,
		nref.value('LITO[1]','float') LITO,
		nref.value('ALTE[1]','float') ALTE,
		nref.value('CUEQ[1]','float') CUEQ,
		nref.value('CUT[1]','float') CUT,
		nref.value('CUS[1]','float') CUS,
		nref.value('AU[1]','float') AU,
		nref.value('AG[1]','float') AG,
		nref.value('MO[1]','float') MO,
		nref.value('AS[1]','float') [AS],
		nref.value('CO3[1]','float') CO3,
		nref.value('NO3[1]','float') NO3,
		nref.value('FET[1]','float') FET,
		nref.value('PY_AUX[1]','float') PY_AUX,
		nref.value('LEYC_CUT[1]','float') LEYC_CUT,
		nref.value('LEYC_AU[1]','float') LEYC_AU,
		nref.value('RECG_CU[1]','float') RECG_CU,
		nref.value('RECG_AU[1]','float') RECG_AU,
		nref.value('BWI[1]','float') BWI,
		nref.value('TPH_SAG[1]','float') TPH_SAG,
		nref.value('CPY_AJUS[1]','float') CPY_AJUS,
		nref.value('CCCV_AJUS[1]','float') CCCV_AJUS,
		nref.value('BO_AJUS[1]','float') BO_AJUS,
		nref.value('AXB[1]','float') AXB,
		nref.value('VSED_E[1]','float') VSED_E,
		nref.value('CP_POND[1]','float') CP_POND,
		nref.value('LEY_CON_ROU[1]','float') LEY_CON_ROU,
		nref.value('DOMINIO[1]','float') DOMINIO,
		nref.value('INS[1]','float') INS,
		nref.value('TOTAL_VOLUME[1]','float') TOTAL_VOLUME,
		nref.value('TOTAL_MASS[1]','float') TOTAL_MASS
	into #TempRegistros1
	from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

	insert into CM_IMPORTACION_SULFUROS_LEYES
	select
		@dFechaRPT,
		[SOURCE],
		REGION,
		LITO,
		ALTE,
		CUEQ,
		CUT,
		CUS,
		AU,
		AG,
		MO,
		[AS],
		CO3,
		NO3,
		FET,
		PY_AUX,
		LEYC_CUT,
		LEYC_AU,
		RECG_CU,
		RECG_AU,
		BWI,
		TPH_SAG,
		CPY_AJUS,
		CCCV_AJUS,
		BO_AJUS,
		AXB,
		VSED_E,
		CP_POND,
		LEY_CON_ROU,
		DOMINIO,
		INS,
		TOTAL_VOLUME,
		TOTAL_MASS,
		upper(substring([SOURCE],1,3)) cRajo,
		@iCodigoUsuario
	from
		#TempRegistros1

	select 'MenSys_SaveOK',1

	select
		l.*, p.cNombreMedio1 cRajoDescripcion
	from
		CM_IMPORTACION_SULFUROS_LEYES l
			left join PARAMETROS p on 
				l.cRajo = p.cNombreCorto1 and
				p.cGrupo1 = 'SCM - TAJO'
	where
		dFecha = @dFechaRPT

	exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS @dFechaRPT
end
else
begin

	select
		nref.value('SOURCE[1]','varchar(1000)') [SOURCE],
		nref.value('REGION[1]','varchar(1000)') REGION,
		nref.value('BANCO[1]','varchar(1000)') BANCO,
		nref.value('CUT[1]','float') CUT,
		nref.value('CUS[1]','float') CUS,
		nref.value('CO3[1]','float') CO3,
		nref.value('NO3[1]','float') NO3,
		nref.value('HUM[1]','float') HUM,
		nref.value('REC_HEAP[1]','float') REC_HEAP,
		nref.value('REC_ROM[1]','float') REC_ROM,
		nref.value('CAN_HEAP[1]','float') CAN_HEAP,
		nref.value('CAN_ROM[1]','float') CAN_ROM,
		nref.value('M100[1]','float') M100,
		nref.value('M400[1]','float') M400,
		nref.value('TOTAL_VOLUME[1]','float') TOTAL_VOLUME,
		nref.value('TOTAL_MASS[1]','float') TOTAL_MASS
	into #TempRegistros2
	from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

	insert into CM_IMPORTACION_OXIDOS_LEYES
	select
		@dFechaRPT,
		[SOURCE],
		REGION,
		CUT,
		CUS,
		CO3,
		NO3,
		HUM,
		REC_HEAP,
		REC_ROM,
		CAN_HEAP,
		CAN_ROM,
		M100,
		M400,
		TOTAL_VOLUME,
		TOTAL_MASS,
		upper(substring([SOURCE],1,3)) cRajo,
		--'OXE' cRajo,
		@iCodigoUsuario
	from
		#TempRegistros2
	where
		isnull(BANCO,'') = '' and
		isnull([SOURCE],'') <> ''

	insert into CM_IMPORTACION_OXIDOS_LEYES
	select
		@dFechaRPT,
		[SOURCE],
		REGION,
		CUT,
		CUS,
		CO3,
		NO3,
		HUM,
		REC_HEAP,
		REC_ROM,
		CAN_HEAP,
		CAN_ROM,
		M100,
		M400,
		TOTAL_VOLUME,
		TOTAL_MASS,
		--'OXE' cRajo,--upper(substring([SOURCE],1,3)) cRajo,
		--'' cRajo,
		upper(substring([SOURCE],1,3)) cRajo,
		@iCodigoUsuario
	from
		#TempRegistros2
	where
		isnull(BANCO,'') <> '' and
		BANCO = (select Name from dbo.splitstringV2(REGION,'_') r where r.id = 4)

	select 'MenSys_SaveOK',1

	select
		l.*, p.cNombreMedio1 cRajoDescripcion
		--(select cNombreMedio1 from PARAMETROS where cGrupo1 = 'SCM - TAJO' and iCodigoParametro = 1346) cRajoDescripcion
	from
		CM_IMPORTACION_OXIDOS_LEYES l
			left join PARAMETROS p on 
				l.cRajo = p.cNombreCorto1 and
				p.cGrupo1 = 'SCM - TAJO'
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
