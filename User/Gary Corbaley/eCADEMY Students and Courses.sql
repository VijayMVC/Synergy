



--/*
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[CONCURRENT]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[HISPANIC_INDICATOR]
	,[STUDENT].[RACE_1]
	,[STUDENT].[RACE_2]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[GENDER]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[GIFTED_STATUS]
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	AND ([ENROLLMENTS].[LEAVE_DATE] IS NULL
		OR
		'02/11/2015' BETWEEN [ENROLLMENTS].[ENTER_DATE] AND [ENROLLMENTS].[LEAVE_DATE])
		
	AND [ENROLLMENTS].[SCHOOL_CODE] = '517'
--*/
	
----------------------------------------------------------------------------------------	

/*	
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[CONCURRENT]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[GRADE]
	,[COURSE_HISTORY].[COURSE_ID]
	,[COURSE_HISTORY].[COURSE_TITLE]
	,[COURSE_HISTORY].[TERM_CODE]
	,[COURSE_HISTORY].[MARK]
	,[COURSE_HISTORY].[CREDIT_COMPLETED]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	ON
	[STUDENT].[STUDENT_GU] = [COURSE_HISTORY].[STUDENT_GU]
	AND [ENROLLMENTS].[SCHOOL_YEAR] = [COURSE_HISTORY].[SCHOOL_YEAR]
	AND [ENROLLMENTS].[ORGANIZATION_GU] = [COURSE_HISTORY].[SCHOOL_IN_DISTRICT_GU]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	--AND ([ENROLLMENTS].[LEAVE_DATE] IS NULL
	--	OR
	--	'02/11/2015' BETWEEN [ENROLLMENTS].[ENTER_DATE] AND [ENROLLMENTS].[LEAVE_DATE])
		
	AND [ENROLLMENTS].[SCHOOL_CODE] = '517'
	
--*/