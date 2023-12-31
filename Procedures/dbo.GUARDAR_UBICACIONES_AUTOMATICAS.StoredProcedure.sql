/****** Object:  StoredProcedure [dbo].[GUARDAR_UBICACIONES_AUTOMATICAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GUARDAR_UBICACIONES_AUTOMATICAS]
@iTipoMovimiento int,
@cXMLValidacion xml
as
BEGIN
SET XACT_ABORT  ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	declare @table table(
		id int identity(1,1),
		cFuente varchar(200)
	)

	insert into @table
	select
		nref.value('cUbicacion[1]','varchar(500)')
	from @cXMLValidacion.nodes('/NewDataSet/Table1') as R(nref)		
	OPTION (OPTIMIZE FOR (@cXMLValidacion = NULL))


	declare @Contador int = 1
	declare @ContadorMax int = (select count(1) from @table)

	declare @cFuenteCursor varchar(200)
	declare @cCodigoEstadistica varchar(200)
	declare @cCodigoFisica varchar(200)
	declare @cDescripcion varchar(400)
	declare @cAlias varchar(50)
	declare @iTajo int
	declare @iCalidadMineral int
	declare @cMinaCancha varchar(50)
	declare @cFase varchar(20)
	declare @cBanco varchar(20)
	declare @cMalla varchar(20)
	declare @cTmat varchar(20)
	declare @cPoligono varchar(20)

	declare @Ubicaciones table(iCodigo int)

	while @Contador <= @ContadorMax
	begin
		
		set @cFuenteCursor = isnull((select cFuente from @table where id = @Contador),'')

		if @iTipoMovimiento = 1
		begin
			if (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2) like '%STOCK%'
			begin

				set @cCodigoEstadistica = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cCodigoFisica = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cDescripcion = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cAlias = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
	
				set @iTajo = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - TAJO' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 1)),0)
				set @iCalidadMineral = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - CALIDAD MINERAL' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 6)),0)
				set @cMinaCancha = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cFase = '-99'
				set @cBanco = '-99'
				set @cMalla = '-99'
				set @cTmat = isnull((select Name from dbo.splitstringV2(@cFuenteCursor,'/') where id = 6),'')
				set @cPoligono = 'A'

				if	@cCodigoEstadistica <> '' and
					@cCodigoFisica <> '' and
					@cDescripcion <> '' and
					@cAlias <> '' and
					@iTajo <> 0 and
					@iCalidadMineral <> 0
				begin
					if not exists(select 1 from CM_UBICACIONES where cCodigoEstadistica = @cCodigoEstadistica and iTipoMineral = @iTipoMovimiento)
					begin
						insert into CM_UBICACIONES
						select
							@cCodigoEstadistica,
							@cCodigoFisica,
							@cDescripcion,
							@cAlias,
							'S',
							1,
							1,
							'',
							@iTajo,
							@iCalidadMineral,
							0,
							'',
							@cMinaCancha,
							@cFase,
							@cBanco,
							@cMalla,
							@cTmat,
							@cPoligono,
							@iTipoMovimiento

						insert into @Ubicaciones
						values((Select Ident_Current('CM_UBICACIONES')))
					end

				end
			end
			else
			begin
				set @cCodigoEstadistica	 = @cFuenteCursor
				set @cCodigoFisica = isnull((	select
											case	when SUBSTRING((select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),2,1) = '0' 
														then replace((select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),'0','')
														else (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2) end + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 3) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 4) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 5) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6)),'')
				set @cDescripcion = isnull(@cCodigoEstadistica,'')
				set @cAlias = isnull(@cCodigoFisica,'')
				set @iTajo = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - TAJO' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 1)),0)
				set @iCalidadMineral = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - CALIDAD MINERAL' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6)),0)		
				set @cMinaCancha = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 1),'')
				set @cFase = isnull(replace(replace((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),'F08',''),'F',''),'')
				set @cBanco = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 3),'')
				set @cMalla = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 4),'')
				set @cTmat = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6),'')
				set @cPoligono = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 5),'')

				

				if	@cCodigoEstadistica <> '' and
					@cCodigoFisica <> '' and
					@cDescripcion <> '' and
					@cAlias <> '' and
					@iTajo <> 0 and
					@iCalidadMineral <> 0
				begin
			
					if not exists(select 1 from CM_UBICACIONES where cCodigoEstadistica = @cCodigoEstadistica and iTipoMineral = @iTipoMovimiento)
					begin
						insert into CM_UBICACIONES
						select
							@cCodigoEstadistica,
							@cCodigoFisica,
							@cDescripcion,
							@cAlias,
							'O',
							1,
							1,
							'',
							@iTajo,
							@iCalidadMineral,
							0,
							'',
							@cMinaCancha,
							@cFase,
							@cBanco,
							@cMalla,
							@cTmat,
							@cPoligono,
							@iTipoMovimiento

						insert into @Ubicaciones
						values((Select Ident_Current('CM_UBICACIONES')))
					end
				end
			end
		end
		else
		begin
	
			if (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2) like '%STOCK%' or (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2) like '%STM%' or (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2) like '%MOD%'
			begin

				set @cCodigoEstadistica = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cCodigoFisica = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cDescripcion = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cAlias = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
	
				set @iTajo = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - TAJO' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 1)),0)
				set @iCalidadMineral = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - CALIDAD MINERAL' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 6)),0)
				set @cMinaCancha = (select Name from  dbo.splitstringV2(@cFuenteCursor,'/') where id = 2)
				set @cFase = '-99'
				set @cBanco = '-99'
				set @cMalla = '-99'
				set @cTmat = isnull((select Name from dbo.splitstringV2(@cFuenteCursor,'/') where id = 6),'')
				set @cPoligono = 'A'

				if	@cCodigoEstadistica <> '' and
					@cCodigoFisica <> '' and
					@cDescripcion <> '' and
					@cAlias <> '' and
					@iTajo <> 0 and
					@iCalidadMineral <> 0
				begin
					if not exists(select 1 from CM_UBICACIONES where cCodigoEstadistica = @cCodigoEstadistica and iTipoMineral = @iTipoMovimiento)
					begin
						insert into CM_UBICACIONES
						select
							@cCodigoEstadistica,
							@cCodigoFisica,
							@cDescripcion,
							@cAlias,
							'S',
							1,
							1,
							'',
							@iTajo,
							@iCalidadMineral,
							0,
							'',
							@cMinaCancha,
							@cFase,
							@cBanco,
							@cMalla,
							@cTmat,
							@cPoligono,
							@iTipoMovimiento

						insert into @Ubicaciones
						values((Select Ident_Current('CM_UBICACIONES')))
					end

				end
			end
			else
			begin
				set @cCodigoEstadistica	 = @cFuenteCursor
				set @cCodigoFisica = isnull((	select
											case	when SUBSTRING((select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),2,1) = '0' 
														then replace((select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),'0','')
														else (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2) end + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 3) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 4) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 5) + '_' +
											(select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6)),'')
				set @cDescripcion = isnull(@cCodigoEstadistica,'')
				set @cAlias = isnull(@cCodigoFisica,'')
				set @iTajo = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - TAJO' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 1)),0)
				set @iCalidadMineral = isnull((select top 1 iCodigoParametro from PARAMETROS where cGrupo1 = 'SCM - CALIDAD MINERAL' and cNombreCorto1 = (select Name from  dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6)),0)		
				set @cMinaCancha = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 1),'')
				set @cFase = isnull(replace(replace((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 2),'F08',''),'F',''),'')
				set @cBanco = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 3),'')
				set @cMalla = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 4),'')
				set @cTmat = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 6),'')
				set @cPoligono = isnull((select Name from dbo.splitstringV2(@cCodigoEstadistica,'/') where id = 5),'')

				

				if	@cCodigoEstadistica <> '' and
					@cCodigoFisica <> '' and
					@cDescripcion <> '' and
					@cAlias <> '' and
					@iTajo <> 0 and
					@iCalidadMineral <> 0
				begin
			
					if not exists(select 1 from CM_UBICACIONES where cCodigoEstadistica = @cCodigoEstadistica and iTipoMineral = @iTipoMovimiento)
					begin
						insert into CM_UBICACIONES
						select
							@cCodigoEstadistica,
							@cCodigoFisica,
							@cDescripcion,
							@cAlias,
							'O',
							1,
							1,
							'',
							@iTajo,
							@iCalidadMineral,
							0,
							'',
							@cMinaCancha,
							@cFase,
							@cBanco,
							@cMalla,
							@cTmat,
							@cPoligono,
							@iTipoMovimiento

						insert into @Ubicaciones
						values((Select Ident_Current('CM_UBICACIONES')))
					end
				end
			end
		end

		set @Contador = @Contador + 1
	end
	
	select 'MenSys_SaveOK', ''

	select
		u.iCodigo,
		u.cCodigoEstadistica,
		u.cCodigoFisica,
		u.cDescripcion,
		u.cAlias,
		u.cTipo,
		case	when u.cTipo = 'O' then 'ORIGEN'
				when u.cTipo = 'D' then 'DESTINO'
				when u.cTipo = 'S' then 'STOCK' end cTipoDescripcion,
		u.bAplica,
		case	when u.bAplica = 1 then 'APLICA' else 'NO APLICA' end cAplica,
		u.bEstado,
		case	when u.bEstado = 1 then 'ACTIVO' else 'INACTIVO' end cEstado,
		u.cCondicion,
		u.iTajo,
		p.cDescripcion cTajoCodigo,
		p.cDescripcion2 cTajo,
		u.iCalidadMineral,
		c.cNombreCorto1 cCalidadMineralCodigo,
		c.cNombreMedio1 cCalidadMineral,
		u.nLeyPromedio,
		u.cObservacion,
		u.cMinaCancha,
		u.cFase,
		u.cBanco,
		u.cMalla,
		u.cTmat,
		u.cPoligono,
		case when p.iCodigoParametroPadre = 0 then p.cDescripcion else (select top 1 cNombreCorto1 from PARAMETROS pp where pp.iCodigoParametro = p.iCodigoParametroPadre) + ' - ' + p.cDescripcion end cRegionTajo,
		case when p.iCodigoParametroPadre = 0 then p.cDescripcion else (select top 1 cNombreCorto1 from PARAMETROS pp where pp.iCodigoParametro = p.iCodigoParametroPadre) end cRegion,
		u.iTipoMineral,
		case when u.iTipoMineral = 1 then 'SULFUROS' else 'OXIDOS' end cTipoMineral 
	from
		CM_UBICACIONES u with(nolock)
			inner join VIST_PARAMETROS_JERARQUIA_NC1_NM1_E1_E2 p with(nolock) on
				u.iTajo = p.iCodigoParametro
			inner join PARAMETROS c with(nolock) on
				u.iCalidadMineral = c.iCodigoParametro
	where
		iCodigo in (select iCodigo from @Ubicaciones)




COMMIT
END TRY
BEGIN CATCH
ROLLBACK
	select 'MenSys_ErrorSQL', ERROR_MESSAGE() AS ErrorMessage; 
END CATCH
END
GO
