USE [MeetingGame]
GO

DECLARE	@return_value int

EXEC	@return_value = [Profile].[AddProfile]
		@email = N'nicolas.dfr@gmail.com',
		@nickname = N'dublow',
		@gender = 1,
		@city = N'Issy-les-moulineaux',
		@password = N'password',
		@godfatherIdFk = NULL

SELECT	'Return Value' = @return_value

GO
