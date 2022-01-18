DECLARE @json NVARCHAR(MAX) = N'{  
      "info": {  
            "officials":{  
                 "umpires":["BNJ Oxenford","PR Reiffel"]  
                 },
    "players": {
      "Brisbane Heat": [
        "BB McCullum","ML Hayden","JR Hopes","AC McDermott"
      ],
      "Sydney Sixers": [
        "BJ Haddin","MA Starc","SCG MacGill"
      ]
    }              
 }}';

SELECT [key], value FROM OPENJSON(@json,'$.info.officials."umpires"');

SELECT [key] as Team, value as Players 
FROM OPENJSON(@json,'$.info.players')

SELECT *
FROM OPENJSON( @json )
WITH (
[info] NVARCHAR(MAX) '$.info.players' as JSON
)

SELECT root.[key] AS [Order],TheValues.[key], TheValues.[value], TheValues2.[key], TheValues2.[value], TheValues3.[key], TheValues3.[value]
FROM OPENJSON ( @JSON ) AS root
CROSS APPLY OPENJSON ( root.value) AS TheValues
CROSS APPLY OPENJSON ( TheValues.[value]) AS TheValues2
CROSS APPLY OPENJSON ( TheValues2.[value]) AS TheValues3



select i2.[key] as TeamNo, i3.[key] as Team, i3.[value] as TeamName
FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
WHERE i1.[key]='innings'
and i3.[key]='team'

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

declare @filename varchar(100) = 'H:\Projects\SSIS\SampleProject\Source\524915.json'
declare @SQL      varchar(MAX) = 'SELECT * FROM OPENROWSET (BULK '+ char(39) + @filename + char(39) +', SINGLE_CLOB) as j'
print @SQL
exec @SQL

SELECT * FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j


declare @filename varchar(100) = 'H:\Projects\SSIS\SampleProject\Source\524915.json'
declare @sql varchar(max) = 'SELECT * FROM OPENROWSET (BULK ' + QUOTENAME(@filename,'''') + ', SINGLE_CLOB) AS xCol;'
print @SQL
exec(@SQL)

SELECT * FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) AS xCol;

SELECT * FROM OPENROWSET (BULK H:\Data\cricsheet\524915.json , SINGLE_CLOB) AS xCol;

select i8.*
FROM OPENROWSET ('BULK '+ char(39) + @filename + char(39), SINGLE_CLOB) as j
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
CROSS APPLY OPENJSON(i7.[value]) as i8
CROSS APPLY OPENJSON(i8.[value]) as i9
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
and i7.[key]='wickets'


select * from S_Raw_JSON

create table s_file_info (filepath varchar(100), dateCreated datetime)

select * from s_file_info

select i8.*
FROM OPENROWSET (BULK 'H:\Projects\SSIS\SampleProject\Source\524915.json', SINGLE_CLOB) as j
CROSS APPLY OPENJSON(BulkColumn) as i1
CROSS APPLY OPENJSON(i1.[value]) as i2
CROSS APPLY OPENJSON(i2.[value]) as i3
CROSS APPLY OPENJSON(i3.[value]) as i4
CROSS APPLY OPENJSON(i4.[value]) as i5
CROSS APPLY OPENJSON(i5.[value]) as i6
CROSS APPLY OPENJSON(i6.[value]) as i7
CROSS APPLY OPENJSON(i7.[value]) as i8
CROSS APPLY OPENJSON(i8.[value]) as i9
WHERE i1.[key]='innings'
AND i3.[key]='overs'
and i5.[key]='deliveries'
and i7.[key]='wickets'

create table s_FileInfo
(
FilePath varchar(100),
DateProcessed datetime,
Meta varchar(100)
)