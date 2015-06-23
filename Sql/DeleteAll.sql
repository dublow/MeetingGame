use MeetingGame

delete from MeetingGame.dbo.GameStatus
DBCC CHECKIDENT (GameStatus, RESEED, 0)

delete from MeetingGame.dbo.Game
DBCC CHECKIDENT (Game, RESEED, 0)

delete from MeetingGame.dbo.PlayerReceiver
DBCC CHECKIDENT (PlayerReceiver, RESEED, 0)

delete from MeetingGame.dbo.PlayerTransmitter
DBCC CHECKIDENT (PlayerTransmitter, RESEED, 0)

update MeetingGame.dbo.Profile
set GodfatherIdFk = null

delete from MeetingGame.dbo.Profile
DBCC CHECKIDENT (Profile, RESEED, 0)

delete from MeetingGame.dbo.Instagram
DBCC CHECKIDENT (Instagram, RESEED, 0)

delete from MeetingGame.dbo.Filter
