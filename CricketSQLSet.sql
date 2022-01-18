--variable
"SELECT * FROM OPENROWSET (BULK "
+"'"+
 @[User::FilePath]
+"'"+
" , SINGLE_CLOB) AS xCol;"


SELECT *
from S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn)
WITH (
match_type varchar(200) '$.info.match_type',
event varchar(200) '$.info.event.name',
winner varchar(200) '$.info.outcome.winner',
winning_margin varchar(200) '$.info.outcome.by.wickets',
overs varchar(20) '$.info.overs',
player_of_match varchar(200) '$.info.player_of_match[0]'
)


--Match
SELECT
*
FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j

CROSS APPLY OPENJSON(BulkColumn)
WITH (
match_type varchar(200) '$.info.match_type',
event varchar(200) '$.info.event.name',
winner varchar(200) '$.info.outcome.winner',
winning_margin varchar(200) '$.info.outcome.by.wickets',
overs varchar(20) '$.info.overs',
player_of_match varchar(200) '$.info.player_of_match[0]'
)
--Players
select 
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename, t1.[key] as [TeamName], t2.[key] as PlayerNo, t2.[value] as Player
from S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn)
WITH (
teams NVARCHAR(MAX) '$.info.players' AS JSON) as A
CROSS APPLY OPENJSON(A.teams) as t1
CROSS APPLY OPENJSON ( t1.[value]) AS t2

select filename ,
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','')
from S_Raw_JSON

SELECT *
from S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn)
WITH (
match_type varchar(200) '$.info.match_type',
event varchar(200) '$.info.event.name',
winner varchar(200) '$.info.outcome.winner',
winning_margin varchar(200) '$.info.outcome.by.wickets',
overs varchar(20) '$.info.overs',
player_of_match varchar(200) '$.info.player_of_match[0]'
)



--Teams
select 
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename, 
i2.[key] as TeamNo, i3.[value] as TeamName
FROM S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
WHERE i1.[key]='innings'
and i3.[key]='team'
--Powerplay

SELECT i2.[key] as inningsNo,
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename, 
i4.*
FROM S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) 
WITH (from_value varchar(20) '$.from',
      to_value varchar(20) '$.to',
      type varchar(20) '$.type' ) as i4
WHERE i1.[key]='innings'
AND i3.[key]='powerplays'



--Runs
select i4.*, i5.*,i6.*,i7.*,
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename, 
i4.[key] as [overNo], i6.[key] as ballNo,
case when i8.[key]='batter' then i8.[value] else 0 end as batterRuns,
case when i8.[key]='extras' then i8.[value] else 0 end as extraRuns
FROM S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) 
    WITH (batter varchar(100) '$.batter') as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
CROSS APPLY OPENJSON(i7.[value]) as i8
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
--and i7.[key]='runs'
--Wickets
select i2.[key] as innings, 
i4.[key] as [overNo], 
i6.[key] as ballNo, 
i8.[kind], 
i8.[player_out], i8.[fielder]
FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
CROSS APPLY OPENJSON(i7.[value]) 
with (
    kind varchar(20) '$.kind', 
    player_out varchar(100) '$.player_out', 
    fielder varchar(100) '$.fielders.name[0]'
) as i8
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
and i7.[key]='wickets'

--BatterBowler
select   i4.[key] as [overNo], i6.[key] as ball, i7.*
FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
--CROSS APPLY OPENJSON(i7.[value]) as i8
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
and i7.[key] in ('non_striker','batter','bowler')


--Wickets

SELECT i2.[key] as inningsNo,
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename, 
i4.*
FROM S_Raw_JSON

select i2.[key] as inningsNo, 
i4.[key] as [overNo], 
i6.[key] as ballNo, 
i8.[kind], 
i8.[player_out], i8.[fielder],
REPLACE(REPLACE(RIGHT([filename],12),'.json',''),'\','') as filekey,
BulkColumn, filename
FROM S_Raw_JSON
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
CROSS APPLY OPENJSON(i7.[value]) 
with (
    kind varchar(20) '$.kind', 
    player_out varchar(100) '$.player_out', 
    fielder varchar(100) '$.fielders.name[0]'
) as i8
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
and i7.[key]='wickets'
