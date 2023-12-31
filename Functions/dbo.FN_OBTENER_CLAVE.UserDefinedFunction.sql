/****** Object:  UserDefinedFunction [dbo].[FN_OBTENER_CLAVE]    Script Date: 14/06/2023 08:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_OBTENER_CLAVE] 
(
    @clave VARBINARY(8000)
)
RETURNS VARCHAR(max)
AS
BEGIN
    
    
    DECLARE @pass AS VARCHAR(max)
    ------------------------------------
    ------------------------------------
    --Se descifra el campo aplicandole la misma llave con la que se cifro dbCurso09
    SET @pass = DECRYPTBYPASSPHRASE('dbCurso09',@clave)
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END
GO
