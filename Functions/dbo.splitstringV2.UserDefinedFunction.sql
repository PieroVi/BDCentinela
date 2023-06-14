/****** Object:  UserDefinedFunction [dbo].[splitstringV2]    Script Date: 14/06/2023 08:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[splitstringV2] ( @stringToSplit VARCHAR(MAX), @stringSeparator VARCHAR(10) )
RETURNS
 @returnList TABLE ([id] int IDENTITY(1,1),[Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(@stringSeparator, @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(@stringSeparator, @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
