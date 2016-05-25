




SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME] AS [STUDENT FIRST NAME]
	,[STUDENT].[FIRST_NAME] AS [STUDENT LAST NAME]
	,[STUDENT].[GENDER] AS [STUDENT GENDER]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[LUNCH_STATUS]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[PRIMARY_DISABILITY_CODE]
	,[ENROLLMENTS].[GRADE] AS [GRADE_LEVEL]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[EXTENSION]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	
	,[DISTRICT_COURSE].[COURSE_ID] AS [SUMMER COURSE]
	,[DISTRICT_COURSE].[STATE_COURSE_CODE]
	,[SCHEDULE].[SECTION_ID] --AS [SUMMER SECTION]
	,[SCHEDULE].[TERM_CODE]
	,[DISTRICT_COURSE].[COURSE_TITLE] --AS [SUMMER COURSE NAME]
	,[DISTRICT_COURSE].[DEPARTMENT] --AS [SUMMER DEPARTMENT]
	
	,[K3+] = CASE WHEN [ENROLLMENTS].[EXTENSION] IN ('S','N') AND [SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' THEN '1' ELSE '0' END
    ,[StartSmart] = CASE WHEN [ENROLLMENTS].[EXTENSION] IN ('S','N') AND [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999' THEN '1' ELSE '0' END
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	LEFT OUTER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.BasicSchedule AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]
	AND ([SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' OR [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999')
	AND [ENROLLMENTS].[EXTENSION] IN ('S','N')
	
	LEFT OUTER JOIN
	rev.[EPC_CRS] AS [DISTRICT_COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [DISTRICT_COURSE].[COURSE_GU]

WHERE
	--[ENROLLMENTS].[SCHOOL_YEAR] = 2014
	[ENROLLMENTS].[GRADE] IN ('K','01','02','03','04','05','06','07','08')
	AND ([ENROLLMENTS].[SCHOOL_YEAR] = 2015 AND [ENROLLMENTS].[EXTENSION] = 'N')
	--AND ([ENROLLMENTS].[SCHOOL_YEAR] = 2013 AND [ENROLLMENTS].[EXTENSION] = 'S')
	