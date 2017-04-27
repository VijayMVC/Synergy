/*
Council of Great City Schools KPI 15-16
Data Set 3: For students in GSY 2016 and GSY 2015
Student ID APS
Student ID State
Gender
Race (resolved Race with two or more)
Special Ed Status (NOT Including gifted)
Primary Disability
ELL Status (the STARS Definition � 0 = never enrolled; 1 currently enrolled; 2 exited one year, etc)
ELL Exit Date
FRPL Status
GSY
Grad Date
Grad Status

*/
--NEED GSY 2015 AND GSY 2015
;with StudentCTE
as 
(
SELECT
		ROW_NUMBER() OVER(PARTITION BY BS.SIS_NUMBER ORDER BY BS.SIS_NUMBER) AS RN	
		,'2015-2016' AS [SURVEY SCHOOL YEAR]
		,BS.SIS_NUMBER AS [APS ID]
		,[STUDENT ID] AS [STATE ID]
		,BS.GENDER
		,BS.RACE_1
		,BS.RACE_2
		,BS.RACE_3
		,BS.RACE_4
		,BS.RACE_5
		,BS.RESOLVED_RACE
		,CASE	
			WHEN SPED_STATUS = 'Y' and GIFTED_STATUS = 'Y' 
				THEN 'N'
			WHEN SPED_STATUS = 'N' AND GIFTED_STATUS = 'N'
				THEN 'N'
			WHEN SPED_STATUS = 'Y' AND GIFTED_STATUS = 'N'
				THEN 'Y'
		END AS SPED_STATUS
		,BS.PRIMARY_DISABILITY_CODE
		,LU.VALUE_DESCRIPTION AS [PRIMARY DISABILITY DESCRIPTION]
		,CASE
			WHEN [ENGLISH PROFICIENCY] = '0' THEN 'Never Enrolled'
			WHEN [ENGLISH PROFICIENCY] = '1' THEN 'Currently Enrolled'
			WHEN [ENGLISH PROFICIENCY] = '2' THEN 'Exited One Year'
			WHEN [ENGLISH PROFICIENCY] = '3' THEN 'Exited Two Years'
			WHEN [ENGLISH PROFICIENCY] = '4' THEN 'Exited Three + Years'
		END AS [ELL STATUS]
		,CAST(E.EXIT_DATE AS DATE) AS EXIT_DATE
		,STARS.[ECONOMIC STATUS /FOOD PGM PARTICIPATION/] AS FRPL_STATUS
		,EXPECTED_GRADUATION_YEAR
		,CONVERT(VARCHAR, GRADUATION_DATE,101) AS GRADUATION_DATE
		,CASE
			WHEN GRADUATION_STATUS = 1 THEN 'Fall Grad'
			WHEN GRADUATION_STATUS = 2 THEN 'Spring Grad'
			WHEN GRADUATION_STATUS = 3 THEN 'Summer Grad'
			WHEN GRADUATION_STATUS = 4 THEN 'Con''t SpEd HS'
			WHEN GRADUATION_STATUS = 5 THEN 'Con''t SpEd TranS'
			WHEN GRADUATION_STATUS = 6 THEN 'Graduated but Con''t SpEd HS'
			WHEN GRADUATION_STATUS = 7 THEN 'Graduated but Con''t Sped TranS'
		END AS GRADUATION_STATUS
	FROM
	[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]  AS STARS
	LEFT JOIN 
	rev.EPC_SCH AS SCH
	ON
	STARS.[LOCATION CODE] = SCH.STATE_SCHOOL_CODE
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
	ON
	BS.SIS_NUMBER = [ALTERNATE STUDENT ID]
	LEFT JOIN 
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') AS LU
	ON
	LU.VALUE_CODE = BS.PRIMARY_DISABILITY_CODE	
	LEFT JOIN 
	rev.EPC_STU_PGM_ELL e
	ON
	E.STUDENT_GU = BS.STUDENT_GU
	left join
	aps.ScheduleDetailsAsOf('2015-12-15') P
	on
	p.SIS_NUMBER = bs.SIS_NUMBER
	left join
	rev.EPC_STU grad
	on
	bs.STUDENT_GU = GRAD.student_gu	
	WHERE
	[Period] = '2015-12-15'
	AND [District Code] = '001'
	AND EXPECTED_GRADUATION_YEAR IN ('2015', '2016')
)
SELECT * FROM STUDENTCTE where rn = 1