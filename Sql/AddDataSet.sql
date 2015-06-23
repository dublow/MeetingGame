use MeetingGame

-- profile
exec Profile.AddProfile 'nicolas@fake.com', 'nicolas', 1, 'Paris', 'test', null
exec Profile.AddProfile 'rosamonde@fake.com', 'rosamonde', 2, 'Paris', 'test', null

exec Profile.AddProfile 'Lucas@fake.com', 'Lucas', 1, 'Lyon', 'test', null
exec Profile.AddProfile 'celine@fake.com', 'celine', 2, 'Lyon', 'test', null

exec Profile.AddProfile 'Claude@fake.com', 'Claude', 1, 'Marseille', 'test', null
exec Profile.AddProfile 'harbin@fake.com', 'harbin', 2, 'Marseille', 'test', null

exec Profile.AddProfile 'Vail@fake.com', 'Vail', 1, 'Bordeaux', 'test', null
exec Profile.AddProfile 'Faye@fake.com', 'Faye', 2, 'Bordeaux', 'test', null

exec Profile.AddProfile 'Emmanuel@fake.com', 'Emmanuel', 1, 'Nantes', 'test', null
exec Profile.AddProfile 'Amber@fake.com', 'Amber', 2, 'Nantes', 'test', null

-- Instagram
exec Instagram.AddInstagram 11378122, 'http://cdn.instagram/11378122', 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d', 1
exec Instagram.AddInstagram 21378122, 'http://cdn.instagram/21378122', 'fb2e77d.57a0479900504cb3ab4a1f626d174d2d', 2
exec Instagram.AddInstagram 31378122, 'http://cdn.instagram/31378122', 'fb2e77d.67a0479900504cb3ab4a1f626d174d2d', 3
exec Instagram.AddInstagram 41378122, 'http://cdn.instagram/41378122', 'fb2e77d.77a0479900504cb3ab4a1f626d174d2d', 4
exec Instagram.AddInstagram 51378122, 'http://cdn.instagram/51378122', 'fb2e77d.87a0479900504cb3ab4a1f626d174d2d', 5
exec Instagram.AddInstagram 61378122, 'http://cdn.instagram/61378122', 'fb2e77d.97a0479900504cb3ab4a1f626d174d2d', 6
exec Instagram.AddInstagram 71378122, 'http://cdn.instagram/71378122', 'fb2e77d.10a0479900504cb3ab4a1f626d174d2d', 7
exec Instagram.AddInstagram 81378122, 'http://cdn.instagram/81378122', 'fb2e77d.41a0479900504cb3ab4a1f626d174d2d', 8
exec Instagram.AddInstagram 91378122, 'http://cdn.instagram/91378122', 'fb2e77d.42a0479900504cb3ab4a1f626d174d2d', 9
exec Instagram.AddInstagram 10378122, 'http://cdn.instagram/10378122', 'fb2e77d.43a0479900504cb3ab4a1f626d174d2d', 10

-- Game
exec Game.AddPlayer 1
exec Game.AddPlayer 2
exec Game.AddPlayer 3
exec Game.AddPlayer 4
exec Game.AddPlayer 5
exec Game.AddPlayer 6
exec Game.AddPlayer 7
exec Game.AddPlayer 8
exec Game.AddPlayer 9
exec Game.AddPlayer 10

-- playing
exec Game.AddRate 1, 2, 6
exec Game.AddLike 1, 7
exec Game.AddLike 1, 8

exec Game.AddRate 2, 4, 9
exec Game.AddRate 2, 9, 3
exec Game.AddLike 2, 10

exec Game.AddLike 3, 5
exec Game.AddLike 3, 7
exec Game.AddLike 3, 9

exec Game.AddRate 4, 7, 8
exec Game.AddRate 4, 9, 5
exec Game.AddRate 4, 10, 2

exec Game.AddRate 5, 2, 9
exec Game.AddLike 5, 6
exec Game.AddLike 5, 10

exec Game.AddRate 6, 1, 9
exec Game.AddRate 6, 3, 3
exec Game.AddLike 6, 4

exec Game.AddLike 7, 5
exec Game.AddLike 7, 8
exec Game.AddLike 7, 10

exec Game.AddRate 8, 1, 1
exec Game.AddRate 8, 2, 3
exec Game.AddRate 8, 4, 7

exec Game.AddLike 9, 1
exec Game.AddLike 9, 3
exec Game.AddLike 9, 5

exec Game.AddRate 10, 3, 2
exec Game.AddRate 10, 6, 4
exec Game.AddRate 10, 9, 6
