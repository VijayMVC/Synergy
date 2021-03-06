BEGIN TRAN
SELECT
	ETHNICITY
	,GENDER
	,'MATH' AS test_section_name
	,LOC
	,score
	,COUNT (id_nbr) AS TOTALS
FROM
(
	SELECT
		id_nbr
		,[Passed All Required Tests] AS score
		,CASE
			WHEN STARS.[HISPANIC INDICATOR] = 'Y' THEN 'H'
			ELSE STARS.[ETHNIC CODE SHORT]
		END AS ETHNICITY
		,STARS.[GENDER CODE] AS GENDER
		,STARS.[LOCATION CODE] AS LOC

	FROM
		[180-SMAXODS-01].SchoolNetDevelopment.dbo.[Exit_Exam_Status_Winter_2013_2014] AS EOC
			LEFT JOIN
				[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STARS
				ON
				RIGHT ('000000'+EOC.id_nbr,9) = STARS.[ALTERNATE STUDENT ID]
				AND STARS.SY = '2014'
				AND STARS.PERIOD = '2013-12-15'
	WHERE
		[Passed All Required Tests] = 'YES'	
		AND [Current SY2014 Grade] = '12'
	) AS T1

WHERE ETHNICITY IS NOT NULL
GROUP BY
		GENDER
		,ETHNICITY
		--,test_section_name
		,LOC
		,score
ORDER BY ETHNICITY, [GENDER], test_section_name	


ROLLBACK