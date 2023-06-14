/****** Object:  UserDefinedFunction [dbo].[FN_GENERAR_CLAVE]    Script Date: 14/06/2023 08:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_GENERAR_CLAVE] 
(
    @clave VARCHAR(max)
)
RETURNS VarBinary(8000)
AS
BEGIN
    
    
    DECLARE @pass AS VarBinary(8000)
    ------------------------------------
    ------------------------------------
    SET @pass = ENCRYPTBYPASSPHRASE('dbCurso09',@clave)--dbCurso09 es la llave para cifrar el campo.
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END
GO
