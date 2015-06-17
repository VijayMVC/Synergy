



SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	
	,[COURSE_HISTORY].[COURSE_ID]
	,[COURSE_HISTORY].[COURSE_TITLE]
	,[COURSE].[DEPARTMENT]
	,[COURSE_HISTORY].[TERM_CODE]
	,[COURSE_HISTORY].[MARK] AS [GRADE]
	,'COURSE HISTORY/TRANSCRIPT' AS [TYPE]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [ENROLLMENTS].[STUDENT_GU] ORDER BY [ENROLLMENTS].[ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		
	WHERE
		[ENROLLMENTS].[ENTER_DATE] IS NOT NULL
		AND [ENROLLMENTS].[SCHOOL_YEAR] = '2012'
		AND [ENROLLMENTS].[EXTENSION] = 'R'
	) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [COURSE_HISTORY].[STUDENT_GU]
	AND [COURSE_HISTORY].[SCHOOL_YEAR] = '2012'
	
	LEFT OUTER JOIN
	-- Get Course details
	rev.EPC_CRS AS [COURSE]
	ON
	[COURSE_HISTORY].[COURSE_GU] = [COURSE].[COURSE_GU]
	
WHERE
	[ENROLLMENTS].[RN] = 1
	
ORDER BY
	[STUDENT].[SIS_NUMBER]