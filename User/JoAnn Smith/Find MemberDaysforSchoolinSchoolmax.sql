--select * from dbo.MEMBERDAYS_2013
--where SCHNBR in ('410', '413', '416', '420', '427', '440', '448',  '470')
--SELECT * FROM DBTSIS.CA005_V 



SELECT SCH_NBR, SCH_YR, MEMTODT FROM 
DBTSIS.CA005_V AS CA
WHERE
CA.DST_NBR = 1
AND SCH_YR = 2014
AND CA.DAY_CD = 'LD' 
AND SCH_NBR = '410'
