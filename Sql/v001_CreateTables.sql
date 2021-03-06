USE [master]
GO
/****** Object:  Database [MeetingGame]    Script Date: 29/05/2015 22:19:22 ******/
CREATE DATABASE [MeetingGame]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MeetingGame', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MeetingGame.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MeetingGame_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MeetingGame_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MeetingGame] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MeetingGame].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MeetingGame] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MeetingGame] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MeetingGame] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MeetingGame] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MeetingGame] SET ARITHABORT OFF 
GO
ALTER DATABASE [MeetingGame] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MeetingGame] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MeetingGame] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MeetingGame] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MeetingGame] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MeetingGame] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MeetingGame] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MeetingGame] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MeetingGame] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MeetingGame] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MeetingGame] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MeetingGame] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MeetingGame] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MeetingGame] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MeetingGame] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MeetingGame] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MeetingGame] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MeetingGame] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MeetingGame] SET RECOVERY FULL 
GO
ALTER DATABASE [MeetingGame] SET  MULTI_USER 
GO
ALTER DATABASE [MeetingGame] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MeetingGame] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MeetingGame] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MeetingGame] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [MeetingGame]
GO
/****** Object:  Schema [Instagram]    Script Date: 29/05/2015 22:19:22 ******/
CREATE SCHEMA [Instagram]
GO
/****** Object:  Schema [Profile]    Script Date: 29/05/2015 22:19:22 ******/
CREATE SCHEMA [Profile]
GO
/****** Object:  StoredProcedure [Instagram].[AddInstagram]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Add a new Instagram
-- =============================================
CREATE PROCEDURE [Instagram].[AddInstagram] 
	@userId int,
	@profilePicture nvarchar(100),
	@accessToken nvarchar(128),
	@profileId int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT 
		INTO Instagram(UserId, ProfilePicture, AccessToken, Creation)
		VALUES (@userId, @profilePicture, @accessToken, GETUTCDATE())

	UPDATE dbo.Profile
	SET InstagramIdFk = SCOPE_IDENTITY()
	WHERE Id = @profileId
END


GO
/****** Object:  StoredProcedure [Profile].[ActivateProfile]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Activate an user
-- =============================================
CREATE PROCEDURE [Profile].[ActivateProfile]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @realId int;

	SELECT 
		@realId = id 
	FROM dbo.Profile as p
	WHERE p.Id = @id

	IF @realId > 0
		BEGIN
			UPDATE dbo.Profile
			SET
				Activation = GETUTCDATE(),
				IsActivated = 1,
				Statut = 'Activated'
			WHERE Id = @realId
		END
END


GO
/****** Object:  StoredProcedure [Profile].[AddInstagramProfile]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Add InstagramIdFk for an user
-- =============================================
CREATE PROCEDURE [Profile].[AddInstagramProfile] 
	@id				int,
	@instagramIdFk	int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @realId int;

	SELECT 
		@realId = id 
	FROM dbo.Profile as p
	WHERE p.Id = @id

	IF @realId > 0
		BEGIN
			UPDATE dbo.Profile
			SET InstagramIdFk = @instagramIdFk
			WHERE dbo.Profile.Id = @realId
		END
END

GO
/****** Object:  StoredProcedure [Profile].[AddProfile]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Add a new user
-- =============================================
CREATE PROCEDURE [Profile].[AddProfile] 
	@email			nvarchar(80),
	@nickname		nvarchar(20),
	@gender			bit,
	@city			nvarchar(80),
	@password		nvarchar(128),
	@godfatherIdFk	int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT 
		INTO Profile(Email, Statut, Nickname, Gender, City, Password, IsActivated, Creation, GodfatherIdFk)
		VALUES (@email, 'Created', @nickname, @gender, @city, @password, 0, GETUTCDATE(), @godfatherIdFk)
END

GO
/****** Object:  StoredProcedure [Profile].[CheckEmail]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Check an email
-- =============================================
CREATE PROCEDURE [Profile].[CheckEmail]
	@email nvarchar(80)
AS
BEGIN
	SET NOCOUNT ON;

    IF EXISTS(SELECT 1 FROM dbo.Profile as p WHERE p.Email = @email)
		RETURN 1
	ELSE
		RETURN 0
	
END


GO
/****** Object:  StoredProcedure [Profile].[DeleteProfile]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Delete an user
-- =============================================
CREATE PROCEDURE [Profile].[DeleteProfile]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @realId int;
	DECLARE @instagramIdFk int;

	SELECT 
		@realId = id,
		@instagramIdFk = InstagramIdFk 
	FROM dbo.Profile as p
	WHERE p.Id = @id

	IF @realId > 0
		BEGIN
			UPDATE dbo.Profile
			SET GodfatherIdFk = NULL
			WHERE GodfatherIdFk = @realId

			DELETE 
				dbo.Profile
			WHERE dbo.Profile.Id = @realId
		END

	IF @instagramIdFk > 0
		BEGIN
			DELETE dbo.Instagram 
			WHERE dbo.Instagram.Id = @instagramIdFk
		END
END

GO
/****** Object:  Table [dbo].[Instagram]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instagram](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ProfilePicture] [nvarchar](100) NOT NULL,
	[AccessToken] [nvarchar](128) NOT NULL,
	[Creation] [datetime] NOT NULL,
 CONSTRAINT [PK_Instagram] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Profile]    Script Date: 29/05/2015 22:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Statut] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](80) NOT NULL,
	[Nickname] [nvarchar](20) NOT NULL,
	[Gender] [bit] NOT NULL,
	[City] [nvarchar](80) NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[IsActivated] [bit] NOT NULL,
	[Creation] [datetime] NOT NULL,
	[Activation] [datetime] NULL,
	[GodfatherIdFk] [int] NULL,
	[InstagramIdFk] [int] NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [Unique_UserId]    Script Date: 29/05/2015 22:19:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Unique_UserId] ON [dbo].[Instagram]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Unique_Email]    Script Date: 29/05/2015 22:19:22 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Email] ON [dbo].[Profile]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Godfather] FOREIGN KEY([GodfatherIdFk])
REFERENCES [dbo].[Profile] ([Id])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Godfather]
GO
ALTER TABLE [dbo].[Profile]  WITH CHECK ADD  CONSTRAINT [FK_Profile_Instagram] FOREIGN KEY([InstagramIdFk])
REFERENCES [dbo].[Instagram] ([Id])
GO
ALTER TABLE [dbo].[Profile] CHECK CONSTRAINT [FK_Profile_Instagram]
GO
USE [master]
GO
ALTER DATABASE [MeetingGame] SET  READ_WRITE 
GO
