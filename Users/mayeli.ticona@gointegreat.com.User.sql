/****** Object:  User [mayeli.ticona@gointegreat.com]    Script Date: 14/06/2023 08:14:41 ******/
CREATE USER [mayeli.ticona@gointegreat.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'mayeli.ticona@gointegreat.com'
GO
