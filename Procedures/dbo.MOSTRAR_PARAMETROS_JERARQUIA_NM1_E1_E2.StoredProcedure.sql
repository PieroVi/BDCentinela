/****** Object:  StoredProcedure [dbo].[MOSTRAR_PARAMETROS_JERARQUIA_NM1_E1_E2]    Script Date: 14/06/2023 08:17:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[MOSTRAR_PARAMETROS_JERARQUIA_NM1_E1_E2] --'PAD''s'
	@cGrupo1 varchar(500),
	@iEntero1 int
as

	if @iEntero1 = 0 --PARA COMBOS
	begin
		select
			iCodigoParametro,
			cDescripcion,
			iOrden,
			bEstado,
			cEstado,
			iCodigoParametroPadre,
			cDescripcionPadre,
			iImagen,
			cGrupo1
		from 
			VIST_PARAMETROS_JERARQUIA_NM1_E1_E2
		where
			cGrupo1 = @cGrupo1
	end
	else --PARA VENTANA
	begin
		select
			0 iCodigoParametro,
			@cGrupo1 cDescripcion,
			0 iOrden,
			1 bEstado,
			'Activo' cEstado,
			-1 iCodigoParametroPadre,
			'' cDescripcionPadre,
			0 iImagen,
			@cGrupo1 cGrupo1

			union all

			select
			iCodigoParametro,
			cDescripcion,
			iOrden,
			bEstado,
			cEstado,
			iCodigoParametroPadre,
			cDescripcionPadre,
			iImagen,
			cGrupo1
		from 
			VIST_PARAMETROS_JERARQUIA_NM1_E1_E2
		where
			cGrupo1 = @cGrupo1

	end
GO
