/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_CON_BALANCE]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_CM_MOVIMIENTOS_CON_BALANCE]
@iTipoMovimiento int,
@dFechaHora datetime,
@cObservaciones varchar(max),
@bAuto bit,

@nAu float = null,
@nAg float = null,
@nAs float = null,
@nHg float = null,
@nCu float = null,
@nPb float = null,
@nZn float = null,
@nS float = null,
@nDensidad float = null,

@nToneladas float,
@nToneladasFlat float,

@iCodigoDestino int,

@iTipoBalance int

as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @dFechaRPT date = case	when datepart(hh,@dFechaHora) between 8 and 19 then convert(date,@dFechaHora) 
									when datepart(hh,@dFechaHora) between 0 and 7 then dateadd(dd,-1,convert(date,@dFechaHora))
									when datepart(hh,@dFechaHora) between 20 and 23 then convert(date,@dFechaHora) end

	declare @nAu_Stock float
	declare @nAg_Stock float
	declare @nAs_Stock float
	declare @nHg_Stock float
	declare @nCu_Stock float
	declare @nPb_Stock float
	declare @nZn_Stock float
	declare @nS_Stock float
	declare @nDensidad_Stock float
	declare @nToneladas_Stock float
	declare @nToneladasFlat_Stock float

	select 
		@nAu_Stock = nAu,
		@nAg_Stock = nAg,
		@nAs_Stock = nAs,
		@nHg_Stock = nHg,
		@nCu_Stock = nCu,
		@nPb_Stock = nPb,
		@nZn_Stock = nZn,
		@nS_Stock = nS,
		@nDensidad_Stock = nDensidad,
		@nToneladas_Stock = nToneladas,
		@nToneladasFlat_Stock = nToneladasFlat
	from 
		VIST_CM_MOVIMIENTOS_DESTINO_STOCK_MOVIMIENTOS_FINAL 
	where 
		iCodigoDestinoCombo = @iCodigoDestino

	if @iTipoBalance = 1
	begin
		if isnull(@nToneladasFlat,0) > isnull(@nToneladasFlat_Stock,0)
		begin
			set @nToneladas = isnull(@nToneladas,0) - isnull(@nToneladas_Stock,0)
			set @nToneladasFlat = isnull(@nToneladasFlat,0) - isnull(@nToneladasFlat_Stock,0)		
			set @nAu = @nAu_Stock
			set @nAg = @nAg_Stock
			set @nAs = @nAs_Stock
			set @nHg = @nHg_Stock
			set @nCu = @nCu_Stock
			set @nPb = @nPb_Stock
			set @nZn = @nZn_Stock
			set @nS = @nS_Stock
			set @nDensidad = @nDensidad_Stock
		end
	end
	if @iTipoBalance = 2
	begin
		select 1
	end
	if @iTipoBalance = 3
	begin
		select 1
	end

	insert into CM_MOVIMIENTOS_GENERAL(
		iTipoMovimiento,
		dFechaRPT,
		cTurno,
		dFechaHora,
		cObservaciones,
		bAuto)
	values(
		@iTipoMovimiento,
		@dFechaRPT,
		case	when datepart(hh,@dFechaHora) between 8 and 19 then 'A' else 'B' end,
		@dFechaHora,
		@cObservaciones,
		@bAuto)

	declare @iCodigo int= (Select Ident_Current('CM_MOVIMIENTOS_GENERAL'))

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
	values(
		@iCodigo,
		case when @nAu = 0 then NULL else @nAu end,
		case when @nAg = 0 then NULL else @nAg end,
		case when @nAs = 0 then NULL else @nAs end,
		case when @nHg = 0 then NULL else @nHg end,
		case when @nCu = 0 then NULL else @nCu end,
		case when @nPb = 0 then NULL else @nPb end,
		case when @nZn = 0 then NULL else @nZn end,
		case when @nS = 0 then NULL else @nS end,
		case when @nDensidad = 0 then NULL else @nDensidad end)

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
		'',
		'',
		'',
		'',
		@nToneladas,
		@nToneladasFlat)

	--insert into CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS(
	--	iCodigo,
	--	iCodigoTipoRoca_GROCK,
	--	iCodigoTipoAlteracion_AROCK,
	--	iCodigoZonaMineral_MROCK,
	--	iCodigoDurezaRelativa_DUREZA,
	--	iCodigoMaterial,
	--	cCodigoBloque)
	--values(
	--	@iCodigo,
	--	@iCodigoTipoRoca_GROCK,
	--	@iCodigoTipoAlteracion_AROCK,
	--	@iCodigoZonaMineral_MROCK,
	--	@iCodigoDurezaRelativa_DUREZA,
	--	@iCodigoMaterial,
	--	@cCodigoBloque)

	--insert into CM_MOVIMIENTOS_UBICACIONES_ORIGEN(
	--	iCodigo,
	--	iCodigoOrigen,
	--	nEastingOrigen,
	--	nNorthingOrigen,
	--	nElevationOrigen,
	--	nLongitudOrigen,
	--	nLatitudOrigen)
	--values(
	--	@iCodigo,
	--	@iCodigoOrigen,
	--	case when @nEastingOrigen = 0 then NULL else @nEastingOrigen end,
	--	case when @nNorthingOrigen = 0 then NULL else @nNorthingOrigen end,
	--	case when @nElevationOrigen = 0 then NULL else @nElevationOrigen end,
	--	case when @nLongitudOrigen = 0 then NULL else @nLongitudOrigen end,
	--	case when @nLatitudOrigen = 0 then NULL else @nLatitudOrigen end)

	--insert into CM_MOVIMIENTOS_UBICACIONES_DESTINO(
	--	iCodigo,
	--	iCodigoDestino,
	--	nEastingDestino,
	--	nNorthingDestino,
	--	nElevationDestino,
	--	nLongitudDestino,
	--	nLatitudDestino)
	--values(
	--	@iCodigo,
	--	@iCodigoDestino,
	--	case when @nEastingDestino = 0 then NULL else @nEastingDestino end,
	--	case when @nNorthingDestino = 0 then NULL else @nNorthingDestino end,
	--	case when @nElevationDestino = 0 then NULL else @nElevationDestino end,
	--	case when @nLongitudDestino = 0 then NULL else @nLongitudDestino end,
	--	case when @nLatitudDestino = 0 then NULL else @nLatitudDestino end)

	exec MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS @iTipoMovimiento, @dFechaRPT
	exec GUARDAR_CM_MOVIMIENTOS_AGRUPADOS_STOCK_FINAL @iTipoMovimiento, @iCodigoDestino
	exec MODIFICAR_CM_MOVIMIENTOS_STOCK_CONDICION_POR_MOVIMIENTO @iTipoMovimiento, @iCodigo, @iCodigoDestino

	select 'MenSys_SaveOK', @iCodigo

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END






--GUARDAR / MODIFICAR ver dataset porq no sale aviso de guardado o modificado
GO
