/****** Object:  StoredProcedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION_SULFUROS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GUARDAR_CM_MOVIMIENTOS_STOCK_CONDICION_SULFUROS]-- 1,335,'2022-11-17'
@iCodigoDestinoCombo int,
@dFechaHora date
--@dFechaInicio datetime,
--@dFechaFin datetime
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

set nocount on;


declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE' and iTipoMineral = 3)

	declare @table table(
		iCodigo int,
		iCodigoDestino int,
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
		nIns float,
		nHum float,
		nRec_Heap float,
		nRec_Rom float,
		nCan_Heap float,
		nCan_Rom float,
		nM100 float,
		nM400 float,
		bEstado bit,
		cCondicion varchar(500)
	)

	declare @cCondicion varchar(max) = isnull(rtrim(ltrim((select cCondicion from CM_UBICACIONES where iCodigo = @iCodigoDestinoCombo))),'')

	if @cCondicion <> ''
	begin
		declare @Consulta varchar(max) = '
			select 
				g.iCodigo,
				d.iCodigoDestino,
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
				l.nHum,
				l.nRec_Heap,
				l.nRec_Rom,
				l.nCan_Heap,
				l.nCan_Rom,
				l.nM100,
				l.nM400,
				'+ case when @cCondicion = '' then '0' else 'case when ' + replace(@cCondicion,'@','l.n') + ' then 0 else case when d.iCodigoDestino <> '+convert(varchar(max),@iBalance)+' then 1 else 0 end end' end +' bEstado,
				'''+ @cCondicion +''' cCondicion
			from 
				CM_MOVIMIENTOS_GENERAL g with(nolock) 
					inner join CM_MOVIMIENTOS_LEY l with(nolock) on 
						g.iCodigo = l.iCodigo 
					inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on 
						g.iCodigo = d.iCodigo 
			where
				g.dFechaRPT = '''+convert(varchar(10),@dFechaHora,121) +''' and 
				d.iCodigoDestino = '+convert(varchar(max),@iCodigoDestinoCombo)+' and 
				g.iTipo = '+convert(varchar(max),1)+' 
				'

		insert into @table
		exec(@Consulta)

		update l set	
			l.bCondicion = t.bEstado,
			l.cCondicion = t.cCondicion
		from
			CM_MOVIMIENTOS_LEY l 
				inner join @table t on
					l.iCodigo = t.iCodigo
	end

	select 'MenSys_SaveOK', 0--, @Consulta

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	--set nocount on;
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
