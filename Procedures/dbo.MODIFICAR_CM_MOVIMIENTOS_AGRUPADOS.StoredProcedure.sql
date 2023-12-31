/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS]
@iTipoMovimiento int,
@dFechaRPT date
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	delete from CM_MOVIMIENTOS_GENERAL_AGRUPADO
	where
		iTipoMovimiento = @iTipoMovimiento and
		dFechaRPT = @dFechaRPT 

	insert into CM_MOVIMIENTOS_GENERAL_AGRUPADO
	select
		iTipoMovimiento,
		dFechaRPT,
		iCodigoOrigen,
		iCodigoDestino,
		sum(isnull(nToneladas,0)) nToneladas,
		sum(isnull(nToneladasFlat,0)) nToneladasFlat,
		count(1) iViajes,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nAu end,0))/sum(isnull(nToneladasFlat,0)) end nAu,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nAg end,0))/sum(isnull(nToneladasFlat,0)) end nAg,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nAs end,0))/sum(isnull(nToneladasFlat,0)) end nAs,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nHg end,0))/sum(isnull(nToneladasFlat,0)) end nHg,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nCu end,0))/sum(isnull(nToneladasFlat,0)) end nCu,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nPb end,0))/sum(isnull(nToneladasFlat,0)) end nPb,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nZn end,0))/sum(isnull(nToneladasFlat,0)) end nZn,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nS end,0))/sum(isnull(nToneladasFlat,0)) end nS,
		case when sum(isnull(nToneladasFlat,0)) = 0 then 0 else sum(isnull(nToneladasFlat,0) * isnull(case when nToneladasFlat = 0 then 0 else nDensidad end,0))/sum(isnull(nToneladasFlat,0)) end nDensidad
	from
		VIST_CM_MOVIMIENTOS_GENERAL
	where
		dFechaRPT = @dFechaRPT and
		iTipoMovimiento = @iTipoMovimiento
	group by
		iTipoMovimiento,
		dFechaRPT,
		iCodigoOrigen,
		iCodigoDestino
	order by
		dFechaRPT,
		iCodigoOrigen

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	set nocount on;
END CATCH
END
GO
