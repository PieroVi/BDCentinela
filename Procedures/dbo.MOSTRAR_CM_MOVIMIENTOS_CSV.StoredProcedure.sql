/****** Object:  StoredProcedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_CSV]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_CM_MOVIMIENTOS_CSV] --1,1,'2022-11-22','2022-11-22',1
@iTipoMovimiento int,
@iCodigoDestinoCombo int,
@dInicio date,
@dFin date,
@bTodos bit
WITH RECOMPILE
as

set nocount on;

if @bTodos = 0
begin
	select 
		e.cCodigoPala Equipo,
		e.cCodigoCamion Camion,
		convert(varchar(10),convert(date,g.dFechaHora),103) FECHA,
		NULL Column1,
		NULL _1,
		NULL _2,
		NULL _3,
		REPLACE(
            REPLACE(
                RIGHT(
                    '0000000000' + 
                        CONVERT(
                        varchar(10), 
                        cast(g.dFechaHora as time(0)), 
                        109),
                10), 
            'PM', 
            ' p. m.'),
        'AM',
        ' a. m.') [Hora Carga],
	
		isnull(o.nEastingOrigen,0) [X Carga],
		isnull(o.nNorthingOrigen,0) [Y Carga],
		isnull(o.nElevationOrigen,0) [Z Carga],
	
		case when ISNUMERIC(isnull(p.cCodigoBloque,0)) = 1 then isnull(p.cCodigoBloque,0) else 0 end BLOQUE,

		--e.nToneladas,
		e.nToneladasFlat Ton,

		isnull(l.nAu,0) Au,
		isnull(l.nAg,0) Ag,
		isnull(l.nCu,0) Cu,
		isnull(l.nAs,0) ARS,
		isnull(l.nHg,0) HG,
		isnull(l.nS,0) S,
		isnull(l.nPb,0) Pb,
		isnull(l.nZn,0) Zn,
		
		case when ptr.cCodigoEstadistica = '99999' then '' else ptr.cCodigoEstadistica end GROCK,
		case when pal.cCodigoEstadistica = '99999' then '' else pal.cCodigoEstadistica end AROCK,
		case when zmi.cCodigoEstadistica = '99999' then '' else zmi.cCodigoEstadistica end MROCK,

		isnull(l.nDensidad,0) Densidad,

		case when pdu.cCodigoEstadistica = '99999' then '' else pdu.cCodigoEstadistica end Dureza,

		0 [DEST BLOQUE],
		detd.cCodigoEstadistica [DEST OPER],

		isnull(d.nEastingDestino,0) [X DESC],
		isnull(d.nNorthingDestino,0) [Y DESC],
		isnull(d.nElevationDestino,0) [Z DESC]
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock) 
			inner join CM_MOVIMIENTOS_LEYES l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS p with(nolock) on
				g.iCodigo = p.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS ptr with(nolock) on
				p.iCodigoTipoRoca_GROCK = ptr.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pal with(nolock) on
				p.iCodigoTipoAlteracion_AROCK = pal.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS zmi with(nolock) on
				p.iCodigoZonaMineral_MROCK = zmi.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pdu with(nolock) on
				p.iCodigoDurezaRelativa_DUREZA = pdu.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pmat with(nolock) on
				p.iCodigoMaterial = pmat.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join CM_UBICACIONES deto with(nolock) on
				o.iCodigoOrigen = deto.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
	where
		iTipoMovimiento = @iTipoMovimiento and
		(iCodigoOrigen = @iCodigoDestinoCombo or iCodigoDestino = @iCodigoDestinoCombo) and
		dFechaRPT between @dInicio and @dFin
	order by
		dFechaHora asc
end
else
begin
	select 
		e.cCodigoPala Equipo,
		e.cCodigoCamion Camion,
		convert(varchar(10),convert(date,g.dFechaHora),103) FECHA,
		NULL Column1,
		NULL _1,
		NULL _2,
		NULL _3,
		REPLACE(
            REPLACE(
                RIGHT(
                    '0000000000' + 
                        CONVERT(
                        varchar(10), 
                        cast(g.dFechaHora as time(0)), 
                        109),
                10), 
            'PM', 
            ' p. m.'),
        'AM',
        ' a. m.') [Hora Carga],
	
		isnull(o.nEastingOrigen,0) [X Carga],
		isnull(o.nNorthingOrigen,0) [Y Carga],
		isnull(o.nElevationOrigen,0) [Z Carga],
	
		case when ISNUMERIC(isnull(p.cCodigoBloque,0)) = 1 then isnull(p.cCodigoBloque,0) else 0 end BLOQUE,

		--e.nToneladas,
		e.nToneladasFlat Ton,

		isnull(l.nAu,0) Au,
		isnull(l.nAg,0) Ag,
		isnull(l.nCu,0) Cu,
		isnull(l.nAs,0) ARS,
		isnull(l.nHg,0) HG,
		isnull(l.nS,0) S,
		isnull(l.nPb,0) Pb,
		isnull(l.nZn,0) Zn,
		
		case when ptr.cCodigoEstadistica = '99999' then '' else ptr.cCodigoEstadistica end GROCK,
		case when pal.cCodigoEstadistica = '99999' then '' else pal.cCodigoEstadistica end AROCK,
		case when zmi.cCodigoEstadistica = '99999' then '' else zmi.cCodigoEstadistica end MROCK,

		isnull(l.nDensidad,0) Densidad,

		case when pdu.cCodigoEstadistica = '99999' then '' else pdu.cCodigoEstadistica end Dureza,

		0 [DEST BLOQUE],
		detd.cCodigoEstadistica [DEST OPER],

		isnull(d.nEastingDestino,0) [X DESC],
		isnull(d.nNorthingDestino,0) [Y DESC],
		isnull(d.nElevationDestino,0) [Z DESC]
	from 
		CM_MOVIMIENTOS_GENERAL g with(nolock)
			inner join CM_MOVIMIENTOS_LEYES l with(nolock) on
				g.iCodigo = l.iCodigo
			inner join CM_MOVIMIENTOS_EQUIPOS e with(nolock) on
				g.iCodigo = e.iCodigo
			inner join CM_MOVIMIENTOS_PARAMETROS_GEOLOGICOS p with(nolock) on
				g.iCodigo = p.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS ptr with(nolock) on
				p.iCodigoTipoRoca_GROCK = ptr.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pal with(nolock) on
				p.iCodigoTipoAlteracion_AROCK = pal.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS zmi with(nolock) on
				p.iCodigoZonaMineral_MROCK = zmi.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pdu with(nolock) on
				p.iCodigoDurezaRelativa_DUREZA = pdu.iCodigo
			inner join CM_PARAMETROS_GEOLOGICOS pmat with(nolock) on
				p.iCodigoMaterial = pmat.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_ORIGEN o with(nolock) on
				g.iCodigo = o.iCodigo
			inner join CM_UBICACIONES deto with (nolock) on
				o.iCodigoOrigen = deto.iCodigo
			inner join CM_MOVIMIENTOS_UBICACIONES_DESTINO d with(nolock) on
				g.iCodigo = d.iCodigo
			inner join CM_UBICACIONES detd with(nolock) on
				d.iCodigoDestino = detd.iCodigo
	where
		iTipoMovimiento = @iTipoMovimiento and
		dFechaRPT between @dInicio and @dFin
	order by
		dFechaHora asc
end
GO
