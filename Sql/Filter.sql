/****** Script de la commande SelectTopNRows à partir de SSMS  ******/
declare @gender int
declare @rangeView nvarchar(10)
declare @rangeRate nvarchar(10)
declare @rangeLike nvarchar(10)

set @gender = 2
set @rangeView = 'min'
set @rangeRate = 'max'
set @rangeLike = 'mid'

declare @minView int
declare @maxView int
declare @minRate int
declare @maxRate int
declare @minLike int
declare @maxLike int

DECLARE @Filter TABLE(
        [Min][int] NOT NULL,
        [Max][int] NOT NULL,
		[Action] nvarchar(10),
		[Range] nvarchar(3))

insert into @Filter
select f.Min, f.Max, f.FilterAction, f.Range 
from [MeetingGame].[dbo].Filter as f 
where f.FilterGender = @gender

select @minView = f.Min, @maxView = f.Max 
from @Filter as f 
where f.[Action] = 'View'
and f.Range = @rangeView

select @minRate = f.Min, @maxRate = f.Max 
from @Filter as f 
where f.[Action] = 'Rate'
and f.Range = @rangeRate

select @minLike = f.Min, @maxLike = f.Max 
from @Filter as f 
where f.Action = 'Like'
and f.Range = @rangeLike

SELECT
      [ProfileIdFk]
  FROM [MeetingGame].[dbo].[PlayerReceiver]
  where Gender = @gender
  and TotalView between @minView and @maxView
  UNION 
SELECT [ProfileIdFk]
  FROM [MeetingGame].[dbo].[PlayerReceiver]
  where Gender = @gender
  and AverageRate between @minRate and @maxRate
  UNION 
SELECT [ProfileIdFk]
  FROM [MeetingGame].[dbo].[PlayerReceiver]
  where Gender = @gender
  and TotalLike between @minLike and @maxLike