/****** Object:  User [brenda.lopez@gointegreat.com]    Script Date: 14/06/2023 08:14:41 ******/
CREATE USER [brenda.lopez@gointegreat.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'brenda.lopez@gointegreat.com'
GO
