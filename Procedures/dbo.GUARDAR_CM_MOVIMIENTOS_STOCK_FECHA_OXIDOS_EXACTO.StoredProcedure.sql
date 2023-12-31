/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS_EXACTO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS_EXACTO] --26,'2023-02-12'
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
	
	declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE' and iTipoMineral = 3)

	declare @dFechaRPTPrevio date = (select top 1 dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK s with(nolock) where dFechaRPT < @dFechaRPT and s.iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaRPT desc)
	declare @iCodigoPrevio int = (select top 1 iCodigo from CM_MOVIMIENTOS_LEY_STOCK s with(nolock) where dFechaRPT = @dFechaRPTPrevio and iOrdenDesc = 1 and iCodigoDestinoStock = @iCodigoDestinoCombo order by dFechaHora desc)

	begin --OBTENEMOS STOCK ATRAS
		select distinct
			ori.iCodigo
		into #UbicacionesStocks
		from
			CM_MOVIMIENTOS_GENERAL g with(nolock)
				inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
					g.iCodigo = o.iCodigo
				inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
					g.iCodigo = d.iCodigo
				inner join VIST_CM_UBICACIONES ori on
					o.iCodigoOrigen = ori.iCodigo
				inner join VIST_CM_UBICACIONES det on
					d.iCodigoDestino = det.iCodigo
		where
			g.iTipo = 2 and
			g.dFechaRPT = @dFechaRPT and
			d.iCodigo = @iCodigoDestinoCombo and
			ori.cTipo = 'S' and
			ori.cCodigoEstadistica not in ('BALANCE','NA')

		--select distinct
		--	u.iCodigo
		--into #UbicacionesStocks
		--from
		--	CM_MOVIMIENTOS_GENERAL g with(nolock)
		--		inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o on
		--			g.iCodigo = o.iCodigo
		--		inner join VIST_CM_UBICACIONES u with(nolock) on
		--			o.iCodigoOrigen = u.iCodigo
		--where
		--	u.cTipo in ('S') and
		--	u.cCodigoEstadistica not in ('BALANCE','NA') and
		--	g.dFechaRPT = @dFechaRPT and
		--	g.iTipo = 1

		select
			s.iCodigo,
			(select top 1 st.iOrdenDesc from CM_MOVIMIENTOS_LEY_STOCK st where st.iCodigoDestinoStock = s.iCodigo and st.dFechaRPT < @dFechaRPT and st.iOrdenDesc = 1 order by st.dFechaRPT desc, st.iOrdenDesc asc) iOrdenDesc,
			(select top 1 st.dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK st where st.iCodigoDestinoStock = s.iCodigo and st.dFechaRPT < @dFechaRPT and st.iOrdenDesc = 1 order by st.dFechaRPT desc, st.iOrdenDesc asc) dFechaRPT
		into #UbicacionesStocksFechas
		from
			#UbicacionesStocks s
	end
		
	begin --ACTUALIZAMOS LEYES DE STOCK DESDE TABLA LEYES STOCK
		update l set
			l.nCut = ls.nCutStock, 
			l.nCus = ls.nCusStock,
			l.nCo3 = ls.nCo3Stock,
			l.nNo3 = ls.nNo3Stock,
			l.nHum = NULL,
			l.nRec_Heap = NULL,
			l.nRec_Rom = NULL,
			l.nCan_Heap = NULL,
			l.nCan_Rom = NULL,
			l.nM100 = NULL,
			l.nM400 = NULL
		from 
			CM_MOVIMIENTOS_GENERAL g with(nolock) 
				inner join CM_MOVIMIENTOS_LEY l with(nolock) on
					g.iCodigo = l.iCodigo
				inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN ori with(nolock) on
					g.iCodigo = ori.iCodigo
				inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO det with(nolock) on
					g.iCodigo = det.iCodigo
				inner join VIST_CM_UBICACIONES u on
					ori.iCodigoOrigen = u.iCodigo
				inner join #UbicacionesStocksFechas stl on
					ori.iCodigoOrigen = stl.iCodigo
				left join (select ls1.* from #UbicacionesStocksFechas sf inner join CM_MOVIMIENTOS_LEY_STOCK ls1 with(nolock) on sf.iOrdenDesc = ls1.iOrdenDesc and sf.dFechaRPT = ls1.dFechaRPT and sf.iCodigo = ls1.iCodigoDestinoStock) ls on
					stl.iCodigo = ls.iCodigoDestinoStock
		where
			g.dFechaRPT = @dFechaRPT and
			g.iTipo = 2 and
			u.cTipo in ('S') and
			u.cCodigoEstadistica not in ('BALANCE','NA')
	end

	if @iCodigoPrevio is null
	begin
		set @dFechaRPT = @dFechaRPT
	end
	
	delete from CM_MOVIMIENTOS_LEY_STOCK
	where
		dFechaRPT = @dFechaRPT and
		iCodigoDestinoStock = @iCodigoDestinoCombo

	select 
		ROW_NUMBER() OVER(ORDER BY g.dFechaHora ASC) AS id,
		g.iCodigo,
		g.dFechaRPT,
		g.cTurno,
		g.dFechaHora,
		case when l.nCut is null then 0 else l.nCut end nCut,
		case when l.nCus is null then 0 else l.nCus end nCus,
		case when l.nCo3 is null then 0 else l.nCo3 end nCo3,
		case when l.nNo3 is null then 0 else l.nNo3 end nNo3,
		case when l.nHum is null then 0 else l.nHum end nHum,
		case when l.nRec_Heap is null then 0 else l.nRec_Heap end nRec_Heap,
		case when l.nRec_Rom is null then 0 else l.nRec_Rom end nRec_Rom,
		case when l.nCan_Heap is null then 0 else l.nCan_Heap end nCan_Heap,
		case when l.nCan_Rom is null then 0 else l.nCan_Rom end nCan_Rom,
		case when l.nM100 is null then 0 else l.nM100 end nM100,
		case when l.nM400 is null then 0 else l.nM400 end nM400,
		isnull(t.nToneladasFlat,0) nToneladasFlat,
		convert(float,case	when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 0
				when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino <> @iCodigoDestinoCombo then -1
				when iCodigoOrigen <> @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 1 end) nMultiplicador,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		1 bProcesar,
		case when iCodigoOrigen = (select Top 1 iCodigo from VIST_CM_UBICACIONES where cCodigoEstadistica = 'BALANCE' and iTipoMineral = 3) then 1 else 0 end bBalance
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
		g.dFechaRPT = @dFechaRPT and
		g.iTipo = 2
	order by 
		g.dFechaHora ASC

	--select * from #TempDatos

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

			nCutStock nCut,
			nCusStock nCus,
			nCo3Stock nCo3,
			nNo3Stock nNo3,
			nHumStock nHum,
			nRec_HeapStock nRec_Heap,
			nRec_RomStock nRec_Rom,
			nCan_HeapStock nCan_Heap,
			nCan_RomStock nCan_Rom,
			nM100Stock nM100,
			nM400Stock nM400,

			isnull(nToneladasAcum,0) nToneladas,
			1 nMultiplicador,
			@iCodigoDestinoCombo iCodigoDestinoCombo,
			0 bProcesar,
			0 bBalance
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

	declare @CursornCut float
	declare @CursornCus float
	declare @CursornCo3 float
	declare @CursornNo3 float
	declare @CursornHum float
	declare @CursornRec_Heap float
	declare @CursornRec_Rom float
	declare @CursornCan_Heap float
	declare @CursornCan_Rom float
	declare @CursornM100 float
	declare @CursornM400 float

	declare @CursornCutAcum float
	declare @CursornCusAcum float
	declare @CursornCo3Acum float
	declare @CursornNo3Acum float
	declare @CursornHumAcum float
	declare @CursornRec_HeapAcum float
	declare @CursornRec_RomAcum float
	declare @CursornCan_HeapAcum float
	declare @CursornCan_RomAcum float
	declare @CursornM100Acum float
	declare @CursornM400Acum float

	declare @nLeyAntesCut float
	declare @nLeyAntesCus float
	declare @nLeyAntesCo3 float
	declare @nLeyAntesNo3 float
	declare @nLeyAntesHum float
	declare @nLeyAntesRec_Heap float
	declare @nLeyAntesRec_Rom float
	declare @nLeyAntesCan_Heap float
	declare @nLeyAntesCan_Rom float
	declare @nLeyAntesM100 float
	declare @nLeyAntesM400 float

	declare @nCursornToneladasAntes float

	declare @CursorbBalance bit

	declare @TableCursorAcum table(
		id int identity(1,1),
		iCodigo int,
		dFechaRPT date,
		dFechaHora datetime,
		cTurno varchar(1),

		nCut float,
		nCus float,
		nCo3 float,
		nNo3 float,
		nHum float,
		nRec_Heap float,
		nRec_Rom float,
		nCan_Heap float,
		nCan_Rom float,
		nM100 float,
		nM400 float,

		nToneladas float
	)

	insert into @TableCursorAcum
	select
		iCodigo,
		dFechaRPT,
		dFechaHora,
		cTurno,

		nCut,
		nCus,
		nCo3,
		nNo3,
		nHum,
		nRec_Heap,
		nRec_Rom,
		nCan_Heap,
		nCan_Rom,
		nM100,
		nM400,
		nToneladasFlat
	from
		#TempDatos
	where
		id = 1

end

	select 
		@nCursornToneladasAntes = nToneladasFlat,
		@CursornToneladasAcum = nToneladasFlat,
	
		@nLeyAntesCut  = nCut,
		@nLeyAntesCus  = nCus,
		@nLeyAntesCo3  = nCo3,
		@nLeyAntesNo3  = nNo3,
		@nLeyAntesHum  = nHum,
		@nLeyAntesRec_Heap = nRec_Heap,
		@nLeyAntesRec_Rom  = nRec_Rom,
		@nLeyAntesCan_Heap  = nCan_Heap,
		@nLeyAntesCan_Rom  = nCan_Rom,
		@nLeyAntesM100  = nM100,
		@nLeyAntesM400  = nM400
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
			--@CursornToneladasAcum = isnull(@CursornToneladasAcum,0) + (isnull(t.nToneladasFlat,0) *  t.nMultiplicador),
			@CursornToneladasAcum = case when t.bBalance = 1 then  isnull(t.nToneladasFlat,0) else isnull(@CursornToneladasAcum,0) + (isnull(t.nToneladasFlat,0) *  t.nMultiplicador) end,
			@CursornMultiplicador = t.nMultiplicador,

			@CursornCut = t.nCut,
			@CursornCus = nCus,
			@CursornCo3 = nCo3,
			@CursornNo3 = nNo3,
			@CursornHum= nHum,
			@CursornRec_Heap = nRec_Heap,
			@CursornRec_Rom = nRec_Rom,
			@CursornCan_Heap = nCan_Heap,
			@CursornCan_Rom = nCan_Rom,
			@CursornM100 = nM100,
			@CursornM400 = nM400,
			@CursorbBalance = t.bBalance
		from  
			#TempDatos t
		where
			id = @Cursor		

		if @CursorbBalance = 1
		begin

			set @CursornCutAcum = @CursornCut
			set @CursornCusAcum = @CursornCus
			set @CursornCo3Acum = @CursornCo3
			set @CursornNo3Acum = @CursornNo3
			set @CursornHumAcum= @CursornHum
			set @CursornRec_HeapAcum = @CursornRec_Heap
			set @CursornRec_RomAcum = @CursornRec_Rom
			set @CursornCan_HeapAcum = @CursornCan_Heap
			set @CursornCan_RomAcum = @CursornCan_Rom
			set @CursornM100Acum = @CursornM100
			set @CursornM400Acum = @CursornM400
		
			insert into @TableCursorAcum
			values(
				@CursoriCodigo,
				@CursordFechaRPT, 
				@CursordFechaHora, 
				@CursorcTurno, 

				@CursornCutAcum,
				@CursornCusAcum,
				@CursornCo3Acum,
				@CursornNo3Acum,
				@CursornHumAcum,
				@CursornRec_HeapAcum,
				@CursornRec_RomAcum,
				@CursornCan_HeapAcum,
				@CursornCan_RomAcum,
				@CursornM100Acum,
				@CursornM400Acum,
			
				@CursornToneladas)

			set @nCursornToneladasAntes = @CursornToneladas
		end
		else
		begin
			set @CursornCutAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCut,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCut,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesCut end

			set @CursornCusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesCus end

			set @CursornCo3Acum = Case	when @CursornMultiplicador = 1 then Case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesCo3 end

			set @CursornNo3Acum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesNo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornNo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesNo3 end

			set @CursornHumAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesHum,0)) + isnull(@CursornToneladas,0)*isnull(@CursornHum,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesHum end

			set @CursornRec_HeapAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesRec_Heap,0)) + isnull(@CursornToneladas,0)*isnull(@CursornRec_Heap,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesRec_Heap end

			set @CursornRec_RomAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesRec_Rom,0)) + isnull(@CursornToneladas,0)*isnull(@CursornRec_Rom,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesRec_Rom end

			set @CursornCan_HeapAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCan_Heap,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCan_Heap,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesCan_Heap end

			set @CursornCan_RomAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCan_Rom,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCan_Rom,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesCan_Rom end

			set @CursornM100Acum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesM100,0)) + isnull(@CursornToneladas,0)*isnull(@CursornM100,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesM100 end

			set @CursornM400Acum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesM400,0)) + isnull(@CursornToneladas,0)*isnull(@CursornM400,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
										when @CursornMultiplicador = -1 then @nLeyAntesM400 end

			insert into @TableCursorAcum
			values(
				@CursoriCodigo,
				@CursordFechaRPT, 
				@CursordFechaHora, 
				@CursorcTurno, 

				@CursornCutAcum,
				@CursornCusAcum,
				@CursornCo3Acum,
				@CursornNo3Acum,
				@CursornHumAcum,
				@CursornRec_HeapAcum,
				@CursornRec_RomAcum,
				@CursornCan_HeapAcum,
				@CursornCan_RomAcum,
				@CursornM100Acum,
				@CursornM400Acum,
			
				@CursornToneladasAcum)

			set @nCursornToneladasAntes = @CursornToneladasAcum
		end

		
		select 
			@nCursornToneladasAntes = @CursornToneladasAcum,

			 @nLeyAntesCut = @CursornCutAcum,
			 @nLeyAntesCus = @CursornCusAcum,
			 @nLeyAntesCo3 = @CursornCo3Acum,
			 @nLeyAntesNo3 = @CursornNo3Acum,
			 @nLeyAntesHum = @CursornHumAcum,
			 @nLeyAntesRec_Heap = @CursornRec_HeapAcum,
			 @nLeyAntesRec_Rom = @CursornRec_RomAcum,
			 @nLeyAntesCan_Heap = @CursornCan_HeapAcum,
			 @nLeyAntesCan_Rom = @CursornCan_RomAcum,
			 @nLeyAntesM100 = @CursornM100Acum,
			 @nLeyAntesM400 = @CursornM400Acum
			 
		set @Cursor = @Cursor + 1
	end

	insert into CM_MOVIMIENTOS_LEY_STOCK
	select 
		@iCodigoDestinoCombo,
		ROW_NUMBER() OVER(PARTITION BY dFechaRPT ORDER BY dFechaHora asc) iOrden,
		iCodigo,
		dFechaRPT,
		dFechaHora,
		cTurno,

		NULL,
		nCut,
		nCus,
		NULL,
		NULL,
		NULL,
		NULL,
		nCo3,
		nNo3,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		nHum,
		nRec_Heap,
		nRec_Rom,
		nCan_Heap,
		nCan_Rom,
		nM100,
		nM400,
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
