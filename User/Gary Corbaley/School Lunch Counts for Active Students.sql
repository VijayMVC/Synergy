



SELECT
	--[STUDENT].[SIS_NUMBER]
	--,[STUDENT].[FIRST_NAME]
	--,[STUDENT].[LAST_NAME]
	--,[STUDENT].[MIDDLE_NAME]
	--,[ENROLLMENTS].[GRADE]
	--,[ENROLLMENTS].[SCHOOL_CODE]
	--,[ENROLLMENTS].[SCHOOL_NAME]
	--,[STUDENT].[LUNCH_STATUS]
	
	[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,CASE WHEN [STUDENT].[LUNCH_STATUS] IS NULL THEN 'N' ELSE [STUDENT].[LUNCH_STATUS] END AS [LUNCH_STATUS]
	,COUNT([STUDENT].[SIS_NUMBER]) AS [TOTAL]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
GROUP BY
	[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[STUDENT].[LUNCH_STATUS]
	
ORDER BY
	[ENROLLMENTS].[SCHOOL_CODE]