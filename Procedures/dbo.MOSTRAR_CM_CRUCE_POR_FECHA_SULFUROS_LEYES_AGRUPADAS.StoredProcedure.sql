/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_LEYES_AGRUPADAS]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MOSTRAR_CM_CRUCE_POR_FECHA_SULFUROS_LEYES_AGRUPADAS] --'2023-02-12'
@dFechaRPT date
as

select 
	dFecha,
	cRegion,
	cRajo,
	cRajo + '/' +
	(select case when len(Name) = 2 then replace(Name,'F','F0') else Name end from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 2) + '/' +
	(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 3) + '/' +
	(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 4) + '/' +
	(select Name from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 5) + '/' +
	(select replace(Name,'.00t','') from dbo.splitstringV2((select Name from dbo.splitstringV2(cRegion,'\') r where r.id = 5),'_') r where r.id = 6) cOrigen,

	case when sum(nTotal_Mass) = 0 then NULL else sum(nCueq * nTotal_Mass) / sum(nTotal_Mass) end nCueq,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCut * nTotal_Mass) / sum(nTotal_Mass) end nCut,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCus * nTotal_Mass) / sum(nTotal_Mass )end nCus,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nAu * nTotal_Mass) / sum(nTotal_Mass) end nAu,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nAg * nTotal_Mass) / sum(nTotal_Mass) end nAg,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nMo * nTotal_Mass) / sum(nTotal_Mass ) end nMo,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nAs * nTotal_Mass) / sum(nTotal_Mass) end nAs,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCo3 * nTotal_Mass) / sum(nTotal_Mass) end nCo3,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nNo3 * nTotal_Mass) / sum(nTotal_Mass) end nNo3,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nFet * nTotal_Mass) / sum(nTotal_Mass) end nFet,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nPy_Aux * nTotal_Mass) / sum(nTotal_Mass) end nPy_Aux,


	case when sum(nTotal_Mass) = 0 then NULL else sum(nCut * nLeyc_Cut * nRecg_Cu* nTotal_Mass) / sum(nTotal_Mass * nCut * nRecg_Cu) end nLeyc_Cut,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nAu * nLeyc_Au * nRecg_Au * nTotal_Mass) / sum(nTotal_Mass * nAu * nRecg_Au) end nLeyc_Au,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nRecg_Cu * nCut * nTotal_Mass) / sum(nTotal_Mass) end nRecg_Cu,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nRecg_Au * nAu * nTotal_Mass) / sum(nTotal_Mass) end nRecg_Au,


	case when sum(nTotal_Mass) = 0 then NULL else sum(nBwi * nTotal_Mass) / sum(nTotal_Mass) end nBwi,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nTph_Sag * nTotal_Mass) / sum(nTotal_Mass) end nTph_Sag,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCpy_Ajus * nTotal_Mass) / sum(nTotal_Mass) end nCpy_Ajus,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCccv_Ajus * nTotal_Mass) / sum(nTotal_Mass) end nCccv_Ajus,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nBo_Ajus * nTotal_Mass) / sum(nTotal_Mass) end nBo_Ajus,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nAxb * nTotal_Mass) / sum(nTotal_Mass) end nAxb,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nVsed_E * nTotal_Mass) / sum(nTotal_Mass) end nVsed_E,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nCp_Pond * nTotal_Mass) / sum(nTotal_Mass) end nCp_Pond,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nLey_Con_Rou * nTotal_Mass) / sum(nTotal_Mass) end nLey_Con_Rou,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nDominio * nTotal_Mass) / sum(nTotal_Mass) end nDominio,
	case when sum(nTotal_Mass) = 0 then NULL else sum(nIns * nTotal_Mass) / sum(nTotal_Mass) end nIns	
into #TempLey
from 
	CM_IMPORTACION_SULFUROS_LEYES with(nolock)
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
	(select cCodigoEstadistica from CM_UBICACIONES where cCodigoEstadistica = cOrigen) cSCM
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
	nCueq,
	nCut,
	nCus,
	nAu,
	nAg,
	nMo,
	nAs,
	nCo3,
	nNo3,
	nFet,
	nPy_Aux,
	nLeyc_Cut,
	nLeyc_Au,
	nRecg_Cu,
	nRecg_Au,
	nBwi,
	nTph_Sag,
	nCpy_Ajus,
	nCccv_Ajus,
	nBo_Ajus,
	nAxb,
	nVsed_E,
	nCp_Pond,
	nLey_Con_Rou,
	nDominio,
	nIns
from #TempLeyFinal
--Columna cRegion contiene Origen + Destino
--Estructura de un Stock en cRegion
GO
