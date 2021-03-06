-- insert for PlayerReceiver
select 
	g.[To],
	p.[Gender],
	count(g.[To]) as 'View',
	case when gLike.[Like] is null then 0 else gLike.[Like] end as 'Like',
	case when gRate.[Rate] is null then 0 else gRate.[Rate] end as 'Rate'
from [MeetingGame].[dbo].[Game] as g
left join (select g1.[To], count(g1.[To]) as [Like] from [MeetingGame].[dbo].[Game] as g1 where g1.[Action] = 1 group by g1.[To]) as gLike on gLike.[To] = g.[To]
left join (select g2.[To], avg(g2.[Rate]) as [Rate] from [MeetingGame].[dbo].[Game] as g2 where g2.[Action] = 2 group by g2.[To]) as gRate on gRate.[To] = g.[To]
inner join [MeetingGame].[dbo].[profile] as p on p.[Id] = g.[To]
group by g.[To], gLike.[Like], gRate.[Rate], p.Gender
order by g.[To]

-- insert for PlayerTransmitter
select 
	g.[From],
	count(g.[From]) as 'ProfilePlayed',
	case when gLike.[Like] is null then 0 else gLike.[Like] end as 'Like',
	gRate.[Rate] as 'Rate'
from [MeetingGame].[dbo].[Game] as g
left join (select g1.[From], count(g1.[From]) as [Like] from [MeetingGame].[dbo].[Game] as g1 where g1.[Action] = 1 group by g1.[From]) as gLike on gLike.[From] = g.[From]
left join (select g2.[From], avg(g2.[Rate]) as [Rate] from [MeetingGame].[dbo].[Game] as g2 where g2.[Action] = 2 group by g2.[From]) as gRate on gRate.[From] = g.[From]
where g.[Action] is not null

group by g.[From], gLike.[Like], gRate.[Rate]
order by g.[From]
