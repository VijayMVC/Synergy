




SELECT DISTINCT
	CASE 
		WHEN [ENROLLMENT].[SCHOOL_CODE] = '416' THEN '350006000062'
		WHEN [ENROLLMENT].[SCHOOL_CODE] = '410' THEN '350006000056'
	END AS [SCHOOL NCES CODE]
	,[TEACHER_PERSON].[FIRST_NAME] AS [TEACHER FIRST]
	,[TEACHER_PERSON].[LAST_NAME] AS [TEACHER LAST]
	,[TEACHER_PERSON].[EMAIL] AS [TEACHER EMAIL]
	,'GTT_DM' AS [COURSE]
	,'08/13/2015' AS [COURSE BEGIN DATE]
	,'05/25/2016' AS [COURSE END DATE]
	,[STUDENT].[FIRST_NAME] AS [STUDENT FIRST NAME]
	,[STUDENT].[LAST_NAME] AS [STUDENT LAST NAME]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[ENROLLMENT].[GRADE] AS [STUDENT GRADE]
	,[STUDENT].[GENDER]
	,CONVERT(VARCHAR(10),[STUDENT].[BIRTH_DATE],101) AS [DOB]
	,CASE 
		WHEN [STUDENT].[RESOLVED_RACE] = 'Two or More' THEN '7'
		WHEN [STUDENT].[RACE_1] = 'African-American' THEN '1'
		WHEN [STUDENT].[RACE_1] = 'Asian' THEN '2'
		WHEN [STUDENT].[RACE_1] = 'Native American' THEN 3
		WHEN [STUDENT].[RACE_1] = 'White' THEN 5
		ELSE '6'
	END AS [RACE]
	,CASE WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN '1' ELSE '0' END AS [ETHNICITY]
	
	,[SCHEDULE].*
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN
	rev.REV_PERSON AS [TEACHER_PERSON]
	ON
	[SCHEDULE].[STAFF_GU] = [TEACHER_PERSON].[PERSON_GU]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE 
	[ENROLLMENT].[SCHOOL_CODE] IN ('410','416')
	AND [SCHEDULE].[COURSE_ID] = '50502'
	
	--AND [STUDENT].[STATE_STUDENT_NUMBER] = '342791274'