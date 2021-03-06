USE [MeetingGame]
GO
/****** Object:  Schema [Game]    Script Date: 23/06/2015 02:12:58 ******/
CREATE SCHEMA [Game]
GO
/****** Object:  Schema [Instagram]    Script Date: 23/06/2015 02:12:58 ******/
CREATE SCHEMA [Instagram]
GO
/****** Object:  Schema [Profile]    Script Date: 23/06/2015 02:12:58 ******/
CREATE SCHEMA [Profile]
GO
/****** Object:  StoredProcedure [Game].[AddLike]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015-05-31
-- Description:	Add 1 like for an user
-- =============================================
CREATE PROCEDURE [Game].[AddLike]
	@from int,
	@to int
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @count int;

		-- If @count is equal to 1(Playing) then the player can play else he can't play
		SELECT @count = count(gs.id) FROM GameStatus as gs
		WHERE gs.ProfileIdFk = @from
		AND gs.Status = 1

		IF @count = 1
		BEGIN
			-- Adding the like action (1) to the Game table for the current player
			UPDATE dbo.Game
			SET 
				[Action] = 1
			WHERE [From] = @from
			AND [To] = @to

			-- If @count is equal to 0 then the player has played all actions for them all
			SELECT @count = count(g.id) FROM Game as g
			WHERE g.[From] = @from
			AND g.Action is null

			IF @count = 0
			BEGIN
				-- Adding 2 (end game => played) to the GameStatus table for the current player
				UPDATE dbo.GameStatus
				SET 
					[Status] = 2
				WHERE [ProfileIdFk] = @from
			END
		END
END


GO
/****** Object:  StoredProcedure [Game].[AddPlayer]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015-05-31
-- Description:	Add x players for an user
-- =============================================
CREATE PROCEDURE [Game].[AddPlayer]
	@from int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @count int;
		SELECT @count = count(g.id) FROM Game as g
		WHERE g.[From] = @from

		IF @count = 0
		BEGIN

			DECLARE @to int
			DECLARE @creation datetime SET @creation = GETUTCDATE()

			DECLARE @MyCursor CURSOR SET @MyCursor = CURSOR FAST_FORWARD
			FOR
				SELECT TOP 3 p.Id
				FROM Profile as p
				WHERE p.Id != @from
				ORDER BY NEWID()
			OPEN @MyCursor
			FETCH NEXT FROM @MyCursor
			INTO @to
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Game([From],[To], Creation) VALUES(@from, @to, @creation)
				FETCH NEXT FROM @MyCursor
				INTO @to
			END
			CLOSE @MyCursor
			DEALLOCATE @MyCursor

			INSERT INTO GameStatus(ProfileIdFk, Status, Creation) VALUES(@from, 1, @creation)
		END

		SELECT p.Id,p.Nickname, p.Gender, i.ProfilePicture FROM Profile as p
		INNER JOIN Instagram as i ON i.Id = p.InstagramIdFk
		WHERE p.Id IN (
			SELECT g.[To] FROM Game as g
			WHERE g.[From] = @from
		)
END

GO
/****** Object:  StoredProcedure [Game].[AddRate]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015-05-31
-- Description:	Add rate for an user
-- =============================================
CREATE PROCEDURE [Game].[AddRate]
	@from int,
	@to int,
	@rate float
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @count int;

		-- If @count is equal to 1(Playing) then the player can play else he can't play
		SELECT @count = count(gs.id) FROM GameStatus as gs
		WHERE gs.ProfileIdFk = @from
		AND gs.Status = 1

		IF @count = 1
		BEGIN
			-- Adding the like action (1) to the Game table for the current player
			UPDATE dbo.Game
			SET 
				[Action] = 2,
				[Rate] = @rate
			WHERE [From] = @from
			AND [To] = @to

			-- If @count is equal to 0 then the player has played all actions for them all
			SELECT @count = count(g.id) FROM Game as g
			WHERE g.[From] = @from
			AND g.Action is null

			IF @count = 0
			BEGIN
				-- Adding 2 (end game => played) to the GameStatus table for the current player
				UPDATE dbo.GameStatus
				SET 
					[Status] = 2
				WHERE [ProfileIdFk] = @from
			END
		END
END



GO
/****** Object:  StoredProcedure [Game].[CalculatePlayerReceiver]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015-06-22
-- Description:	Calculate data from dbo.game and insert 1 row by dbo.game.to
-- =============================================
CREATE PROCEDURE [Game].[CalculatePlayerReceiver]

AS
BEGIN
	INSERT INTO dbo.PlayerReceiver(ProfileIdFk, Gender, TotalView, AverageRate, TotalLike, DayUpdate, LastUpdate) 
	select 
		g.[To], 
		p.[Gender], 
		count(g.[To]),
		case when gRate.[Rate] is null then 0 else gRate.[Rate] end,
		case when gLike.[Like] is null then 0 else gLike.[Like] end,
		REPLACE(LEFT(CONVERT (varchar, GETUTCDATE(), 112),10),' ','-'),
		GETUTCDATE()
	from [MeetingGame].[dbo].[Game] as g
		left join (select g1.[To], count(g1.[To]) as [Like] from [MeetingGame].[dbo].[Game] as g1 where g1.[Action] = 1 group by g1.[To]) as gLike 
			on gLike.[To] = g.[To]
		left join (select g2.[To], avg(g2.[Rate]) as [Rate] from [MeetingGame].[dbo].[Game] as g2 where g2.[Action] = 2 group by g2.[To]) as gRate 
			on gRate.[To] = g.[To]
		inner join [MeetingGame].[dbo].[profile] as p on p.[Id] = g.[To]
	group by g.[To], gLike.[Like], gRate.[Rate], p.Gender
	order by g.[To]

	-- delete filter
	delete from [MeetingGame].[dbo].[Filter]

	-- View
	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Min', 
		min(p.TotalView) as 'min', 
		((min(p.TotalView) + ((min(p.TotalView) + max(p.TotalView)) / 2)) / 2) as 'max', 
		'View', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Mid',  
		(min(p.TotalView) + ((min(p.TotalView) + max(p.TotalView)) / 2)) / 2 as 'min',
		(max(p.TotalView) + ((min(p.TotalView) + max(p.TotalView)) / 2)) / 2 as 'max', 
		'View', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Max',  
		(max(p.TotalView) + ((min(p.TotalView) + max(p.TotalView)) / 2)) / 2 as 'min', 
		max(p.TotalView) as 'max',
		'View', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender


	-- Rate
	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Min', 
		min(p.AverageRate) as 'min', 
		((min(p.AverageRate) + ((min(p.AverageRate) + max(p.AverageRate)) / 2)) / 2) as 'max', 
		'Rate', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Mid',  
		(min(p.AverageRate) + ((min(p.AverageRate) + max(p.AverageRate)) / 2)) / 2 as 'min',
		(max(p.AverageRate) + ((min(p.AverageRate) + max(p.AverageRate)) / 2)) / 2 as 'max', 
		'Rate', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Max',  
		(max(p.AverageRate) + ((min(p.AverageRate) + max(p.AverageRate)) / 2)) / 2 as 'min', 
		max(p.AverageRate) as 'max',
		'Rate', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender


	-- Like
	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Min', 
		min(p.TotalLike) as 'min', 
		((min(p.TotalLike) + ((min(p.TotalLike) + max(p.TotalLike)) / 2)) / 2) as 'max', 
		'Like', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Mid',  
		(min(p.TotalLike) + ((min(p.TotalLike) + max(p.TotalLike)) / 2)) / 2 as 'min',
		(max(p.TotalLike) + ((min(p.TotalLike) + max(p.TotalLike)) / 2)) / 2 as 'max', 
		'Like', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender

	insert into dbo.Filter(Range, Min, Max, FilterAction, FilterGender)
	select 
		'Max',  
		(max(p.TotalLike) + ((min(p.TotalLike) + max(p.TotalLike)) / 2)) / 2 as 'min', 
		max(p.TotalLike) as 'max',
		'Like', 
		p.Gender
	from dbo.PlayerReceiver as p group by p.Gender
END



GO
/****** Object:  StoredProcedure [Game].[CalculatePlayerTransmitter]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015-06-22
-- Description:	Calculate data from dbo.game and insert 1 row by dbo.game.from
-- =============================================
CREATE PROCEDURE [Game].[CalculatePlayerTransmitter]

AS
BEGIN
	INSERT INTO dbo.PlayerTransmitter(ProfileIdFk, TotalPlayed, AverageRate, TotalLike, DayUpdate, LastUpdate) 
	select 
		g.[From],
		count(g.[From]),
		case when gRate.[Rate] is null then 0 else gRate.[Rate] end,
		case when gLike.[Like] is null then 0 else gLike.[Like] end,
		REPLACE(LEFT(CONVERT (varchar, GETUTCDATE(), 112),10),' ','-'),
		GETUTCDATE()
	from [MeetingGame].[dbo].[Game] as g
		left join (select g1.[From], count(g1.[From]) as [Like] from [MeetingGame].[dbo].[Game] as g1 where g1.[Action] = 1 group by g1.[From]) as gLike 
			on gLike.[From] = g.[From]
		left join (select g2.[From], avg(g2.[Rate]) as [Rate] from [MeetingGame].[dbo].[Game] as g2 where g2.[Action] = 2 group by g2.[From]) as gRate 
			on gRate.[From] = g.[From]
	where g.[Action] is not null
	group by g.[From], gLike.[Like], gRate.[Rate]
	order by g.[From]
END




GO
/****** Object:  StoredProcedure [Instagram].[AddInstagram]    Script Date: 23/06/2015 02:12:58 ******/
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
	@userId bigint,
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
/****** Object:  StoredProcedure [Profile].[ActivateProfile]    Script Date: 23/06/2015 02:12:58 ******/
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
				Activation = GETUTCDATE()
			WHERE Id = @realId
		END
END


GO
/****** Object:  StoredProcedure [Profile].[AddProfile]    Script Date: 23/06/2015 02:12:58 ******/
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
	@gender			int,
	@city			nvarchar(80),
	@password		nvarchar(128),
	@godfatherIdFk	int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT 
		INTO Profile(Email, Nickname, Gender, City, Password, Creation, GodfatherIdFk)
		VALUES (@email, @nickname, @gender, @city, @password, GETUTCDATE(), @godfatherIdFk)
END

GO
/****** Object:  StoredProcedure [Profile].[CheckEmail]    Script Date: 23/06/2015 02:12:58 ******/
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
		SELECT 1
	ELSE
		SELECT 0
	
END


GO
/****** Object:  StoredProcedure [Profile].[DeleteProfile]    Script Date: 23/06/2015 02:12:58 ******/
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
/****** Object:  StoredProcedure [Profile].[GetById]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 30
-- Description:	Get user by id
-- =============================================
CREATE PROCEDURE [Profile].[GetById] 
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		p.Id,
		p.Email,
		p.Nickname,
		p.Gender,
		p.City,
		p.Creation,
		p.Activation,
		i.AccessToken,
		i.UserId as 'InstagramUserId',
		i.ProfilePicture,
		i.Id as 'InstagramId',
		gf.Id as 'GodfatherId',
		gf.Nickname as 'GodfatherNickname',
		gf.Gender as 'GodfatherGender',
		gf.City as 'GodfatherCity'
	FROM dbo.Profile as p
	WITH(nolock)
	LEFT JOIN dbo.Instagram as i ON i.Id = p.InstagramIdFk
	LEFT JOIN dbo.Profile as gf ON gf.Id = p.GodfatherIdFk
	WHERE p.Id = @id	
END


GO
/****** Object:  StoredProcedure [Profile].[GetCredential]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicolas Delfour
-- Create date: 2015 05 29
-- Description:	Get credential
-- =============================================
CREATE PROCEDURE [Profile].[GetCredential] 
	@email			nvarchar(80)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		p.Id,
		p.Password
	FROM Profile as p
	WHERE p.Email = @email
END


GO
/****** Object:  Table [dbo].[Filter]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Filter](
	[Range] [nvarchar](3) NOT NULL,
	[Min] [int] NOT NULL,
	[Max] [int] NOT NULL,
	[FilterAction] [nvarchar](10) NOT NULL,
	[FilterGender] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Game]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Game](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[From] [int] NOT NULL,
	[To] [int] NOT NULL,
	[Action] [int] NULL,
	[Rate] [float] NULL,
	[Creation] [datetime] NOT NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GameStatus]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProfileIdFk] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Creation] [datetime] NOT NULL,
 CONSTRAINT [PK_GameStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Instagram]    Script Date: 23/06/2015 02:12:58 ******/
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
/****** Object:  Table [dbo].[PlayerReceiver]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlayerReceiver](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProfileIdFk] [int] NOT NULL,
	[Gender] [int] NOT NULL,
	[TotalView] [int] NOT NULL CONSTRAINT [DF_PlayerReceiver_TotalView]  DEFAULT ((0)),
	[AverageRate] [float] NOT NULL CONSTRAINT [DF_PlayerReceiver_AverageRate]  DEFAULT ((0)),
	[TotalLike] [int] NOT NULL,
	[DayUpdate] [nvarchar](8) NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_PlayerReceiver] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PlayerTransmitter]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlayerTransmitter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProfileIdFk] [int] NOT NULL,
	[TotalPlayed] [int] NOT NULL CONSTRAINT [DF_PlayerTransmitter_TotalView]  DEFAULT ((0)),
	[AverageRate] [float] NOT NULL CONSTRAINT [DF_PlayerTransmitter_AverageRate]  DEFAULT ((0)),
	[TotalLike] [int] NOT NULL,
	[DayUpdate] [nvarchar](8) NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_PlayerTransmitter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Profile]    Script Date: 23/06/2015 02:12:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](80) NOT NULL,
	[Nickname] [nvarchar](20) NOT NULL,
	[Gender] [int] NOT NULL,
	[City] [nvarchar](80) NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
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
ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [FK_Game_From] FOREIGN KEY([From])
REFERENCES [dbo].[Profile] ([Id])
GO
ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [FK_Game_From]
GO
ALTER TABLE [dbo].[Game]  WITH CHECK ADD  CONSTRAINT [FK_Game_Profile] FOREIGN KEY([To])
REFERENCES [dbo].[Profile] ([Id])
GO
ALTER TABLE [dbo].[Game] CHECK CONSTRAINT [FK_Game_Profile]
GO
ALTER TABLE [dbo].[PlayerReceiver]  WITH CHECK ADD  CONSTRAINT [FK_PlayerReceiver_Profile] FOREIGN KEY([ProfileIdFk])
REFERENCES [dbo].[Profile] ([Id])
GO
ALTER TABLE [dbo].[PlayerReceiver] CHECK CONSTRAINT [FK_PlayerReceiver_Profile]
GO
ALTER TABLE [dbo].[PlayerTransmitter]  WITH CHECK ADD  CONSTRAINT [FK_PlayerTransmitter_Profile] FOREIGN KEY([ProfileIdFk])
REFERENCES [dbo].[Profile] ([Id])
GO
ALTER TABLE [dbo].[PlayerTransmitter] CHECK CONSTRAINT [FK_PlayerTransmitter_Profile]
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
