select * from S_Raw_JSON

select * from s_file_info

truncate table s_file_info;
truncate table S_Raw_JSON;
truncate table s_MatchInfo;
truncate table s_Teams;
truncate table s_PowerPlays;
truncate table s_Wickets;


select * from s_MatchInfo
select * from S_Teams
select * from s_Players
select * from s_Wickets

alter table s_MatchInfo add filename varchar(200)

select * from S_Raw_JSON

INSERT INTO S_Raw_JSON SELECT * FROM OPENROWSET (BULK 'H:\Data\cricsheet\524915.json',SINGLE_CLOB)

alter table S_Raw_JSON add filename varchar(100)

INSERT INTO S_Raw_JSON SELECT * FROM OPENROWSET (BULK 'H:\Data\cricsheet\524915.json',SINGLE_CLOB) AS J

--INSERT INTO S_Raw_JSON 
SELECT * FROM OPENROWSET (BULK 'H:\Data\cricsheet\524915.json',SINGLE_CLOB) AS J

select * from S_MatchInfo

, 

SELECT A.BulkColumn, A.filename, RIGHT(A.filename, 12) filekey
from S_Raw_JSON  A
CROSS APPLY OPENJSON(BulkColumn)
WITH (
match_type varchar(200) '$.info.match_type',
event varchar(200) '$.info.event.name',
winner varchar(200) '$.info.outcome.winner',
winning_margin varchar(200) '$.info.outcome.by.wickets',
overs varchar(20) '$.info.overs',
player_of_match varchar(200) '$.info.player_of_match[0]'
) 