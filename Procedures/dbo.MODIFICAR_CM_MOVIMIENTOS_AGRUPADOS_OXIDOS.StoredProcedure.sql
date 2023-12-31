/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_OXIDOS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_OXIDOS]
@dFechaRPT date
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	delete from CM_MOVIMIENTOS_GENERAL_AGRUPADO_OXIDOS
	where
		dFechaRPT = @dFechaRPT 

	insert into CM_MOVIMIENTOS_GENERAL_AGRUPADO_OXIDOS
	select
		dFechaRPT,
		iCodigoOrigen,
		iCodigoDestino,
		sum(isnull(nToneladas,0)) nToneladas,
		sum(isnull(nToneladasFlat,0)) nToneladasFlat,
		count(1) iViajes,
		avg(nCut),
		avg(nCus),
		avg(nCo3),
		avg(nNo3),
		avg(nHum),
		AVG(nRec_Heap),
		AVG(nRec_Rom),
		AVG(nCan_Heap),
		AVG(nCan_Rom),
		AVG(nM100),
		AVG(nM400)
	from
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_LEY l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join CM_UBICACIONES deto with(nolock) on
				o.iCodigoOrigen = deto.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
	where
		g.dFechaRPT = @dFechaRPT and
		g.iTipo = 2
	group by
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
