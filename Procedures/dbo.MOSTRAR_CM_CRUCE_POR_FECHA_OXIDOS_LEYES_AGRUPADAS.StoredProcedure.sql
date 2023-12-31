/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_LEYES_AGRUPADAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_OXIDOS_LEYES_AGRUPADAS] --'2023-05-02'
@dFechaRPT date
as

select 
	dFecha,
	cRegion,
	cRajo,

	--(select case when len(Name) = 2 then replace(Name,'F','F0') else Name end from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 2) + '/' +
	--(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 3) + '/' +
	--(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 4) + '/' +
	--(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 5) + '/' +
	--(select replace(Name,'.00t','') from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 6) cOrigen,
	case	when (select count(1) from dbo.splitstringV2(cRegion,'_')) = 7  then
		cRajo + '/' +
		(select case when len(Name) = 2 then replace(Name,'F','F0') else Name end from dbo.splitstringV2(cRegion,'_') r where r.id = 3) + '/' +
		(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 4) + '/' +
		(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 5) + '/' +
		(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 6) + '/' +
		(select replace(Name,'.00t','') from dbo.splitstringV2(cRegion,'_') r where r.id = 7)
			else
		replace(replace(cRegion,(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 1)+'_'+(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 2)+'_',''),'.00t','') end cOrigen,--(select Name from dbo.splitstringV2(cRegion,'_') r where r.id = 3) end cOrigen,

	case when sum(nTotal_Mass) = 0 then NULL else sum(nCut * nTotal_Mass) / sum(nTotal_Mass) end nCut,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCus * nTotal_Mass) / sum(nTotal_Mass )end nCus,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCo3 * nTotal_Mass) / sum(nTotal_Mass) end nCo3,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nNo3 * nTotal_Mass) / sum(nTotal_Mass) end nNo3,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nHum * nTotal_Mass) / sum(nTotal_Mass) end nHum,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nRec_Heap * nTotal_Mass) / sum(nTotal_Mass) end nRec_Heap,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nRec_Rom * nTotal_Mass) / sum(nTotal_Mass) end nRec_Rom,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCan_Heap * nTotal_Mass) / sum(nTotal_Mass) end nCan_Heap,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCan_Rom * nTotal_Mass) / sum(nTotal_Mass) end nCan_Rom,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nM100 * nTotal_Mass) / sum(nTotal_Mass) end nM100,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nM400 * nTotal_Mass) / sum(nTotal_Mass) end nM400
into #TempLey
from 
	CM_IMPORTACION_OXIDOS_LEYES with(nolock)
where	
	dFecha = @dFechaRPT
group by	
	dFecha,
	cRegion,
	cRajo
order by
	cRegion

select
	*,
	(select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = cOrigen and iTipoMineral = 2) cSCM
into #TempLeyFinal
from
	#TempLey

--VULKAN
select 
	dFecha,
	cRegion,
	cRajo,
	cOrigen,
	cSCM,
	nCut,
	nCus,	
	nCo3,
	nNo3,
	nHum,
	nRec_Heap,
	nRec_Rom,
	nCan_Heap,
	nCan_Rom,
	nM100,
	nM400	
from #TempLeyFinal
--Columna cRegion contiene Origen + Destino
--Estructura de un Stock en cRegion








GO
