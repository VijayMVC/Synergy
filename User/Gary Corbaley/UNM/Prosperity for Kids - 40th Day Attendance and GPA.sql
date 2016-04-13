


DECLARE @AsOfDate DATETIME = '10/14/2015'

SELECT --DISTINCT
	'2015-2016' AS [SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	--,[STUDENT].[BIRTH_DATE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	
	--,[UNEXCUSED].[Full Days Unexcused]
	--,[UNEXCUSED].[Half Days Unexcused]
	
	,[DAILY_ATTENDANCE].[Full-Day Excused]
	,[DAILY_ATTENDANCE].[Half-Day Excused]
	,CASE WHEN [DAILY_ATTENDANCE].[Full-Day Unexcused] IS NULL THEN [UNEXCUSED].[Full Days Unexcused] ELSE [DAILY_ATTENDANCE].[Full-Day Unexcused] END AS [Full-Day Unexcused]
	,CASE WHEN [DAILY_ATTENDANCE].[Half-Day Unexcused] IS NULL THEN [UNEXCUSED].[Half Days Unexcused] ELSE [DAILY_ATTENDANCE].[Half-Day Unexcused] END AS [Half-Day Unexcused]
	
	,[CUM_GPA].[MS Cum Flat]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, SCHOOL_YEAR ORDER BY ENTER_DATE DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
	WHERE
		SCHOOL_YEAR = '2015'
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
		AND ENTER_DATE IS NOT NULL
		AND (LEAVE_DATE IS NULL OR @AsOfDate BETWEEN ENTER_DATE AND LEAVE_DATE)
		AND ([GRADE] BETWEEN '01' AND '08' OR [GRADE] IN ('PK','K'))
	
	)  AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo  AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.DailyAttendanceAsOf(@AsOfDate) AS [DAILY_ATTENDANCE]
	ON
	[STUDENT].[SIS_NUMBER] = [DAILY_ATTENDANCE].[SIS_NUMBER]
	AND [ENROLLMENTS].[SCHOOL_CODE] = [DAILY_ATTENDANCE].[SCHOOL_CODE]
	
	LEFT OUTER JOIN
	APS.PeriodUnexcusedAsOf(@AsOfDate) AS [UNEXCUSED]
	ON
	[STUDENT].[SIS_NUMBER] = [UNEXCUSED].[SIS_NUMBER]
	
	LEFT OUTER JOIN
	APS.CumGPA AS [CUM_GPA]
	ON
	[STUDENT].[SIS_NUMBER] = [CUM_GPA].[SIS_NUMBER]
		
WHERE
	[ENROLLMENTS].[RN] = 1
	--AND [ENROLLMENTS].[SCHOOL_CODE] BETWEEN '100' AND '499'
	--AND ([ENROLLMENTS].[GRADE] BETWEEN '01' AND '08' OR [ENROLLMENTS].[GRADE] IN ('PK','K'))
	