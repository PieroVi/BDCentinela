/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_BALANCE]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_CM_MOVIMIENTOS_BALANCE]
@iCodigo int,
@iTipo int,
@dFechaRPT date,
@cObservaciones varchar(max),

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

@nToneladas float,
@nToneladasFlat float,

@iCodigoDestino int

as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	update CM_MOVIMIENTOS_GENERAL set
		cObservaciones = @cObservaciones
	where
		iCodigo = @iCodigo

	update CM_MOVIMIENTOS_LEY set 
		nCueq = case when @nCueq = 0 then NULL else @nCueq end,
		nCut = case when @nCut = 0 then NULL else @nCut end,
		nCus = case when @nCus = 0 then NULL else @nCus end,
		nAu = case when @nAu = 0 then NULL else @nAu end,
		nAg = case when @nAg = 0 then NULL else @nAg end,
		nMo = case when @nMo = 0 then NULL else @nMo end,
		nAs = case when @nAs = 0 then NULL else @nAs end,
		nCo3 = case when @nCo3 = 0 then NULL else @nCo3 end,
		nNo3 = case when @nNo3 = 0 then NULL else @nNo3 end,
		nFet = case when @nFet = 0 then NULL else @nFet end,
		nPy_Aux = case when @nPy_Aux = 0 then NULL else @nPy_Aux end,
		nLeyc_Cut = case when @nLeyc_Cut = 0 then NULL else @nLeyc_Cut end,
		nLeyc_Au = case when @nLeyc_Au = 0 then NULL else @nLeyc_Au end,
		nRecg_Cu = case when @nRecg_Cu = 0 then NULL else @nRecg_Cu end,
		nRecg_Au = case when @nRecg_Au = 0 then NULL else @nRecg_Au end,
		nBwi = case when @nBwi = 0 then NULL else @nBwi end,
		nTph_Sag = case when @nTph_Sag = 0 then NULL else @nTph_Sag end,
		nCpy_Ajus = case when @nCpy_Ajus = 0 then NULL else @nCpy_Ajus end,
		nCccv_Ajus = case when @nCccv_Ajus = 0 then NULL else @nCccv_Ajus end,
		nBo_Ajus = case when @nBo_Ajus = 0 then NULL else @nBo_Ajus end,
		nAxb = case when @nAxb = 0 then NULL else @nAxb end,
		nVsed_E = case when @nVsed_E = 0 then NULL else @nVsed_E end,
		nCp_Pond = case when @nCp_Pond = 0 then NULL else @nCp_Pond end,
		nLey_Con_Rou = case when @nLey_Con_Rou = 0 then NULL else @nLey_Con_Rou end,
		nDominio = case when @nDominio = 0 then NULL else @nDominio end,
		nIns = case when @nIns = 0 then NULL else @nIns end,
		nHum = case when @nHum = 0 then NULL else @nHum end,
		nRec_Heap = case when @nRec_Heap = 0 then NULL else @nRec_Heap end,
		nRec_Rom = case when @nRec_Rom = 0 then NULL else @nRec_Rom end,
		nCan_Heap = case when @nCan_Heap = 0 then NULL else @nCan_Heap end,
		nCan_Rom = case when @nCan_Rom = 0 then NULL else @nCan_Rom end,
		nM100 = case when @nM100 = 0 then NULL else @nM100 end,
		nM400 = case when @nM400 = 0 then NULL else @nM400 end
	where	
		iCodigo = @iCodigo

	update CM_MOVIMIENTOS_EQUIPOS set
		nToneladas = @nToneladas,
		nToneladasFlat = @nToneladasFlat
	where 
		iCodigo = @iCodigo


	declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')
	declare @iCodigoUbicacionDefault int = (select top 1 iCodigo from CM_UBICACIONES with(nolock)  where cTipo = 'S' and cDescripcion = 'NA')
	declare @TableDestinos table(
		Id int identity(1,1),
		iCodigoDestino int,
		dFechaRPT date
	)

	declare @iCodigoCursor int
	declare @dFechaRPTCursor date
	declare @iContadorCodigos int = 1
	declare @iContadorCodigosMaximo int
	
	if @iTipo = 1
	begin


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

		set @iContadorCodigosMaximo = (select count(1) from @TableDestinos)

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
	else
	begin

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
			g.iTipo = 2 and
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
			g.iTipo = 2 and
			d.iCodigoOrigen not in (@iCodigoUbicacionDefault, @iBalance) and
			ud.cTipo in ('S','D')
		) st
		order by
			st.dFechaRPT asc, st.iCodigo asc

		set @iContadorCodigosMaximo = (select count(1) from @TableDestinos)

		while @iContadorCodigos < = @iContadorCodigosMaximo
		begin

			select 
				@iCodigoCursor = d.iCodigoDestino,
				@dFechaRPTCursor = d.dFechaRPT
			from @TableDestinos d where d.Id = @iContadorCodigos

			exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_OXIDOS_EXACTO @iCodigoCursor, @dFechaRPTCursor

			exec GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION_OXIDOS @iCodigoCursor,@dFechaRPTCursor

			set @iContadorCodigos = @iContadorCodigos + 1
		end
	end

	select 'MenSys_EditOK', 1

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END


GO
