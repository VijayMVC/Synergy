
	SELECT 
		'2013-2014' AS [SURVEY SCHOOL YEAR]
		,[Field13] AS [APS ID]
		,[STUDENT ID] AS [STATE ID]
		,SCH.SCHOOL_CODE AS [SCHOOL LOCATION CODE]
		,ORG.ORGANIZATION_NAME AS [SCHOOL NAME]
		,[Field11] AS [STUDENT GRADE LEVEL]
		,BS.GENDER
		,BS.HISPANIC_INDICATOR
		,BS.RACE_1
		,BS.RACE_2
		,BS.RACE_3
		,BS.RACE_4
		,BS.RACE_5
		,BS.RESOLVED_RACE
		,BS.ELL_STATUS
		,CASE WHEN FORMER_ELL.STUDENT_GU IS NOT NULL THEN 'Y' ELSE '' END AS FORMER_ELL
		,BS.PRIMARY_DISABILITY_CODE
		,LU.VALUE_DESCRIPTION AS [PRIMARY DISABILITY DESCRIPTION]
		,BS.SECONDARY_DISABILITY_CODE
		,LU2.VALUE_DESCRIPTION AS [SECONDARY DISABILITY DESCRIPTION]
		,STARS.[ECONOMIC STATUS /FOOD PGM PARTICIPATION/]

	FROM
	[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]  AS STARS
	INNER JOIN 
	rev.EPC_SCH AS SCH
	ON
	STARS.[Field12] = SCH.SCHOOL_CODE
	INNER JOIN 
	rev.REV_ORGANIZATION AS ORG
	ON
	ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
	ON
	BS.SIS_NUMBER = STARS.[Field13]
	LEFT JOIN 
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') AS LU
	ON
	LU.VALUE_CODE = BS.PRIMARY_DISABILITY_CODE
	
	LEFT JOIN 
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') AS LU2
	ON
	LU2.VALUE_CODE = BS.SECONDARY_DISABILITY_CODE

	LEFT JOIN 
	(SELECT * FROM 
rev.EPC_STU_PGM_ELL
WHERE
EXIT_DATE < '2013-08-01'
) AS FORMER_ELL
ON
FORMER_ELL.STUDENT_GU = BS.STUDENT_GU

	WHERE
	[Period] = '2013-10-01'
	AND [District Code] = '001'
