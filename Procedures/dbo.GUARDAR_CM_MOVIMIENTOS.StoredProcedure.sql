/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CM_MOVIMIENTOS]
@iTipo int,
@dFechaHora datetime,
@cObservaciones varchar(max),
@bAuto bit,

@nCueq float = null,
@nCut float = null,
@nCus float = null,
@nAu float = null,
@nAg float = null,
@nMo float = null,
@nAs float = null,
@nCo3 float = null,
@nNo3 float = null,
@nFet float = null,
@nPy_Aux float = null,
@nLeyc_Cut float = null,
@nLeyc_Au float = null,
@nRecg_Cu float = null,
@nRecg_Au float = null,
@nBwi float = null,
@nTph_Sag float = null,
@nCpy_Ajus float = null,
@nCccv_Ajus float = null,
@nBo_Ajus float = null,
@nAxb float = null,
@nVsed_E float = null,
@nCp_Pond float = null,
@nLey_Con_Rou float = null,
@nDominio float = null,
@nIns float = null,
@nHum float = null,
@nRec_Heap float = null,
@nRec_Rom float = null,
@nCan_Heap float = null,
@nCan_Rom float = null,
@nM100 float = null,
@nM400 float = null,

@cCodigoPala varchar(100),
@cCodigoFlotaPala varchar(100),
@cCodigoCamion varchar(100),
@cCodigoFlotaCamion varchar(100),
@nToneladas float,
@nToneladasFlat float,

@iCodigoOrigen int,
@nEastingOrigen float,
@nNorthingOrigen float,
@nElevationOrigen float,
@nLongitudOrigen float,
@nLatitudOrigen float,

@iCodigoDestino int,
@nEastingDestino float,
@nNorthingDestino float,
@nElevationDestino float,
@nLongitudDestino float,
@nLatitudDestino float

as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

	declare @dFechaRPT date = case	when datepart(hh,@dFechaHora) between 8 and 19 then convert(date,@dFechaHora) 
									when datepart(hh,@dFechaHora) between 0 and 7 then dateadd(dd,-1,convert(date,@dFechaHora))
									when datepart(hh,@dFechaHora) between 20 and 23 then convert(date,@dFechaHora) end

	insert into CM_MOVIMIENTOS_GENERAL(
		dFechaRPT,
		cTurno,
		dFechaHora,
		cObservaciones,
		bAuto,
		iTipo)
	values(
		@dFechaRPT,
		case	when datepart(hh,@dFechaHora) between 8 and 19 then 'A' else 'B' end,
		@dFechaHora,
		@cObservaciones,
		@bAuto,
		@iTipo)

	declare @iCodigo int= (Select Ident_Current('CM_MOVIMIENTOS_GENERAL'))

	insert into CM_MOVIMIENTOS_LEY(
		iCodigo,
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
		nHum,
		nRec_Heap,
		nRec_Rom,
		nCan_Heap,
		nCan_Rom,
		nM100,
		nM400)
	values(
		@iCodigo,
		case when @nCueq = 0 then NULL else @nCueq end,
		case when @nCut = 0 then NULL else @nCut end,
		case when @nCus = 0 then NULL else @nCus end,
		case when @nAu = 0 then NULL else @nAu end,
		case when @nAg = 0 then NULL else @nAg end,
		case when @nMo = 0 then NULL else @nMo end,
		case when @nAs = 0 then NULL else @nAs end,
		case when @nCo3 = 0 then NULL else @nCo3 end,
		case when @nNo3 = 0 then NULL else @nNo3 end,
		case when @nFet = 0 then NULL else @nFet end,
		case when @nPy_Aux = 0 then NULL else @nPy_Aux end,
		case when @nLeyc_Cut = 0 then NULL else @nLeyc_Cut end,
		case when @nLeyc_Au = 0 then NULL else @nLeyc_Au end,
		case when @nRecg_Cu = 0 then NULL else @nRecg_Cu end,
		case when @nRecg_Au = 0 then NULL else @nRecg_Au end,
		case when @nBwi = 0 then NULL else @nBwi end,
		case when @nTph_Sag = 0 then NULL else @nTph_Sag end,
		case when @nCpy_Ajus = 0 then NULL else @nCpy_Ajus end,
		case when @nCccv_Ajus = 0 then NULL else @nCccv_Ajus end,
		case when @nBo_Ajus = 0 then NULL else @nBo_Ajus end,
		case when @nAxb = 0 then NULL else @nAxb end,
		case when @nVsed_E = 0 then NULL else @nVsed_E end,
		case when @nCp_Pond = 0 then NULL else @nCp_Pond end,
		case when @nLey_Con_Rou = 0 then NULL else @nLey_Con_Rou end,
		case when @nDominio = 0 then NULL else @nDominio end,
		case when @nIns = 0 then NULL else @nIns end,
		case when @nHum = 0 then NULL else @nHum end,
		case when @nRec_Heap = 0 then NULL else @nRec_Heap end,
		case when @nRec_Rom = 0 then NULL else @nRec_Rom end,
		case when @nCan_Heap = 0 then NULL else @nCan_Heap end,
		case when @nCan_Rom = 0 then NULL else @nCan_Rom end,
		case when @nM100 = 0 then NULL else @nM100 end,
		case when @nM400 = 0 then NULL else @nM400 end)

	insert into CM_MOVIMIENTOS_EQUIPOS(
		iCodigo,
		cCodigoPala,
		cCodigoFlotaPala,
		cCodigoCamion,
		cCodigoFlotaCamion,
		nToneladas,
		nToneladasFlat)
	values(
		@iCodigo,
		@cCodigoPala,
		@cCodigoFlotaPala,
		@cCodigoCamion,
		@cCodigoFlotaCamion,
		@nToneladas,
		@nToneladasFlat)

	declare @bMezcla bit = case when (select count(1) from CM_UBICACIONES where cCodigoEstadistica = 'CHANCADO-SULFURO') > 1 then 1 else 0 end

	insert into CM_MOVIMIENTOS_UBICACIONES_ORIGEN(
		iCodigo,
		iCodigoOrigen,
		nEastingOrigen,
		nNorthingOrigen,
		nElevationOrigen,
		nLongitudOrigen,
		nLatitudOrigen,
		bMezcla,
		cTronada)
	values(
		@iCodigo,
		@iCodigoOrigen,
		case when @nEastingOrigen = 0 then NULL else @nEastingOrigen end,
		case when @nNorthingOrigen = 0 then NULL else @nNorthingOrigen end,
		case when @nElevationOrigen = 0 then NULL else @nElevationOrigen end,
		case when @nLongitudOrigen = 0 then NULL else @nLongitudOrigen end,
		case when @nLatitudOrigen = 0 then NULL else @nLatitudOrigen end,
		@bMezcla,
		'')

	insert into CM_MOVIMIENTOS_UBICACIONES_DESTINO(
		iCodigo,
		iCodigoDestino,
		nEastingDestino,
		nNorthingDestino,
		nElevationDestino,
		nLongitudDestino,
		nLatitudDestino)
	values(
		@iCodigo,
		@iCodigoDestino,
		case when @nEastingDestino = 0 then NULL else @nEastingDestino end,
		case when @nNorthingDestino = 0 then NULL else @nNorthingDestino end,
		case when @nElevationDestino = 0 then NULL else @nElevationDestino end,
		case when @nLongitudDestino = 0 then NULL else @nLongitudDestino end,
		case when @nLatitudDestino = 0 then NULL else @nLatitudDestino end)

	if @iTipo = 1
	begin

		declare @iCodigoUbicacionDefault int = (select top 1 iCodigo from CM_UBICACIONES with(nolock)  where cTipo = 'S' and cDescripcion = 'NA')

		declare @TableDestinos table(
			Id int identity(1,1),
			iCodigoDestino int,
			dFechaRPT date
		)
		insert into @TableDestinos
		select distinct st.iCodigo, st.dFechaRPT from (
		select 
			d.iCodigoDestino iCodigo,
			g.dFechaRPT
		from
			CM_MOVIMIENTOS_GENERAL g with(nolock) 
				inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d  with(nolock) on
					g.iCodigo = d.iCodigo
				inner join VIST_CM_UBICACIONES ud with(nolock) on
					d.iCodigoDestino = ud.iCodigo
		where
			g.dFechaRPT >= @dFechaRPT and
			g.iTipo = 1 and
			d.iCodigoDestino not in (@iCodigoUbicacionDefault, @iBalance) and
			ud.cTipo in ('S','D')
		union all
		select distinct
			d.iCodigoOrigen iCodigo,
			g.dFechaRPT
		from
			CM_MOVIMIENTOS_GENERAL g with(nolock) 
				inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN d  with(nolock) on
					g.iCodigo = d.iCodigo
				inner join VIST_CM_UBICACIONES ud  with(nolock) on
					d.iCodigoOrigen = ud.iCodigo
		where
			g.dFechaRPT >= @dFechaRPT and
			g.iTipo = 1 and
			d.iCodigoOrigen not in (@iCodigoUbicacionDefault, @iBalance) and
			ud.cTipo in ('S','D')
		) st
		order by
			st.dFechaRPT asc, st.iCodigo asc

		declare @iCodigoCursor int
		declare @dFechaRPTCursor date
		declare @iContadorCodigos int = 1
		declare @iContadorCodigosMaximo int = (select count(1) from @TableDestinos)

		while @iContadorCodigos < = @iContadorCodigosMaximo
		begin

			select 
				@iCodigoCursor = d.iCodigoDestino,
				@dFechaRPTCursor = d.dFechaRPT
			from @TableDestinos d where d.Id = @iContadorCodigos

			exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS_EXACTO @iCodigoCursor, @dFechaRPTCursor

			exec GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION_SULFUROS @iCodigoCursor,@dFechaRPTCursor

			set @iContadorCodigos = @iContadorCodigos + 1
		end
	end

--if @iTipo = 1
--begin
--	exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_SULFUROS @dFechaRPT
--	exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS @iCodigoDestino, @dFechaRPT
--	exec MODIFICAR_CM_MOVIMIENTOS_STOCK_CONDICION_POR_MOVIMIENTO_SULFUROS @iCodigo, @iCodigoDestino
--end
--else
--begin
--	exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_OXIDOS @dFechaRPT
--	exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS @iCodigoDestino, @dFechaRPT
--	exec MODIFICAR_CM_MOVIMIENTOS_STOCK_CONDICION_POR_MOVIMIENTO_OXIDOS @iCodigo, @iCodigoDestino
--end


	select 'MenSys_SaveOK', @iCodigo

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
