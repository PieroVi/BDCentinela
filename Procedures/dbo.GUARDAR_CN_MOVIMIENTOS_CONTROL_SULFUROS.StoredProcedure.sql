/****** Object:  StoredProcedure [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL_SULFUROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL_SULFUROS] -- '2023-05-10',1
@dFechaRPT date,
@iCodigoUsuario int
with recompile
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

begin --SACAMOS VALIDACIONES
	select
		ROW_NUMBER() OVER(ORDER BY m.dFechaHoraEmpty ASC) AS nOrden,
		*
		into #MovimientosImportados
	from
		CM_IMPORTACION_SULFUROS_MOVIMIENTOS m with(nolock)
	where
		m.dFecha = @dFechaRPT
	ORDER BY 
		m.dFechaHoraEmpty ASC

	declare @Leyes table(
		dFecha	date,
		cRegion	varchar(1000),
		cRajo varchar(20),
		cOrigen varchar(500),
		cSCM varchar(500),
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
		nIns float
	)

	insert into @Leyes
	exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_LEYES_AGRUPADAS @dFechaRPT

	declare @Movimientos table(
		cUbicacion varchar(1000),
		cSCM varchar(1000),
		cTipo varchar(100)
	)

	insert into @Movimientos
	exec MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_MOVIMIENTOS_AGRUPADAS @dFechaRPT

	select 
		m.cUbicacion,
		m.cSCM,
		m.cTipo,
		case	when m.cTipo = 'Origen' then
					case	
							when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 'S' then 'NA'
							when (select p.bEstado from CM_UBICACIONES u inner join PARAMETROS p on u.iCalidadMineral = p.iCodigoParametro and u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 0 then 'NA' 
							when (select u.cTipo from CM_UBICACIONES u where u.cCodigoEstadistica = m.cSCM and iTipoMineral = 1) = 'O' then 'SI'
							when l.cSCM is null then '-' end 
				else '' end cJigSaw_Vulkan
		into #Cruce
	from @Movimientos m
		left join @Leyes l on
			m.cSCM = l.cSCM
end

begin --ALMACENAMOS AUDITORIA

	declare @cObservacionesUbicacionesLeyes varchar(max) = case when (select count(1) from @Leyes where cSCM is null) > 0 then 'Leyes = "Ubicaciones no encontradas"' else '' end
	declare @cObservacionesUbicacionesMovimientos varchar(max) = case when (select count(1) from @Movimientos where cSCM is null) > 0 then 'Movimientos = "Ubicaciones no encontradas"' else '' end
	declare @cObservacionesUbicacionesCruce varchar(max) = case when (select count(1) from #Cruce where cTipo = 'Origen' and cJigSaw_Vulkan not in ('SI','NA') ) > 0 then 'Cruce = "Leyes Faltantes"' else '' end

	declare @cObservacion varchar(max) = case	when	@cObservacionesUbicacionesLeyes = '' and 
														@cObservacionesUbicacionesMovimientos = '' and
														@cObservacionesUbicacionesCruce = ''
														then 'OK' 
												else 
													rtrim(ltrim(@cObservacionesUbicacionesLeyes +'  '+ @cObservacionesUbicacionesMovimientos +'  '+ @cObservacionesUbicacionesCruce)) end
end

begin --LIMPIAMOS
	DELETE CM_MOVIMIENTOS_LEY
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock) where dFechaRPT = @dFechaRPT and iTipo = 1)

	DELETE CM_MOVIMIENTOS_EQUIPOS
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipo = 1)

	DELETE CM_MOVIMIENTOS_UBICACIONES_ORIGEN
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipo = 1)

	DELETE CM_MOVIMIENTOS_UBICACIONES_DESTINO
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipo = 1)

	DELETE CM_MOVIMIENTOS_GENERAL
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipo = 1)
end

begin --ALMACENAMOS TABLA SCM

	declare @iCodigoUbicacionDefault int = (select top 1 iCodigo from CM_UBICACIONES with(nolock)  where cTipo = 'S' and cDescripcion = 'NA' and iTipoMineral = 3)

	insert into CM_MOVIMIENTOS_GENERAL(
		dFechaRPT,
		cTurno,
		dFechaHora,
		cObservaciones,
		bAuto,
		iTipo)
	select 
		dFecha,
		cTurno,
		dFechaHoraEmpty,
		'',
		1,
		1
	from
		#MovimientosImportados with(nolock)  
	where 
		dFecha = @dFechaRPT

	select
		ROW_NUMBER() OVER(ORDER BY m.dFechaHora ASC) AS nOrden,
		m.iCodigo
	into #MovimientosInsertados
	from
		CM_MOVIMIENTOS_GENERAL m with(nolock)
	where 
		dFechaRPT = @dFechaRPT and
		iTipo = 1

	--LEYES = ENCONTRADAS
	if exists(	select 1 from #MovimientosImportados m with(nolock) left join #Cruce c on m.cOrigen = c.cUbicacion left join @Leyes l on m.cOrigen = l.cOrigen
				where c.cJigSaw_Vulkan = 'SI')
	begin
		insert into CM_MOVIMIENTOS_LEY
		select
			n.iCodigo,
			l.nCueq,
			l.nCut,
			l.nCus,
			l.nAu,
			l.nAg,
			l.nMo,
			l.nAs,
			l.nCo3,
			l.nNo3,
			l.nFet,
			l.nPy_Aux,
			l.nLeyc_Cut,
			l.nLeyc_Au,
			l.nRecg_Cu,
			l.nRecg_Au,
			l.nBwi,
			l.nTph_Sag,
			l.nCpy_Ajus,
			l.nCccv_Ajus,
			l.nBo_Ajus,
			l.nAxb,
			l.nVsed_E,
			l.nCp_Pond,
			l.nLey_Con_Rou,
			l.nDominio,
			l.nIns,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL				
		from
			#MovimientosImportados m with(nolock)  	
				inner join #MovimientosInsertados n on
					m.nOrden = n.nOrden
				left join #Cruce c on
					m.cOrigen = c.cUbicacion
				left join @Leyes l on
					m.cOrigen = l.cOrigen
		where
			c.cJigSaw_Vulkan = 'SI'
	end

	--LEYES = STOCKS
	if exists(	select 1 from #MovimientosImportados m with(nolock) left join #Cruce c on m.cOrigen = c.cUbicacion left join @Leyes l on m.cOrigen = l.cOrigen
				where c.cJigSaw_Vulkan = 'NA' and c.cSCM in (select cCodigoEstadistica from CM_UBICACIONES where cTipo = 'S' and iTipoMineral = 1))
	begin

		select distinct
			u.iCodigo
		into #UbicacionesStocks
		from
			#MovimientosImportados m with(nolock)
				inner join #MovimientosInsertados n on
					m.nOrden = n.nOrden
				left join #Cruce c on
					m.cOrigen = c.cUbicacion
				left join CM_UBICACIONES u with(nolock) on
					c.cSCM = u.cCodigoEstadistica and
					u.iTipoMineral = 1

		where
			c.cJigSaw_Vulkan = 'NA' and 
			c.cSCM in (select cCodigoEstadistica from CM_UBICACIONES where cTipo = 'S' and u.iTipoMineral = 1)

		select
			s.iCodigo,
			(select top 1 st.iOrdenDesc from CM_MOVIMIENTOS_LEY_STOCK st where st.iCodigoDestinoStock = s.iCodigo and st.dFechaRPT < @dFechaRPT and st.iOrdenDesc = 1 order by st.dFechaRPT desc, st.iOrdenDesc asc) iOrdenDesc,
			(select top 1 st.dFechaRPT from CM_MOVIMIENTOS_LEY_STOCK st where st.iCodigoDestinoStock = s.iCodigo and st.dFechaRPT < @dFechaRPT and st.iOrdenDesc = 1 order by st.dFechaRPT desc, st.iOrdenDesc asc) dFechaRPT
		into #UbicacionesStocksFechas
		from
			#UbicacionesStocks s

		insert into CM_MOVIMIENTOS_LEY
		select
			n.iCodigo,
			ls.nCueqStock,
			ls.nCutStock,
			ls.nCusStock,
			ls.nAuStock,
			ls.nAgStock,
			ls.nMoStock,
			ls.nAsStock,
			ls.nCo3Stock,
			ls.nNo3Stock,
			ls.nFetStock,
			ls.nPy_AuxStock,
			ls.nLeyc_CutStock,
			ls.nLeyc_AuStock,
			ls.nRecg_CuStock,
			ls.nRecg_AuStock,
			ls.nBwiStock,
			ls.nTph_SagStock,
			ls.nCpy_AjusStock,
			ls.nCccv_AjusStock,
			ls.nBo_AjusStock,
			ls.nAxbStock,
			ls.nVsed_EStock,
			ls.nCp_PondStock,
			ls.nLey_Con_RouStock,
			ls.nDominioStock,
			ls.nInsStock,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		from
			#MovimientosImportados m with(nolock)
				inner join #MovimientosInsertados n on
					m.nOrden = n.nOrden
				left join #Cruce c on
					m.cOrigen = c.cUbicacion
				left join CM_UBICACIONES u with(nolock) on
					c.cSCM = u.cCodigoEstadistica and
					u.iTipoMineral = 1
				left join #UbicacionesStocksFechas uf on
					u.iCodigo = uf.iCodigo
				left join (select ls1.* from #UbicacionesStocksFechas sf inner join CM_MOVIMIENTOS_LEY_STOCK ls1 with(nolock) on sf.iOrdenDesc = ls1.iOrdenDesc and sf.dFechaRPT = ls1.dFechaRPT and sf.iCodigo = ls1.iCodigoDestinoStock) ls on
					uf.iCodigo = ls.iCodigoDestinoStock

		where
			c.cJigSaw_Vulkan = 'NA' and 
			c.cSCM in (select cCodigoEstadistica from CM_UBICACIONES where cTipo = 'S' and u.iTipoMineral = 1)

	end
	
	--LEYES = UBICACIONES SIN LEYES
	if exists(	select 1 from #MovimientosImportados m with(nolock) left join #Cruce c on m.cOrigen = c.cUbicacion left join @Leyes l on m.cOrigen = l.cOrigen
				where c.cJigSaw_Vulkan = 'NA' and c.cSCM not in (select cCodigoEstadistica from CM_UBICACIONES where cTipo = 'S' and iTipoMineral = 1))
	begin
		insert into CM_MOVIMIENTOS_LEY
		select
			n.iCodigo,
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
			NULL				
		from
			#MovimientosImportados m with(nolock)  	
				inner join #MovimientosInsertados n on
					m.nOrden = n.nOrden
				left join #Cruce c on
					m.cOrigen = c.cUbicacion
				left join @Leyes l on
					m.cOrigen = l.cOrigen
		where
			c.cJigSaw_Vulkan = 'NA' and 
			c.cSCM not in (select cCodigoEstadistica from CM_UBICACIONES where cTipo = 'S' and iTipoMineral = 1)
	end

	--LEYES = SIN UBICACIONES
	if exists(	select 1 from #MovimientosImportados m with(nolock) left join #Cruce c on m.cOrigen = c.cUbicacion left join @Leyes l on m.cOrigen = l.cOrigen
				where c.cJigSaw_Vulkan = '-')
	begin
		insert into CM_MOVIMIENTOS_LEY
		select
			n.iCodigo,
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
			NULL				
		from
			#MovimientosImportados m with(nolock)  
				inner join #MovimientosInsertados n on
					m.nOrden = n.nOrden
				left join #Cruce c on
					m.cOrigen = c.cUbicacion
				left join @Leyes l on
					m.cOrigen = l.cOrigen
		where
			c.cJigSaw_Vulkan = '-'
	end

	--INSERTAMOS CAMIONES / PALAS / TONELAJES
	insert into CM_MOVIMIENTOS_EQUIPOS(
		iCodigo,
		cCodigoPala,
		cCodigoFlotaPala,
		cCodigoCamion,
		cCodigoFlotaCamion,
		nToneladas,
		nToneladasFlat)
	select
		n.iCodigo,
		m.cPala,
		m.cPala,
		m.cCamion,
		m.cCamion,
		m.nTonelaje,
		m.nTonelaje
	from
		#MovimientosImportados m
			inner join #MovimientosInsertados n on
				m.nOrden = n.nOrden

	--INSERTAMOS ORIGEN
	--select
	--	n.iCodigo,
	--	isnull(u.iCodigo,@iCodigoUbicacionDefault),
	--	0,
	--	0,
	--	0,
	--	0,
	--	0,
	--	m.bMezcla,
	--	m.cTronada
	--from
	--	#MovimientosImportados m  
	--		inner join #MovimientosInsertados n on
	--			m.nOrden = n.nOrden
	--		left join #Cruce c on
	--			m.cOrigen = c.cUbicacion
	--		left join CM_UBICACIONES u with(nolock) on
	--			rtrim(ltrim(c.cSCM)) = rtrim(ltrim(u.cCodigoEstadistica))

	insert into CM_MOVIMIENTOS_UBICACIONES_ORIGEN
	select
		n.iCodigo,
		isnull(u.iCodigo,@iCodigoUbicacionDefault),
		0,
		0,
		0,
		0,
		0,
		m.bMezcla,
		m.cTronada
	from
		#MovimientosImportados m  
			inner join #MovimientosInsertados n on
				m.nOrden = n.nOrden
			left join #Cruce c on
				m.cOrigen = c.cUbicacion
			left join CM_UBICACIONES u with(nolock) on
				rtrim(ltrim(c.cSCM)) = rtrim(ltrim(u.cCodigoEstadistica))

	insert into CM_MOVIMIENTOS_UBICACIONES_DESTINO(
		iCodigo,
		iCodigoDestino,
		nEastingDestino,
		nNorthingDestino,
		nElevationDestino,
		nLongitudDestino,
		nLatitudDestino)
	select
		n.iCodigo,
		isnull(u.iCodigo,@iCodigoUbicacionDefault),
		0,
		0,
		0,
		0,
		0
	from
		#MovimientosImportados m  
			inner join #MovimientosInsertados n on
				m.nOrden = n.nOrden
			left join CM_UBICACIONES u with(nolock) on
				rtrim(ltrim(m.cDestino)) = rtrim(ltrim(u.cCodigoEstadistica))
end

exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_SULFUROS @dFechaRPT

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE' and iTipoMineral = 3)

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
			d.iCodigoDestino = ud.iCodigo and
			ud.iTipoMineral = 1
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
			d.iCodigoOrigen = ud.iCodigo and
			ud.iTipoMineral = 1
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

--select * from @TableDestinos





--declare @TableDestinos table(
--	Id int identity(1,1),
--	iCodigoDestino int,
--	cCondicion varchar(500)
--)

--insert into @TableDestinos
--select distinct
--	d.iCodigoDestino,
--	rtrim(ltrim(isnull(u.cCondicion,'')))
--from
--	CM_MOVIMIENTOS_GENERAL g with(nolock) 
--		inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d  with(nolock) on
--			g.iCodigo = d.iCodigo
--		inner join CM_UBICACIONES u  with(nolock) on
--			d.iCodigoDestino = u.iCodigo
--where
--	g.dFechaRPT = @dFechaRPT and
--	g.iTipo = 1 and
--	d.iCodigoDestino <> @iCodigoUbicacionDefault

--declare @ContadorDestino int = 1
--declare @iCodigoDestino int
--declare @cCondicion varchar(500)

--declare @dFechaInicioCondicion datetime = dateadd(HH,7,convert(datetime,@dFechaRPT))
--declare @dFechaFinCondicion datetime = dateadd(SS,-1,dateadd(HH,24,@dFechaInicioCondicion))

--while @ContadorDestino <= (select count(1) from @TableDestinos)
--begin
--	select @iCodigoDestino = iCodigoDestino, @cCondicion = cCondicion from @TableDestinos where Id = @ContadorDestino

--	exec GUARDAR_CM_MOVIMIENTOS_STOCK_FECHA_SULFUROS @iCodigoDestino,@dFechaRPT

--	if @iCodigoDestino <> ''
--	begin
--		exec GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION_SULFUROS @iCodigoDestino,@dFechaRPT
--	end

--	set @ContadorDestino = @ContadorDestino + 1
--end

insert into CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES
values(@dFechaRPT, 1, getdate(), @iCodigoUsuario, @cObservacion)

select 'MenSys_SaveOK', @cObservacion



COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	insert into CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES
	values(@dFechaRPT, 1, getdate(), @iCodigoUsuario, 'MenSys_ErrorSQL: ' + ERROR_MESSAGE())

	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
