/****** Object:  User [usrDinoDevWenco]    Script Date: 14/06/2023 08:14:41 ******/
CREATE USER [usrDinoDevWenco] WITH PASSWORD=N'8xtML5FQk46Ld6LIdXF/i1f+mfbmGgWGyeHM8THFe/c=', DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'usrDinoDevWenco'
GO
