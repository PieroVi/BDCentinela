/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS] --9,'2023-02-12'
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
		g.iTipo = 2
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
		@nLeyAntesRec_Heap  = nRec_Heap,
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
			@CursornToneladasAcum = isnull(@CursornToneladasAcum,0) + (isnull(t.nToneladasFlat,0) *  t.nMultiplicador),
			@CursornMultiplicador = t.nMultiplicador,

			@CursornCut = t.nCut,
			@CursornCus = nCus,
			@CursornCo3 = nCo3,
			@CursornNo3 = nNo3,
			@CursornHum = nHum,
			@CursornRec_Heap = nRec_Heap,
			@CursornRec_Rom = nRec_Rom,
			@CursornCan_Heap = nCan_Heap,
			@CursornCan_Rom = nCan_Rom,
			@CursornM100 = nM100,
			@CursornM400 = nM400
		from  
			#TempDatos t
		where
			id = @Cursor		

		set @CursornCutAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCut,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCut,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCut end

		set @CursornCusAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCus,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCus,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCus end

		set @CursornCo3Acum = Case	when @CursornMultiplicador = 1 then Case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCo3 end

		set @CursornNo3Acum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesNo3,0)) + isnull(@CursornToneladas,0)*isnull(@CursornNo3,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesNo3 end

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
