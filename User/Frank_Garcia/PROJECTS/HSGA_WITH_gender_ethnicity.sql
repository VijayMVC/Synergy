

SELECT
	ETHNICITY
	,[GENDER CODE]
	,test_section_name
	,score_group_name
	,COUNT (student_code) AS TOTALS
FROM	
(
SELECT
	EOC.student_code
	,EOC.test_section_name
	,EOC.score_group_name
	,CASE
		WHEN STARS.[HISPANIC INDICATOR] = 'Y' THEN 'H'
		ELSE STARS.[ETHNIC CODE SHORT]
	END AS ETHNICITY
	,STARS.[GENDER CODE]
	--,STARS.[ETHNIC CODE SHORT]
	--,STARS.[HISPANIC INDICATOR]
FROM
	[180-SMAXODS-01].SchoolNet.dbo.[SBA Sciene Reading Math] AS EOC
LEFT JOIN
	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
	ON
	EOC.student_code = STARS.[ALTERNATE STUDENT ID]
	AND STARS.SY = '2013'
	AND STARS.PERIOD = '2013-06-01'
	--AND 
	--	CASE
	--		WHEN EOC.[SCH_YR] = '2012-2013' THEN '2013' 
	--		WHEN EOC.SCH_YR = '2013-2014' THEN '2014'
	--	END = STARS.SY			
	--AND 
	--	CASE	
	--		WHEN EOC.SCH_YR = '2012-2013' THEN '2013-06-01'
	--		WHEN EOC.SCH_YR = '2013-2014' THEN '2013-12-15'
	--	END = STARS.PERIOD

) AS T1
--WHERE SS_SCIENCE_FALL_2013 > 0
--AND ETHNICITY IS NOT NULL
GROUP BY
	[GENDER CODE]
	,ETHNICITY
	,test_section_name
	,score_group_name
ORDER BY ETHNICITY, [GENDER CODE], test_section_name