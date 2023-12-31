/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS] --9,'2023-02-12'
@iCodigoDestinoCombo int,
@dFechaRPT date
--WITH RECOMPILE
--BALANCE 333
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

set nocount on;
--SET ANSI_WARNINGS OFF

begin
	
	declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

	--declare @dFechaRPT date = (select top 1 g.dFechaRPT from CM_MOVIMIENTOS_GENERAL g with(nolock) where g.iCodigo = @iCodigo)
	declare @dFechaRPTPrevio date = (select top 1 dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK s with(nolock) where dFechaRPT < @dFechaRPT and s.iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaRPT desc)
	declare @iCodigoPrevio int = (select top 1 iCodigo from CM_MOVIMIENTOS_LEY_STOCK s with(nolock) where dFechaRPT = @dFechaRPTPrevio and iOrdenDesc = 1 and iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaHora desc)
		
	if @iCodigoPrevio is null
	begin
		set @dFechaRPT = '2000-01-01'
	end
	
	delete from CM_MOVIMIENTOS_LEY_STOCK
	where
		dFechaRPT > = @dFechaRPT and
		iCodigoDestinoStock = @iCodigoDestinoCombo
		
	select 
		ROW_NUMBER() OVER(ORDER BY g.dFechaHora ASC) AS id,
		g.iCodigo,
		g.dFechaRPT,
		g.cTurno,
		g.dFechaHora,
		case when l.nCueq is null then 0 else l.nCueq end nCueq,
		case when l.nCut is null then 0 else l.nCut end nCut,
		case when l.nCus is null then 0 else l.nCus end nCus,
		case when l.nAu is null then 0 else l.nAu end nAu,
		case when l.nAg is null then 0 else l.nAg end nAg,
		case when l.nMo is null then 0 else l.nMo end nMo,
		case when l.nAs is null then 0 else l.nAs end nAs,
		case when l.nCo3 is null then 0 else l.nCo3 end nCo3,
		case when l.nNo3 is null then 0 else l.nNo3 end nNo3,
		case when l.nFet is null then 0 else l.nFet end nFet,
		case when l.nPy_Aux is null then 0 else l.nPy_Aux end nPy_Aux,
		case when l.nLeyc_Cut is null then 0 else l.nLeyc_Cut end nLeyc_Cut,
		case when l.nLeyc_Au is null then 0 else l.nLeyc_Au end nLeyc_Au,
		case when l.nRecg_Cu is null then 0 else l.nRecg_Cu end nRecg_Cu,
		case when l.nRecg_Au is null then 0 else l.nRecg_Au end nRecg_Au,
		case when l.nBwi is null then 0 else l.nBwi end nBwi,
		case when l.nTph_Sag is null then 0 else l.nTph_Sag end nTph_Sag,
		case when l.nCpy_Ajus is null then 0 else l.nCpy_Ajus end nCpy_Ajus,
		case when l.nCccv_Ajus is null then 0 else l.nCccv_Ajus end nCccv_Ajus,
		case when l.nBo_Ajus is null then 0 else l.nBo_Ajus end nBo_Ajus,
		case when l.nAxb is null then 0 else l.nAxb end nAxb,
		case when l.nVsed_E is null then 0 else l.nVsed_E end nVsed_E,
		case when l.nCp_Pond is null then 0 else l.nCp_Pond end nCp_Pond,
		case when l.nLey_Con_Rou is null then 0 else l.nLey_Con_Rou end nLey_Con_Rou,
		case when l.nDominio is null then 0 else l.nDominio end nDominio,
		case when l.nIns is null then 0 else l.nIns end nIns,
		isnull(t.nToneladasFlat,0) nToneladasFlat,
		convert(float,case	when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 0
				when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino <> @iCodigoDestinoCombo then -1
				when iCodigoOrigen <> @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 1 end) nMultiplicador,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		1 bProcesar
	into #TempDatos
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_EQUIPOS t with(nolock) on
				g.iCodigo = t.iCodigo
			inner join CM_MOVIMIENTOS_LEY l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN ori with(nolock) on
				g.iCodigo = ori.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO det with(nolock) on
				g.iCodigo = det.iCodigo
	where
		(ori.iCodigoOrigen = @iCodigoDestinoCombo or det.iCodigoDestino = @iCodigoDestinoCombo) and not
		ori.iCodigoOrigen = iCodigoDestino and
		g.dFechaRPT > = @dFechaRPT and
		g.iTipo = 1
	order by 
		g.dFechaHora ASC

	if exists (select 1 from CM_MOVIMIENTOS_LEY_STOCK s where s.iCodigo = @iCodigoPrevio and iCodigoDestinoStock = @iCodigoDestinoCombo)
	begin
		update #TempDatos set
			id = id + 1

		insert into #TempDatos
		select
			1,
			iCodigo,
			dFechaRPT,
			cTurno,
			dFechaHora,

			nCueqStock nCueq,
			nCutStock nCut,
			nCusStock nCus,
			nAuStock nAu,
			nAgStock nAg,
			nMoStock nMo,
			nAsStock nAs,
			nCo3Stock nCo3,
			nNo3Stock nNo3,
			nFetStock nFet,
			nPy_AuxStock nPy_Aux,
			nLeyc_CutStock nLeyc_Cut,
			nLeyc_AuStock nLeyc_Au,
			nRecg_CuStock nRecg_Cu,
			nRecg_AuStock nRecg_Au,
			nBwiStock nBwi,
			nTph_SagStock nTph_Sag,
			nCpy_AjusStock nCpy_Ajus,
			nCccv_AjusStock nCccv_Ajus,
			nBo_AjusStock nBo_Ajus,
			nAxbStock nAxb,
			nVsed_EStock nVsed_E,
			nCp_PondStock nCp_Pond,
			nLey_Con_RouStock nLey_Con_Rou,
			nDominioStock nDominio,
			nInsStock nIns,

			isnull(nToneladasAcum,0) nToneladas,
			1 nMultiplicador,
			@iCodigoDestinoCombo iCodigoDestinoCombo,
			0 bProcesar
		from
			CM_MOVIMIENTOS_LEY_STOCK s
		where
			s.iCodigo = @iCodigoPrevio and 
			s.iCodigoDestinoStock = @iCodigoDestinoCombo
	end

begin --DECLARES
	
	declare @CursoriCodigo float
	declare @CursordFechaRPT date
	declare @CursordFechaHora datetime
	declare @CursorcTurno varchar(1)
	
	declare @CursornToneladas float
	declare @CursornToneladasAcum float = 0
	declare @CursornMultiplicador int

	declare @CursornCueq float
	declare @CursornCut float
	declare @CursornCus float
	declare @CursornAu float
	declare @CursornAg float
	declare @CursornMo float
	declare @CursornAs float
	declare @CursornCo3 float
	declare @CursornNo3 float
	declare @CursornFet float
	declare @CursornPy_Aux float
	declare @CursornLeyc_Cut float
	declare @CursornLeyc_Au float
	declare @CursornRecg_Cu float
	declare @CursornRecg_Au float
	declare @CursornBwi float
	declare @CursornTph_Sag float
	declare @CursornCpy_Ajus float
	declare @CursornCccv_Ajus float
	declare @CursornBo_Ajus float
	declare @CursornAxb float
	declare @CursornVsed_E float
	declare @CursornCp_Pond float
	declare @CursornLey_Con_Rou float
	declare @CursornDominio float
	declare @CursornIns float

	declare @CursornCueqAcum float
	declare @CursornCutAcum float
	declare @CursornCusAcum float
	declare @CursornAuAcum float
	declare @CursornAgAcum float
	declare @CursornMoAcum float
	declare @CursornAsAcum float
	declare @CursornCo3Acum float
	declare @CursornNo3Acum float
	declare @CursornFetAcum float
	declare @CursornPy_AuxAcum float
	declare @CursornLeyc_CutAcum float
	declare @CursornLeyc_AuAcum float
	declare @CursornRecg_CuAcum float
	declare @CursornRecg_AuAcum float
	declare @CursornBwiAcum float
	declare @CursornTph_SagAcum float
	declare @CursornCpy_AjusAcum float
	declare @CursornCccv_AjusAcum float
	declare @CursornBo_AjusAcum float
	declare @CursornAxbAcum float
	declare @CursornVsed_EAcum float
	declare @CursornCp_PondAcum float
	declare @CursornLey_Con_RouAcum float
	declare @CursornDominioAcum float
	declare @CursornInsAcum float

	declare @nLeyAntesCueq float
	declare @nLeyAntesCut float
	declare @nLeyAntesCus float
	declare @nLeyAntesAu float
	declare @nLeyAntesAg float
	declare @nLeyAntesMo float
	declare @nLeyAntesAs float
	declare @nLeyAntesCo3 float
	declare @nLeyAntesNo3 float
	declare @nLeyAntesFet float
	declare @nLeyAntesPy_Aux float
	declare @nLeyAntesLeyc_Cut float
	declare @nLeyAntesLeyc_Au float
	declare @nLeyAntesRecg_Cu float
	declare @nLeyAntesRecg_Au float
	declare @nLeyAntesBwi float
	declare @nLeyAntesTph_Sag float
	declare @nLeyAntesCpy_Ajus float
	declare @nLeyAntesCccv_Ajus float
	declare @nLeyAntesBo_Ajus float
	declare @nLeyAntesAxb float
	declare @nLeyAntesVsed_E float
	declare @nLeyAntesCp_Pond float
	declare @nLeyAntesLey_Con_Rou float
	declare @nLeyAntesDominio float
	declare @nLeyAntesIns float

	declare @nCursornToneladasAntes float

	declare @TableCursorAcum table(
		id int identity(1,1),
		iCodigo int,
		dFechaRPT date,
		dFechaHora datetime,
		cTurno varchar(1),

		nCueq float,
		nCut float,
		nCus float,
		nAu float,
		nAg float,
		nMo float,
		nAs float,
		nCo3 float,
		nNo3 float,
		nFet float,
		nPy_Aux float,
		nLeyc_Cut float,
		nLeyc_Au float,
		nRecg_Cu float,
		nRecg_Au float,
		nBwi float,
		nTph_Sag float,
		nCpy_Ajus float,
		nCccv_Ajus float,
		nBo_Ajus float,
		nAxb float,
		nVsed_E float,
		nCp_Pond float,
		nLey_Con_Rou float,
		nDominio float,
		nIns float,

		nToneladas float
	)

	insert into @TableCursorAcum
	select
		iCodigo,
		dFechaRPT,
		dFechaHora,
		cTurno,

		nCueq,
		nCut,
		nCus,
		nAu,
		nAg,
		nMo,
		nAs,
		nCo3,
		nNo3,
		nFet,
		nPy_Aux,
		nLeyc_Cut,
		nLeyc_Au,
		nRecg_Cu,
		nRecg_Au,
		nBwi,
		nTph_Sag,
		nCpy_Ajus,
		nCccv_Ajus,
		nBo_Ajus,
		nAxb,
		nVsed_E,
		nCp_Pond,
		nLey_Con_Rou,
		nDominio,
		nIns,
		nToneladasFlat
	from
		#TempDatos
	where
		id = 1

end

	select 
		@nCursornToneladasAntes = nToneladasFlat,
		@CursornToneladasAcum = nToneladasFlat,
	
		@nLeyAntesCueq  = nCueq,
		@nLeyAntesCut  = nCut,
		@nLeyAntesCus  = nCus,
		@nLeyAntesAu  = nAu,
		@nLeyAntesAg  = nAg,
		@nLeyAntesMo  = nMo,
		@nLeyAntesAs  = nAs,
		@nLeyAntesCo3  = nCo3,
		@nLeyAntesNo3  = nNo3,
		@nLeyAntesFet  = nFet,
		@nLeyAntesPy_Aux  = nPy_Aux,
		@nLeyAntesLeyc_Cut  = nLeyc_Cut,
		@nLeyAntesLeyc_Au  = nLeyc_Au,
		@nLeyAntesRecg_Cu  = nRecg_Cu,
		@nLeyAntesRecg_Au  = nRecg_Au,
		@nLeyAntesBwi  = nBwi,
		@nLeyAntesTph_Sag  = nTph_Sag,
		@nLeyAntesCpy_Ajus  = nCpy_Ajus,
		@nLeyAntesCccv_Ajus  = nCccv_Ajus,
		@nLeyAntesBo_Ajus  = nBo_Ajus,
		@nLeyAntesAxb  = nAxb,
		@nLeyAntesVsed_E  = nVsed_E,
		@nLeyAntesCp_Pond  = nCp_Pond,
		@nLeyAntesLey_Con_Rou  = nLey_Con_Rou,
		@nLeyAntesDominio  = nDominio,
		@nLeyAntesIns  = nIns
	from 
		#TempDatos where id = 1

	declare @Cursor int = 2
	declare @CursorFin int = (select count(1) from #TempDatos)

	while @Cursor <= @CursorFin
	begin

		select 
			@CursoriCodigo = t.iCodigo,
			@CursordFechaRPT = t.dFechaRPT,
			@CursorcTurno = t.cTurno,
			@CursordFechaHora = t.dFechaHora,
			@CursornToneladas = isnull(t.nToneladasFlat,0),
			@CursornToneladasAcum = isnull(@CursornToneladasAcum,0) + (isnull(t.nToneladasFlat,0) *  t.nMultiplicador),
			@CursornMultiplicador = t.nMultiplicador,

			@CursornCueq = t.nCueq,
			@CursornCut = t.nCut,
			@CursornCus = nCus,
			@CursornAu = nAu,
			@CursornAg = nAg,
			@CursornMo = nMo,
			@CursornAs = nAs,
			@CursornCo3 = nCo3,
			@CursornNo3 = nNo3,
			@CursornFet = nFet,
			@CursornPy_Aux = nPy_Aux,
			@CursornLeyc_Cut = nLeyc_Cut,
			@CursornLeyc_Au = nLeyc_Au,
			@CursornRecg_Cu = nRecg_Cu,
			@CursornRecg_Au = nRecg_Au,
			@CursornBwi = nBwi,
			@CursornTph_Sag = nTph_Sag,
			@CursornCpy_Ajus = nCpy_Ajus,
			@CursornCccv_Ajus = nCccv_Ajus,
			@CursornBo_Ajus = nBo_Ajus,
			@CursornAxb = nAxb,
			@CursornVsed_E = nVsed_E,
			@CursornCp_Pond = nCp_Pond,
			@CursornLey_Con_Rou = nLey_Con_Rou,
			@CursornDominio = nDominio,
			@CursornIns = nIns
		from  
			#TempDatos t
		where
			id = @Cursor		

		set @CursornCueqAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCueq,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCueq,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCueq end

		set @CursornCutAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCut,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCut,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCut end

		set @CursornCusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCus end

		set @CursornAuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAu,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAu,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAu end

		set @CursornAgAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAg,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAg,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAg end

		set @CursornMoAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesMo,0)) + isnull(@CursornToneladas,0)*isnull(@CursornMo,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesMo end

		set @CursornAsAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAs,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAs,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAs end

		set @CursornCo3Acum = Case	when @CursornMultiplicador = 1 then Case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCo3 end

		set @CursornNo3Acum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesNo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornNo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesNo3 end

		set @CursornFetAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesFet,0)) + isnull(@CursornToneladas,0)*isnull(@CursornFet,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesFet end

		set @CursornPy_AuxAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesPy_Aux,0)) + isnull(@CursornToneladas,0)*isnull(@CursornPy_Aux,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesPy_Aux end

		set @CursornLeyc_CutAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesLeyc_Cut,0)) + isnull(@CursornToneladas,0)*isnull(@CursornLeyc_Cut,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesLeyc_Cut end

		set @CursornLeyc_AuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesLeyc_Au,0)) + isnull(@CursornToneladas,0)*isnull(@CursornLeyc_Au,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesLeyc_Au end

		set @CursornRecg_CuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesRecg_Cu,0)) + isnull(@CursornToneladas,0)*isnull(@CursornRecg_Cu,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesRecg_Cu end

		set @CursornRecg_AuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesRecg_Au,0)) + isnull(@CursornToneladas,0)*isnull(@CursornRecg_Au,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesRecg_Au end

		set @CursornBwiAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesBwi,0)) + isnull(@CursornToneladas,0)*isnull(@CursornBwi,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesBwi end

		set @CursornTph_SagAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesTph_Sag,0)) + isnull(@CursornToneladas,0)*isnull(@CursornTph_Sag,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesTph_Sag end

		set @CursornCpy_AjusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCpy_Ajus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCpy_Ajus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCpy_Ajus end

		set @CursornCccv_AjusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCccv_Ajus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCccv_Ajus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCccv_Ajus end

		set @CursornBo_AjusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesBo_Ajus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornBo_Ajus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesBo_Ajus end

		set @CursornAxbAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAxb,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAxb,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAxb end

		set @CursornVsed_EAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesVsed_E,0)) + isnull(@CursornToneladas,0)*isnull(@CursornVsed_E,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesVsed_E end

		set @CursornCp_PondAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCp_Pond,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCp_Pond,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCp_Pond end

		set @CursornLey_Con_RouAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesLey_Con_Rou,0)) + isnull(@CursornToneladas,0)*isnull(@CursornLey_Con_Rou,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesLey_Con_Rou end

		set @CursornDominioAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesDominio,0)) + isnull(@CursornToneladas,0)*isnull(@CursornDominio,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesDominio end

		set @CursornInsAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesIns,0)) + isnull(@CursornToneladas,0)*isnull(@CursornIns,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesIns end

		insert into @TableCursorAcum
		values(
			@CursoriCodigo,
			@CursordFechaRPT, 
			@CursordFechaHora, 
			@CursorcTurno, 

			@CursornCueqAcum,
			@CursornCutAcum,
			@CursornCusAcum,
			@CursornAuAcum,
			@CursornAgAcum,
			@CursornMoAcum,
			@CursornAsAcum,
			@CursornCo3Acum,
			@CursornNo3Acum,
			@CursornFetAcum,
			@CursornPy_AuxAcum,
			@CursornLeyc_CutAcum,
			@CursornLeyc_AuAcum,
			@CursornRecg_CuAcum,
			@CursornRecg_AuAcum,
			@CursornBwiAcum,
			@CursornTph_SagAcum,
			@CursornCpy_AjusAcum,
			@CursornCccv_AjusAcum,
			@CursornBo_AjusAcum,
			@CursornAxbAcum,
			@CursornVsed_EAcum,
			@CursornCp_PondAcum,
			@CursornLey_Con_RouAcum,
			@CursornDominioAcum,
			@CursornInsAcum,
			
			@CursornToneladasAcum)
		
		select 
			@nCursornToneladasAntes = @CursornToneladasAcum,

			 @nLeyAntesCueq = @CursornCueqAcum,
			 @nLeyAntesCut = @CursornCutAcum,
			 @nLeyAntesCus = @CursornCusAcum,
			 @nLeyAntesAu = @CursornAuAcum,
			 @nLeyAntesAg = @CursornAgAcum,
			 @nLeyAntesMo = @CursornMoAcum,
			 @nLeyAntesAs = @CursornAsAcum,
			 @nLeyAntesCo3 = @CursornCo3Acum,
			 @nLeyAntesNo3 = @CursornNo3Acum,
			 @nLeyAntesFet = @CursornFetAcum,
			 @nLeyAntesPy_Aux = @CursornPy_AuxAcum,
			 @nLeyAntesLeyc_Cut = @CursornLeyc_CutAcum,
			 @nLeyAntesLeyc_Au = @CursornLeyc_AuAcum,
			 @nLeyAntesRecg_Cu = @CursornRecg_CuAcum,
			 @nLeyAntesRecg_Au = @CursornRecg_AuAcum,
			 @nLeyAntesBwi = @CursornBwiAcum,
			 @nLeyAntesTph_Sag = @CursornTph_SagAcum,
			 @nLeyAntesCpy_Ajus = @CursornCpy_AjusAcum,
			 @nLeyAntesCccv_Ajus = @CursornCccv_AjusAcum,
			 @nLeyAntesBo_Ajus = @CursornBo_AjusAcum,
			 @nLeyAntesAxb = @CursornAxbAcum,
			 @nLeyAntesVsed_E = @CursornVsed_EAcum,
			 @nLeyAntesCp_Pond = @CursornCp_PondAcum,
			 @nLeyAntesLey_Con_Rou = @CursornLey_Con_RouAcum,
			 @nLeyAntesDominio = @CursornDominioAcum,
			 @nLeyAntesIns = @CursornInsAcum


		set @Cursor = @Cursor + 1
	end

	update CM_MOVIMIENTOS_LEY_STOCK set bUltimo = 0 where iCodigoDestinoStock = @iCodigoDestinoCombo

	update CM_MOVIMIENTOS_LEY_STOCK set bUltimo = 1 
	where
		dFechaRPT = (select top 1 dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK where iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaRPT desc) and
		iCodigoDestinoStock = @iCodigoDestinoCombo and
		iOrdenDesc = 1


	insert into CM_MOVIMIENTOS_LEY_STOCK
	select 
		@iCodigoDestinoCombo,
		ROW_NUMBER() OVER(PARTITION BY dFechaRPT ORDER BY dFechaHora asc) iOrden,
		iCodigo,
		dFechaRPT,
		dFechaHora,
		cTurno,

		nCueq,
		nCut,
		nCus,
		nAu,
		nAg,
		nMo,
		nAs,
		nCo3,
		nNo3,
		nFet,
		nPy_Aux,
		nLeyc_Cut,
		nLeyc_Au,
		nRecg_Cu,
		nRecg_Au,
		nBwi,
		nTph_Sag,
		nCpy_Ajus,
		nCccv_Ajus,
		nBo_Ajus,
		nAxb,
		nVsed_E,
		nCp_Pond,
		nLey_Con_Rou,
		nDominio,
		nIns,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		nToneladas,
		ROW_NUMBER() OVER(PARTITION BY dFechaRPT ORDER BY dFechaHora desc) iOrdenDesc,
		0
	from 
		@TableCursorAcum
	where
		iCodigo <> isnull(@iCodigoPrevio,0)

	update CM_MOVIMIENTOS_LEY_STOCK set bUltimo = 0 where iCodigoDestinoStock = @iCodigoDestinoCombo

	update CM_MOVIMIENTOS_LEY_STOCK set bUltimo = 1 
	where
		dFechaRPT = (select top 1 dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK where iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaRPT desc) and
		iCodigoDestinoStock = @iCodigoDestinoCombo and
		iOrdenDesc = 1
	
end

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	set nocount on;
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
