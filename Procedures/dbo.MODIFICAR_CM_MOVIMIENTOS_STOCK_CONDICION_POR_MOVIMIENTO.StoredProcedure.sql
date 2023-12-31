/****** Object:  StoredProcedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_STOCK_CONDICION_POR_MOVIMIENTO]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MODIFICAR_CM_MOVIMIENTOS_STOCK_CONDICION_POR_MOVIMIENTO] --1,335,'2022-01-01','2024-01-01'
@iTipo int,
@iCodigo int,
@iCodigoDestinoCombo int
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

set nocount on;

declare @iBalance int = (select top 1 iCodigo from CM_UBICACIONES where cCodigoEstadistica = 'BALANCE')

	declare @table table(
		iCodigo int,
		iCodigoDestino int,
		nAu float,
		bEstado bit,
		cCondicion varchar(500)
	)

	declare @cCondicion varchar(max) = rtrim(ltrim(isnull((select cCondicion from CM_UBICACIONES where iCodigo = @iCodigoDestinoCombo),'')))

	if @cCondicion <> ''
	begin
		declare @Consulta varchar(max) = '
			select 
				g.iCodigo,
				d.iCodigoDestino,
				l.nAu,
				'+ case when @cCondicion = '' then '0' else 'case when ' + replace(@cCondicion,'@','l.n') + ' then 0 else case when d.iCodigoDestino <> '+convert(varchar(max),@iBalance)+' then 1 else 0 end end ' end +' bEstado, 
				'''+ @cCondicion +''' cCondicion
			from
				CM_MOVIMIENTOS_GENERAL g 
					inner join CM_MOVIMIENTOS_LEYES l on 
						g.iCodigo = l.iCodigo 
					inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d on 
						g.iCodigo = d.iCodigo 
			where 
				g.iCodigo = '+convert(varchar(max),@iCodigo)+' and  
				g.iTipo = '+convert(varchar(max),@iTipo)+'  
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

		delete from @table
	end

	select 'MenSys_EditOK', 1

COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	--set nocount on;
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
