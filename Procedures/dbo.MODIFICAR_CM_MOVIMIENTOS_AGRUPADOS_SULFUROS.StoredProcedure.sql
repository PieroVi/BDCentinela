/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_SULFUROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFICAR_CM_MOVIMIENTOS_AGRUPADOS_SULFUROS]
@dFechaRPT date
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	delete from CM_MOVIMIENTOS_GENERAL_AGRUPADO_SULFUROS
	where
		dFechaRPT = @dFechaRPT 

	insert into CM_MOVIMIENTOS_GENERAL_AGRUPADO_SULFUROS
	select
		dFechaRPT,
		iCodigoOrigen,
		iCodigoDestino,
		sum(isnull(nToneladas,0)) nToneladas,
		sum(isnull(nToneladasFlat,0)) nToneladasFlat,
		count(1) iViajes,
		avg(nCueq),
		avg(nCut),
		avg(nCus),
		avg(nAu),
		avg(nAg),
		avg(nMo),
		avg(nAs),
		avg(nCo3),
		avg(nNo3),
		avg(nFet),
		avg(nPy_Aux),
		avg(nLeyc_Cut),
		avg(nLeyc_Au),
		avg(nRecg_Cu),
		avg(nRecg_Au),
		avg(nBwi),
		avg(nTph_Sag),
		avg(nCpy_Ajus),
		avg(nCccv_Ajus),
		avg(nBo_Ajus),
		avg(nAxb),
		avg(nVsed_E),
		avg(nCp_Pond),
		avg(nLey_Con_Rou),
		avg(nDominio),
		avg(nIns)
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
		g.iTipo = 1
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
