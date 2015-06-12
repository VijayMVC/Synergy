

;WITH
ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
)

-- From APS.BasicStudent
, STUDENT_DETAILS AS
(
SELECT
	-- Basic Student Demographics
	[STUDENT].[STUDENT_GU]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]
    
    ,[STUDENT].[HISPANIC_INDICATOR]
    ,[ETHNIC_CODES].[RACE_1]
    ,[ETHNIC_CODES].[RACE_2]
    ,[ETHNIC_CODES].[RACE_3]
    ,[ETHNIC_CODES].[RACE_4]
    ,[ETHNIC_CODES].[RACE_5]
    
    ,CASE 
		WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN 'Hispanic'
		WHEN [ETHNIC_CODES].[RACE_2] IS NOT NULL THEN 'Two or More'
		ELSE [ETHNIC_CODES].[RACE_1]
	END AS [RESOLVED_RACE]
    
    --,[PARENT_NAMES].[Parents]
    
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	-- Get All Racial Codes
	LEFT JOIN
	(
	SELECT
		[ETHNIC_PIVOT].[PERSON_GU]
		,[ETHNIC_PIVOT].[1] AS [RACE_1]
		,[ETHNIC_PIVOT].[2] AS [RACE_2]
		,[ETHNIC_PIVOT].[3] AS [RACE_3]
		,[ETHNIC_PIVOT].[4] AS [RACE_4]
		,[ETHNIC_PIVOT].[5] AS [RACE_5]
	FROM
		(
		SELECT
			[SECONDARY_ETHNIC_CODES].[PERSON_GU]
			,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
			,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
		) [PVT]
		PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]	
	
	
)

-----------------------------------------------------------------------------------------------------------------
-- MAIN


--/*
SELECT --TOP 100
	[STARS].[Period]
	,[STARS].[STUDENT ID]
	,[STARS].[LOCATION CODE]
	,[STARS].[FIRST NAME LONG]
	,[STARS].[LAST NAME LONG]
	,[STARS].[GENDER CODE]
	,[STARS].[HISPANIC INDICATOR]
	,[STARS].[ETHNIC CODE SHORT]
	,CASE 
		WHEN [STARS].[ETHNIC CODE SHORT] = 'C' THEN 1
		WHEN [STARS].[ETHNIC CODE SHORT] = 'I' THEN 100
		WHEN [STARS].[ETHNIC CODE SHORT] = 'B' THEN 600
		WHEN [STARS].[ETHNIC CODE SHORT] = 'A' THEN 299
		WHEN [STARS].[ETHNIC CODE SHORT] = 'P' THEN 399
	END AS [PRIMARY_RACE]
	,''
	,[STUDENT].*
	
	--,[ENROLLMENTS].[SCHOOL_CODE]
	--,[ENROLLMENTS].[SCHOOL_NAME]
	--,[STUDENT].[SIS_NUMBER]
	--,[STUDENT].[STATE_STUDENT_NUMBER]
	--,[STUDENT].[FIRST_NAME]
	--,[STUDENT].[LAST_NAME]
	--,[STUDENT].[GENDER]
	--,[STUDENT].[HISPANIC_INDICATOR]
	--,[STUDENT].[RACE_1]
	--,[STUDENT].[RACE_2]
	--,[STUDENT].[RACE_3]
	--,[STUDENT].[RACE_4]
	--,[STUDENT].[RACE_5]
	
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	 --AS [CURRENT_STUDENTS]	
	
	INNER JOIN
	(
	SELECT
		*
	FROM
		[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUDENT]
	WHERE
		[Period] LIKE '2014-06-01%'
	) AS [STARS]	
	ON
	[STARS].[STUDENT ID] = [STUDENT].[STATE_STUDENT_NUMBER]
	--AND [STARS].[Period] LIKE '2013-12%'
	
--WHERE
--	[CURRENT_STUDENTS].[RACE_2] IS NOT NULL
--*/

/*
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[GENDER]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[RACE_1] AS [PRIMARY_RACE]
FROM
	STUDENT_DETAILS AS [STUDENT]
	
WHERE
	[STUDENT].[RACE_2] IS NULL

--*/