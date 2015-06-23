USE [MeetingGame]
GO

DECLARE	@return_value int

EXEC	@return_value = [Instagram].[AddInstagram]
		@userId = 111,
		@profilePicture = N'http://',
		@accessToken = N'123',
		@profileId = 11

SELECT	'Return Value' = @return_value

GO