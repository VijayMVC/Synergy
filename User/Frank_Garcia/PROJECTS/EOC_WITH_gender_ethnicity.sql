SELECT
	Subtest
	,ETHNICITY
	,[GENDER CODE]
	,Score2
	,COUNT ([ID Number]) AS TOTALS
FROM	
(
SELECT
	EOC.DOB
	,EOC.[District Number]
	,EOC.Grade
	,EOC.[ID Number]
	,EOC.SCH_YR
	,EOC.School
	,EOC.[School Year]
	,EOC.Score1
	,EOC.Score2
	,EOC.Score3
	,EOC.Subtest
	,EOC.[Test ID]
	,EOC.first_name
	,EOC.last_name
	,EOC.[test Date]
	,CASE
		WHEN STARS.[HISPANIC INDICATOR] = 'Y' THEN 'H'
		ELSE STARS.[ETHNIC CODE SHORT]
	END AS ETHNICITY
	,STARS.[GENDER CODE]
	--,STARS.[ETHNIC CODE SHORT]
	--,STARS.[HISPANIC INDICATOR]
FROM
	[180-SMAXODS-01].SchoolNet.dbo.EOC_	AS EOC
LEFT JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
	ON
	EOC.[ID Number] = STARS.[ALTERNATE STUDENT ID]
	AND 
		CASE
			WHEN EOC.[SCH_YR] = '2012-2013' THEN '2013' 
			WHEN EOC.SCH_YR = '2013-2014' THEN '2014'
		END = STARS.SY			
	AND 
		CASE	
			WHEN EOC.SCH_YR = '2012-2013' THEN '2013-06-01'
			WHEN EOC.SCH_YR = '2013-2014' THEN '2013-12-15'
		END = STARS.PERIOD

) AS T1
WHERE [GENDER CODE] IS NOT NULL
GROUP BY
	SUBTEST
	,ETHNICITY
	,[GENDER CODE]
	,Score2
	
ORDER BY Subtest, ETHNICITY, [GENDER CODE], Score2	