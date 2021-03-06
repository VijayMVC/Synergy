

/*
SELECT 
	[SY]
	,[Period]
	,[LOCATION CODE]
	,[STUDENT ID]
	,[LAST NAME LONG]
	,[FIRST NAME LONG]
	,[CURRENT GRADE LEVEL]
	,[HISPANIC INDICATOR]
	,[ETHNIC CODE SHORT]
	,[GENDER CODE]
	,[SPECIAL EDUCATION]
	,[STUDENT].[ELL_STATUS]
	
FROM
	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]
	
	LEFT JOIN
	APS.[BasicStudentWithMoreInfo] AS [STUDENT]
	ON
	[STUD_SNAPSHOT].[STUDENT ID] = [STUDENT].[STATE_STUDENT_NUMBER]
	
WHERE
	Period = '2015-03-01'
	AND [Location Code] = '517'
--*/



--/*
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]	
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[COURSE_HISTORY].[SCHOOL_YEAR]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[ENROLLMENTS].[CONCURRENT]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[COURSE_HISTORY].[COURSE_ID]
	,[COURSE_HISTORY].[COURSE_TITLE]
	,[COURSE_HISTORY].[TERM_CODE]
	,[COURSE_HISTORY].[MARK]
	
	--,[ENROLLMENTS].*
	
FROM
	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[STUD_SNAPSHOT].[STUDENT ID] = [STUDENT].[STATE_STUDENT_NUMBER]
	
	INNER JOIN
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	ON
	[STUDENT].[STUDENT_GU] = [COURSE_HISTORY].[STUDENT_GU]
	AND [COURSE_HISTORY].[SCHOOL_YEAR] = '2014'
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[COURSE_HISTORY].[SCHOOL_IN_DISTRICT_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	--APS.PrimaryEnrollmentDetailsAsOf('05/22/2015') 
	APS.StudentEnrollmentDetails
	AS [ENROLLMENTS]
	ON
	[COURSE_HISTORY].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [COURSE_HISTORY].[SCHOOL_IN_DISTRICT_GU] = [ENROLLMENTS].[ORGANIZATION_GU]
	--AND [ENROLLMENTS].[SCHOOL_CODE] = '517'
	AND [ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[COURSE_HISTORY].[GRADE] = [Grades].[VALUE_CODE]
	
WHERE
	Period = '2015-03-01'
	AND [Location Code] = '517'
	
ORDER BY
	[STUDENT].[STATE_STUDENT_NUMBER]
	
--*/