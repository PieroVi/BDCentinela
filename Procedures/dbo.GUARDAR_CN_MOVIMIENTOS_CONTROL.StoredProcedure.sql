/****** Object:  StoredProcedure [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CN_MOVIMIENTOS_CONTROL]
@iTipoMovimiento int,
@dFechaRPT date,
@cXMLRegistros xml,
@cXMLValidacion xml,
@iCodigoUsuario int
with recompile
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

begin --ALMACENAMOS AUDITORIA
	delete from CN_MOVIMIENTOS_IMPORTACION_REGISTROS
	where
		dFechaRPT = @dFechaRPT and
		iTipoMovimiento = @iTipoMovimiento

	delete from CN_MOVIMIENTOS_IMPORTACION_VALIDACION
	where
		dFechaRPT = @dFechaRPT and
		iTipoMovimiento = @iTipoMovimiento

	select
		nref.value('iTipoMovimiento[1]','int') iTipoMovimiento,
		nref.value('dFechaRPT[1]','date') dFechaRPT,
		nref.value('cTurno[1]','varchar(1)') cTurno,
		nref.value('dFechaHora[1]','datetime') dFechaHora,
		nref.value('cObservaciones[1]','varchar(max)') cObservaciones,
		nref.value('bAuto[1]','bit') bAuto,
		nref.value('cCodigoPala[1]','varchar(100)') cCodigoPala,
		nref.value('cCodigoFlotaPala[1]','varchar(100)') cCodigoFlotaPala,
		nref.value('cCodigoCamion[1]','varchar(100)') cCodigoCamion,
		nref.value('cCodigoFlotaCamion[1]','varchar(100)') cCodigoFlotaCamion,
		nref.value('nToneladas[1]','float') nToneladas,
		nref.value('nToneladasFlat[1]','float') nToneladasFlat,
		nref.value('cOrigen[1]','varchar(200)') cOrigen,
		nref.value('nEastingOrigen[1]','float') nEastingOrigen,
		nref.value('nNorthingOrigen[1]','float') nNorthingOrigen,
		nref.value('nElevationOrigen[1]','float') nElevationOrigen,
		nref.value('nLongitudOrigen[1]','float') nLongitudOrigen,
		nref.value('nLatitudOrigen[1]','float') nLatitudOrigen,
		nref.value('cDestino[1]','varchar(200)') cDestino,
		nref.value('nEastingDestino[1]','float') nEastingDestino,
		nref.value('nNorthingDestino[1]','float') nNorthingDestino,
		nref.value('nElevationDestino[1]','float') nElevationDestino,
		nref.value('nLongitudDestino[1]','float') nLongitudDestino,
		nref.value('nLatitudDestino[1]','float') nLatitudDestino,
		nref.value('cCodigoTipoRoca_GROCK[1]','varchar(100)') cCodigoTipoRoca_GROCK,
		nref.value('cCodigoTipoAlteracion_AROCK[1]','varchar(100)') cCodigoTipoAlteracion_AROCK,
		nref.value('cCodigoZonaMineral_MROCK[1]','varchar(100)') cCodigoZonaMineral_MROCK,
		nref.value('cCodigoDurezaRelativa_DUREZA[1]','varchar(100)') cCodigoDurezaRelativa_DUREZA,
		nref.value('cCodigoMaterial[1]','varchar(100)') cCodigoMaterial,
		nref.value('cCodigoBloque[1]','varchar(100)') cCodigoBloque,
		nref.value('nAu[1]','float') nAu,
		nref.value('nAg[1]','float') nAg,
		nref.value('nAs[1]','float') nAs,
		nref.value('nHg[1]','float') nHg,
		nref.value('nCu[1]','float') nCu,
		nref.value('nPb[1]','float') nPb,
		nref.value('nZn[1]','float') nZn,
		nref.value('nS[1]','float') nS,
		nref.value('nDensidad[1]','float') nDensidad
	into #TempRegistros
	from @cXMLRegistros.nodes('/NewDataSet/Table') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLRegistros = NULL))

	insert into CN_MOVIMIENTOS_IMPORTACION_REGISTROS(
		Id,
		iTipoMovimiento,
		dFechaRPT,
		cTurno,
		dFechaHora,
		cObservaciones,
		bAuto,
		cCodigoPala,
		cCodigoFlotaPala,
		cCodigoCamion,
		cCodigoFlotaCamion,
		nToneladas,
		nToneladasFlat,
		cOrigen,
		nEastingOrigen,
		nNorthingOrigen,
		nElevationOrigen,
		nLongitudOrigen,
		nLatitudOrigen,
		cDestino,
		nEastingDestino,
		nNorthingDestino,
		nElevationDestino,
		nLongitudDestino,
		nLatitudDestino,
		cCodigoTipoRoca_GROCK,
		cCodigoTipoAlteracion_AROCK,
		cCodigoZonaMineral_MROCK,
		cCodigoDurezaRelativa_DUREZA,
		cCodigoMaterial,
		cCodigoBloque,
		nAu,
		nAg,
		nAs,
		nHg,
		nCu,
		nPb,
		nZn,
		nS,
		nDensidad	
	)
	select
		ROW_NUMBER() OVER(ORDER BY dFechaHora, cOrigen ASC) AS Id,
		*
	from
		#TempRegistros

	insert into CN_MOVIMIENTOS_IMPORTACION_VALIDACION
	select
		@dFechaRPT,
		@iTipoMovimiento,
		nref.value('iOrdenProceso[1]','int'),
		nref.value('iOrdenTipo[1]','int'),
		nref.value('cProceso[1]','varchar(100)'),
		nref.value('cTipo[1]','varchar(100)'),
		nref.value('cFuente[1]','varchar(200)'),
		nref.value('cSCM[1]','varchar(200)')
	from @cXMLValidacion.nodes('/NewDataSet/Table1') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLValidacion = NULL))

	declare @cObservacionesUbicaciones varchar(max) = case when (select count(1) from CN_MOVIMIENTOS_IMPORTACION_VALIDACION with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and iOrdenProceso = 1 and cSCM is null) > 0 then 'Ubicaciones no encontradas' else '' end
	declare @cObservacionesParametros varchar(max) = case when (select count(1) from CN_MOVIMIENTOS_IMPORTACION_VALIDACION with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and iOrdenProceso = 2 and cSCM is null) > 0 then 'Parámetros geológicos no encontradas' else '' end
	declare @cObservacion varchar(max) = case when @cObservacionesUbicaciones = '' and @cObservacionesParametros = '' then 'OK' else rtrim(ltrim(@cObservacionesUbicaciones +' '+@cObservacionesParametros)) end

end

begin --ALMACENAMOS TABLA SCM
	DELETE CM_MOVIMIENTOS_LEYES
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	DELETE CM_MOVIMIENTOS_EQUIPOS
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	DELETE CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	DELETE CM_MOVIMIENTOS_UBICACIONES_ORIGEN
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	DELETE CM_MOVIMIENTOS_UBICACIONES_DESTINO
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	DELETE CM_MOVIMIENTOS_GENERAL
	WHERE 
		iCodigo in (select iCodigo from CM_MOVIMIENTOS_GENERAL with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)

	declare @ContadorRegistros int = 0
	declare @ContadorTotal int = (select count(1) from CN_MOVIMIENTOS_IMPORTACION_REGISTROS with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento)
	declare @iCodigo int

	declare @iCodigoTipoRocaDefault int = (select top 1 iCodigo from CM_PARAMETROS_GEOLOGICOS with(nolock)  where iTipo = 1 and cCodigoEstadistica = '99999')
	declare @iCodigoAlteracionDefault int = (select top 1 iCodigo from CM_PARAMETROS_GEOLOGICOS with(nolock)  where iTipo = 2 and cCodigoEstadistica = '99999')
	declare @iCodigoZonaMineralDefault int = (select top 1 iCodigo from CM_PARAMETROS_GEOLOGICOS with(nolock)  where iTipo = 3 and cCodigoEstadistica = '99999')
	declare @iCodigoDurezaDefault int = (select top 1 iCodigo from CM_PARAMETROS_GEOLOGICOS with(nolock)  where iTipo = 4 and cCodigoEstadistica = '99999')
	declare @iCodigoMaterialDefault int = (select top 1 iCodigo from CM_PARAMETROS_GEOLOGICOS with(nolock)  where iTipo = 5 and cCodigoEstadistica = 'NA')

	declare @iCodigoUbicacionDefault int = (select top 1 iCodigo from CM_UBICACIONES with(nolock)  where cTipo = 'S' and cDescripcion = 'NA')

	while @ContadorRegistros < = @ContadorTotal
	begin

		insert into CM_MOVIMIENTOS_GENERAL(
			iTipoMovimiento,
			dFechaRPT,
			cTurno,
			dFechaHora,
			cObservaciones,
			bAuto)
		select 
			iTipoMovimiento,
			dFechaRPT,
			cTurno,
			dFechaHora,
			cObservaciones,
			bAuto
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS with(nolock)  where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros
		
		set @iCodigo = (Select Ident_Current('CM_MOVIMIENTOS_GENERAL'))

		insert into CM_MOVIMIENTOS_LEYES(
			iCodigo,
			nAu,
			nAg,
			nAs,
			nHg,
			nCu,
			nPb,
			nZn,
			nS,
			nDensidad)
		select
			@iCodigo,
			case when nAu = 0 then NULL else nAu end,
			case when nAg = 0 then NULL else nAg end,
			case when nAs = 0 then NULL else nAs end,
			case when nHg = 0 then NULL else nHg end,
			case when nCu = 0 then NULL else nCu end,
			case when nPb = 0 then NULL else nPb end,
			case when nZn = 0 then NULL else nZn end,
			case when nS = 0 then NULL else nS end,
			case when nDensidad = 0 then NULL else nDensidad end
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros

		insert into CM_MOVIMIENTOS_EQUIPOS(
			iCodigo,
			cCodigoPala,
			cCodigoFlotaPala,
			cCodigoCamion,
			cCodigoFlotaCamion,
			nToneladas,
			nToneladasFlat)
		select
			@iCodigo,
			cCodigoPala,
			cCodigoFlotaPala,
			cCodigoCamion,
			cCodigoFlotaCamion,
			nToneladas,
			nToneladasFlat
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros

		insert into CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS(
			iCodigo,
			iCodigoTipoRoca_GROCK,
			iCodigoTipoAlteracion_AROCK,
			iCodigoZonaMineral_MROCK,
			iCodigoDurezaRelativa_DUREZA,
			iCodigoMaterial,
			cCodigoBloque)
		select
			@iCodigo,
			isnull((select pg.iCodigo from CM_PARAMETROS_GEOLOGICOS pg  with(nolock) where iTipo = 1 and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = convert(varchar(5),convert(int,floor(convert(float,cCodigoTipoRoca_GROCK))))),@iCodigoTipoRocaDefault),
			isnull((select pg.iCodigo from CM_PARAMETROS_GEOLOGICOS pg  with(nolock) where iTipo = 2 and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = convert(varchar(5),convert(int,floor(convert(float,cCodigoTipoAlteracion_AROCK))))),@iCodigoAlteracionDefault),
			isnull((select pg.iCodigo from CM_PARAMETROS_GEOLOGICOS pg  with(nolock) where iTipo = 3 and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = convert(varchar(5),case	when convert(float,cCodigoZonaMineral_MROCK) >= 0 and convert(float,cCodigoZonaMineral_MROCK) <= 2 then 2
																																																			when convert(float,cCodigoZonaMineral_MROCK) > 2 and convert(float,cCodigoZonaMineral_MROCK) <= 4 then 4 end)),@iCodigoZonaMineralDefault),
			isnull((select pg.iCodigo from CM_PARAMETROS_GEOLOGICOS pg  with(nolock) where iTipo = 4 and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = convert(varchar(5),convert(int,floor(convert(float,cCodigoDurezaRelativa_DUREZA))))),@iCodigoDurezaDefault),
			isnull((select pg.iCodigo from CM_PARAMETROS_GEOLOGICOS pg  with(nolock) where iTipo = 5 and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = cCodigoMaterial),@iCodigoMaterialDefault),
			cCodigoBloque
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS  with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros

		insert into CM_MOVIMIENTOS_UBICACIONES_ORIGEN(
			iCodigo,
			iCodigoOrigen,
			nEastingOrigen,
			nNorthingOrigen,
			nElevationOrigen,
			nLongitudOrigen,
			nLatitudOrigen)
		select 
			@iCodigo,
			isnull((select pg.iCodigo from CM_UBICACIONES pg  with(nolock) where cTipo in ('O','S') and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = cOrigen),@iCodigoUbicacionDefault),
			case when nEastingOrigen = 0 then NULL else nEastingOrigen end,
			case when nNorthingOrigen = 0 then NULL else nNorthingOrigen end,
			case when nElevationOrigen = 0 then NULL else nElevationOrigen end,
			case when nLongitudOrigen = 0 then NULL else nLongitudOrigen end,
			case when nLatitudOrigen = 0 then NULL else nLatitudOrigen end
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS  with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros

		insert into CM_MOVIMIENTOS_UBICACIONES_DESTINO(
			iCodigo,
			iCodigoDestino,
			nEastingDestino,
			nNorthingDestino,
			nElevationDestino,
			nLongitudDestino,
			nLatitudDestino)
		select
			@iCodigo,
			isnull((select pg.iCodigo from CM_UBICACIONES pg  with(nolock) where cTipo in ('D','S') and case when @iTipoMovimiento = 1 then pg.cCodigoEstadistica else pg.cCodigoFisica end = cDestino),@iCodigoUbicacionDefault),
			case when nEastingDestino = 0 then NULL else nEastingDestino end,
			case when nNorthingDestino = 0 then NULL else nNorthingDestino end,
			case when nElevationDestino = 0 then NULL else nElevationDestino end,
			case when nLongitudDestino = 0 then NULL else nLongitudDestino end,
			case when nLatitudDestino = 0 then NULL else nLatitudDestino end
		from
			CN_MOVIMIENTOS_IMPORTACION_REGISTROS  with(nolock) where dFechaRPT = @dFechaRPT and iTipoMovimiento = @iTipoMovimiento and Id = @ContadorRegistros

		set @ContadorRegistros = @ContadorRegistros + 1
	end
end

exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS @iTipoMovimiento, @dFechaRPT

declare @TableDestinos table(
	Id int identity(1,1),
	iCodigoDestino int,
	cCondicion varchar(500)
)

insert into @TableDestinos
select distinct
	d.iCodigoDestino,
	rtrim(ltrim(isnull(u.cCondicion,'')))
from
	CM_MOVIMIENTOS_GENERAL g with(nolock) 
		inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d  with(nolock) on
			g.iCodigo = d.iCodigo
		inner join CM_UBICACIONES u  with(nolock) on
			d.iCodigoDestino = u.iCodigo
where
	g.iTipoMovimiento = @iTipoMovimiento and
	g.dFechaRPT = @dFechaRPT

declare @ContadorDestino int = 1
declare @iCodigoDestino int
declare @cCondicion varchar(500)

declare @dFechaInicioCondicion datetime = dateadd(HH,7,convert(datetime,@dFechaRPT))
declare @dFechaFinCondicion datetime = dateadd(SS,-1,dateadd(HH,24,@dFechaInicioCondicion))

while @ContadorDestino <= (select count(1) from @TableDestinos)
begin
	select @iCodigoDestino = iCodigoDestino, @cCondicion = cCondicion from @TableDestinos where Id = @ContadorDestino

	exec GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL @iTipoMovimiento, @iCodigoDestino

	if @iCodigoDestino <> ''
	begin
		exec GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION @iTipoMovimiento, @iCodigoDestino,@dFechaInicioCondicion, @dFechaFinCondicion
	end

	set @ContadorDestino = @ContadorDestino + 1
end

insert into CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES
values(@iTipoMovimiento, @dFechaRPT, getdate(), @iCodigoUsuario, @cObservacion)

select 'MenSys_SaveOK', @cObservacion



COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	insert into CN_MOVIMIENTOS_IMPORTACION_OBSERVACIONES
	values(@iTipoMovimiento, @dFechaRPT, getdate(), @iCodigoUsuario, 'MenSys_ErrorSQL: ' + ERROR_MESSAGE())

	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
