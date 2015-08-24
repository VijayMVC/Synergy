

SELECT --DISTINCT
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	
	-- Get Counts by Birth Country
	-- /*
	,[BIRTH_COUNTRY]
	,[COUNTRY_DESCRIPTION]
	,COUNT([SIS_NUMBER]) AS [TOTAL]
	--*/
	
	-- Get Counts by Race
	/*
	,SUM(CASE WHEN [HISPANIC_INDICATOR] = 'Y' THEN 1 ELSE 0 END) AS [Hispanic]
	,SUM(CASE WHEN [RACE_1] = 'African-American' THEN 1 ELSE 0 END) AS [African-American]
	,SUM(CASE WHEN [RACE_1] = 'Asian' THEN 1 ELSE 0 END) AS [Asian]
	,SUM(CASE WHEN [RACE_1] = 'Native American' THEN 1 ELSE 0 END) AS [Native American]
	,SUM(CASE WHEN [RACE_1] = 'Pacific Islander' THEN 1 ELSE 0 END) AS [Pacific Islander]
	,SUM(CASE WHEN [RACE_1] = 'White' THEN 1 ELSE 0 END) AS [White]
	--*/
	
	
FROM
(
SELECT 
	[BASIC_STU].[SIS_NUMBER]
	,[BASIC_STU].[STATE_STUDENT_NUMBER]
	,[BASIC_STU].[FIRST_NAME]
	,[BASIC_STU].[LAST_NAME]
	,[BASIC_STU].[GENDER]
	,[BASIC_STU].[HISPANIC_INDICATOR]
	,[BASIC_STU].[RACE_1]
	,[BASIC_STU].[RACE_2]
	,[BASIC_STU].[RACE_3]
	,[BASIC_STU].[RACE_4]
	,[BASIC_STU].[RACE_5]
	,[STU].[BIRTH_COUNTRY]
	,[COUNTRY].[VALUE_DESCRIPTION] AS [COUNTRY_DESCRIPTION]
	,[STU].[BIRTH_COUNTY]
	,[STU].[BIRTH_STATE]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	
	,ROW_NUMBER() OVER (PARTITION BY [BASIC_STU].[SIS_NUMBER] ORDER BY [ENROLLMENTS].[ENTER_DATE] DESC) AS RN
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [BASIC_STU]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [BASIC_STU].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STU]
	ON
	[BASIC_STU].[STUDENT_GU] = [STU].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('Revelation','COUNTRY') AS [COUNTRY]
	ON
	[STU].[BIRTH_COUNTRY] = [COUNTRY].[VALUE_CODE]
	
WHERE
	[ENROLLMENTS].[SCHOOL_CODE] IN ('560','590','520','540','580','525')
	AND [ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
	AND [ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	
) AS [ENROLLMENTS]

WHERE
	RN = 1
	
GROUP BY
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	
	-- Get Counts by Birth Country
	-- /*
	,[BIRTH_COUNTRY]
	,[COUNTRY_DESCRIPTION]
	--*/