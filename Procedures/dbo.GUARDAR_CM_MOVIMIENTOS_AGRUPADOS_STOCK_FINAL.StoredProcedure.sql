/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL] --1,335
@iTipoMovimiento int,
@iCodigoDestinoCombo int
WITH RECOMPILE
--BALANCE 333
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

set nocount on;
begin
	select 
		g.iCodigo,
		g.iTipoMovimiento,
		case when g.iTipoMovimiento = 1 then 'ESTADISTICA - WENCO' else 'FISICA - VULCAN' end cTipoMovimiento,
		g.dFechaRPT,
		g.nAu,
		g.nAg,
		g.nAs,
		g.nHg,
		g.nCu,
		g.nPb,
		g.nZn,
		g.nS,
		g.nDensidad,
		g.nToneladas,
		g.nToneladasFlat,
		case	when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 0
				when iCodigoOrigen = @iCodigoDestinoCombo and iCodigoDestino <> @iCodigoDestinoCombo then -1
				when iCodigoOrigen <> @iCodigoDestinoCombo and iCodigoDestino = @iCodigoDestinoCombo then 1 end nMultiplicador,
		g.iCodigoOrigen,
		deto.cDescripcion cDescripcionOrigen,
		deto.cAlias cAliasOrigen,
		deto.cTipo cTipoOrigen,
		g.iCodigoDestino,
		detd.cDescripcion cDescripcionDestino,
		detd.cAlias cAliasDestino,
		detd.cTipo cTipoDestino,
		@iCodigoDestinoCombo iCodigoDestinoCombo,
		g.iViajes
	into #TempDatos
	from 
		CM_MOVIMIENTOS_GENERAL_AGRUPADO g with(nolock) 
			inner join CM_UBICACIONES deto with(nolock) on
				g.iCodigoOrigen = deto.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				g.iCodigoDestino = detd.iCodigo
	where
		iTipoMovimiento = @iTipoMovimiento and
		(iCodigoOrigen = @iCodigoDestinoCombo or iCodigoDestino = @iCodigoDestinoCombo) and not
		iCodigoOrigen = iCodigoDestino

	select 
		ROW_NUMBER() OVER(ORDER BY dFechaRPT ASC , cDescripcionOrigen ASC) AS Id, 
		ROW_NUMBER() OVER(ORDER BY dFechaRPT DESC , cDescripcionOrigen ASC) AS IdDesc,
		iCodigo,
		iTipoMovimiento,
		cTipoMovimiento,
		dFechaRPT,
		case when nAu = 0 then NULL else nAu end nAu,
		case when nAg = 0 then NULL else nAg end nAg,
		case when nAs = 0 then NULL else nAs end nAs,
		case when nHg = 0 then NULL else nHg end nHg,
		case when nCu = 0 then NULL else nCu end nCu,
		case when nPb = 0 then NULL else nPb end nPb,
		case when nZn = 0 then NULL else nZn end nZn,
		case when nS = 0 then NULL else nS end nS,
		case when nDensidad = 0 then NULL else nDensidad end nDensidad,
		nToneladas,
		nToneladasFlat,
		nToneladas*nMultiplicador nToneladasV1,
		nToneladasFlat*nMultiplicador nToneladasFlatV1,
		case when nMultiplicador = -1 then nToneladas else 0 end nToneladasV1Restar,
		case when nMultiplicador = -1 then nToneladasFlat  else 0 end nToneladasFlatV1Restar,
		iCodigoOrigen,
		cDescripcionOrigen,
		cAliasOrigen,
		cTipoOrigen,
		iCodigoDestino,
		cDescripcionDestino,
		cAliasDestino,
		cTipoDestino,
		iCodigoDestinoCombo,
		iViajes,
		nMultiplicador
	into #TempDatos2
	from 
		#TempDatos 
	order by 1 asc

	declare @TableCursor table(
		Id int,
		IdDesc int,
		nToneladas float,
		nAu float,
		nAg float,
		nAs float,
		nHg float,
		nCu float,
		nPb float,
		nZn float,
		nS float,
		nDensidad float
	)

begin --DECLARES
	declare @CursorId int
	declare @CursorIdDesc int
	declare @CursornToneladas float
	declare @CursornToneladasAcum float
	declare @CursornMultiplicador int
	declare @CursornAu float
	declare @CursornAuAcum float
	declare @CursornAg float
	declare @CursornAgAcum float
	declare @CursornAs float
	declare @CursornAsAcum float
	declare @CursornHg float
	declare @CursornHgAcum float
	declare @CursornCu float
	declare @CursornCuAcum float
	declare @CursornPb float
	declare @CursornPbAcum float
	declare @CursornZn float
	declare @CursornZnAcum float
	declare @CursornS float
	declare @CursornSAcum float
	declare @CursornDensidad float
	declare @CursornDensidadAcum float
	declare @nCursornToneladasAntes float
	declare @nLeyAntesAu float
	declare @nLeyAntesAg float
	declare @nLeyAntesAs float
	declare @nLeyAntesHg float
	declare @nLeyAntesCu float
	declare @nLeyAntesPb float
	declare @nLeyAntesZn float
	declare @nLeyAntesS float
	declare @nLeyAntesDensidad float
end

	declare @Cursor int = 1
	declare @CursorFin int = (select count(1) from #TempDatos2)
	while @Cursor <= @CursorFin
	begin

		select 
			@CursorId = t.Id,
			@CursorIdDesc = t.IdDesc,
			@CursornToneladas = t.nToneladasFlat,
			@CursornToneladasAcum = isnull((select sum(t2.nToneladasFlatV1) from #TempDatos2 t2 where t2.Id <= t.Id),0),
			@CursornMultiplicador = t.nMultiplicador,
			@CursornAu = t.nAu,
			@CursornAg = t.nAg,
			@CursornAs = t.nAs,
			@CursornHg = t.nHg,
			@CursornCu = t.nCu,
			@CursornPb = t.nPb,
			@CursornZn = t.nZn,
			@CursornS = t.nS,
			@CursornDensidad = t.nDensidad
		from  
			#TempDatos2 t
		where
			id = @Cursor
			
		select 
			@nCursornToneladasAntes = nToneladas,
			@nLeyAntesAu = nAu,
			@nLeyAntesAg = nAg,
			@nLeyAntesAs = nAs,
			@nLeyAntesHg = nHg,
			@nLeyAntesCu = nCu,
			@nLeyAntesPb = nPb,
			@nLeyAntesZn = nZn,
			@nLeyAntesS = nS,
			@nLeyAntesDensidad = nDensidad
		from
			@TableCursor
		where
			Id = @Cursor - 1

		set @CursornAuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAu,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAu,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAu end

		set @CursornAgAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAg,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAg,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAg end

		set @CursornAsAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesAs,0)) + isnull(@CursornToneladas,0)*isnull(@CursornAs,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesAs end

		set @CursornHgAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesHg,0)) + isnull(@CursornToneladas,0)*isnull(@CursornHg,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesHg end

		set @CursornCuAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesCu,0)) + isnull(@CursornToneladas,0)*isnull(@CursornCu,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesCu end

		set @CursornPbAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesPb,0)) + isnull(@CursornToneladas,0)*isnull(@CursornPb,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesPb end

		set @CursornZnAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesZn,0)) + isnull(@CursornToneladas,0)*isnull(@CursornZn,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesZn end

		set @CursornSAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesS,0)) + isnull(@CursornToneladas,0)*isnull(@CursornS,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesS end

		set @CursornDensidadAcum = case	when @CursornMultiplicador = 1 then case when (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) = 0 then NULL else ((isnull(@nCursornToneladasAntes,0)*isnull(@nLeyAntesDensidad,0)) + isnull(@CursornToneladas,0)*isnull(@CursornDensidad,0)) / (isnull(@nCursornToneladasAntes,0) + isnull(@CursornToneladas,0)) end
									when @CursornMultiplicador = -1 then @nLeyAntesDensidad end

		insert into @TableCursor
		values(@CursorId,@CursorIdDesc, @CursornToneladasAcum, @CursornAuAcum, @CursornAgAcum, @CursornAsAcum, @CursornHgAcum, @CursornCuAcum, @CursornPbAcum, @CursornZnAcum, @CursornSAcum, @CursornDensidadAcum)

		set @Cursor = @Cursor + 1
	end

	delete from CM_MOVIMIENTOS_DESTINO_STOCK_MOVIMIENTOS where iTipoMovimiento = @iTipoMovimiento and iCodigoDestinoCombo = @iCodigoDestinoCombo

	insert into CM_MOVIMIENTOS_DESTINO_STOCK_MOVIMIENTOS
	select 
		r.*, 
		p.nToneladas nToneladasFlatV1_Acum,
		p.nAu nAuStock,
		p.nAg nAgStock,
		p.nAs nAsStock,
		p.nHg nHgStock,
		p.nCu nCuStock,
		p.nPb nPbStock,
		p.nZn nZnStock,
		p.nS nSStock,
		p.nDensidad nDensidadStock	
	from 
		#TempDatos2 r 
			inner join @TableCursor p on 
				r.Id = p.Id

	select 
		g.iCodigo,
		e.nToneladas,
		e.nToneladasFlat,
		ptr.cDescripcion cCodigoTipoRoca_GROCK,
		pal.cDescripcion cCodigoTipoAlteracion_AROCK,
		zmi.cDescripcion cCodigoZonaMineral_MROCK,
		pdu.cDescripcion cCodigoDurezaRelativa_DUREZA,
		pmat.cDescripcion cCodigoMaterial,
		p.cCodigoBloque,
		l.nAu,
		l.nAg,
		l.nAs,
		l.nHg,
		l.nCu,
		l.nPb,
		l.nZn,
		l.nS,
		l.nDensidad
	into #TempGeneralParametros
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS p with(nolock) on
				g.iCodigo = p.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS ptr with(nolock) on
				p.iCodigoTipoRoca_GROCK = ptr.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pal with(nolock) on
				p.iCodigoTipoAlteracion_AROCK = pal.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS zmi with(nolock) on
				p.iCodigoZonaMineral_MROCK = zmi.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pdu with(nolock) on
				p.iCodigoDurezaRelativa_DUREZA = pdu.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pmat with(nolock) on
				p.iCodigoMaterial = pmat.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
			inner join CM_MOVIMIENTOS_LEYES l on
				g.iCodigo = l.iCodigo
	where
		g.iTipoMovimiento = @iTipoMovimiento and
		d.iCodigoDestino = @iCodigoDestinoCombo and
		o.iCodigoOrigen <> 333

	declare @TonelajeTotalPayload float = (select sum(nToneladas) from #TempGeneralParametros)
	declare @TonelajeTotalNominal float = (select sum(nToneladasFlat) from #TempGeneralParametros)

	select		
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'MATERIAL' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoMaterial cCodigo,
		NULL nAu,
		NULL nAg,
		NULL nAs,
		NULL nHg,
		NULL nCu,
		NULL nPb,
		NULL nZn,
		NULL nS,
		NULL nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	into #tempParametrosStock
	from
		#TempGeneralParametros
	group by
		cCodigoMaterial
	union all
	select
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'DUREZA RELATIVA | DUREZA' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoDurezaRelativa_DUREZA cCodigo,
		NULL nAu,
		NULL nAg,
		NULL nAs,
		NULL nHg,
		NULL nCu,
		NULL nPb,
		NULL nZn,
		NULL nS,
		NULL nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	from
		#TempGeneralParametros
	group by
		cCodigoDurezaRelativa_DUREZA
	union all
	select
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'ZONA MINERAL | MROCK' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoZonaMineral_MROCK cCodigo,
		NULL nAu,
		NULL nAg,
		NULL nAs,
		NULL nHg,
		NULL nCu,
		NULL nPb,
		NULL nZn,
		NULL nS,
		NULL nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	from
		#TempGeneralParametros
	group by
		cCodigoZonaMineral_MROCK
	union all
	select
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'TIPO ROCA | GROCK' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoTipoRoca_GROCK cCodigo,
		NULL nAu,
		NULL nAg,
		NULL nAs,
		NULL nHg,
		NULL nCu,
		NULL nPb,
		NULL nZn,
		NULL nS,
		NULL nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	from
		#TempGeneralParametros
	group by
		cCodigoTipoRoca_GROCK
	union all
	select
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'TIPO ALTERACION | AROCK' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoTipoAlteracion_AROCK cCodigo,
		NULL nAu,
		NULL nAg,
		NULL nAs,
		NULL nHg,
		NULL nCu,
		NULL nPb,
		NULL nZn,
		NULL nS,
		NULL nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	from
		#TempGeneralParametros
	group by
		cCodigoTipoAlteracion_AROCK
	union all
	select
		@iTipoMovimiento iTipoMovimiento,
		@iCodigoDestinoCombo iCodigoDestino,
		'BLOQUE' cParametroGeologico,
		case when @TonelajeTotalNominal = 0 then null else sum(nToneladasFlat)*100.0 / @TonelajeTotalNominal end nPorcentual,
		cCodigoBloque cCodigo,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nAu) / sum(isnull(nToneladasFlat,0)) end nAu,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nAg) / sum(isnull(nToneladasFlat,0)) end nAg,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nAs) / sum(isnull(nToneladasFlat,0)) end nAs,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nHg) / sum(isnull(nToneladasFlat,0)) end nHg,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nCu) / sum(isnull(nToneladasFlat,0)) end nCu,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nPb) / sum(isnull(nToneladasFlat,0)) end nPb,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nZn) / sum(isnull(nToneladasFlat,0)) end nZn,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nS) / sum(isnull(nToneladasFlat,0)) end nS,
		case when sum(isnull(nToneladasFlat,0)) = 0 then NULL else sum(nToneladasFlat * nDensidad) / sum(isnull(nToneladasFlat,0)) end nDensidad,
		sum(nToneladasFlat) nTonelaje,
		count(1) nViajes
	from
		#TempGeneralParametros
	group by
		cCodigoBloque

	delete from CM_MOVIMIENTOS_DESTINO_STOCK_PARAMETROS where iTipoMovimiento = @iTipoMovimiento and iCodigoDestino = @iCodigoDestinoCombo
	
	insert into CM_MOVIMIENTOS_DESTINO_STOCK_PARAMETROS
	select 
		ROW_NUMBER() OVER(ORDER BY cParametroGeologico ASC, nPorcentual asc) AS Id,
		*
	from #tempParametrosStock
	

	--select * from CM_MOVIMIENTOS_DESTINO_STOCK_MOVIMIENTOS where iTipoMovimiento = @iTipoMovimiento and iCodigoDestinoCombo = @iCodigoDestinoCombo
end

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	set nocount on;
END CATCH
END
GO
