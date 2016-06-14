
DECLARE @AsOfDate DATETIME = GETDATE()

SELECT
	[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[PRIMARY_DISABILITY_CODE]
	,[STU].[EXPECTED_GRADUATION_YEAR]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[SCHEDULE].[PERIOD_BEGIN]
	,[SCHEDULE].[PERIOD_END]
	,[SCHEDULE].[TERM_CODE]
	,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
	,CASE WHEN [PRIMARY_ENROLLMENT].[SCHOOL_NAME] IS NULL THEN [Enrollments].[SCHOOL_NAME] ELSE [PRIMARY_ENROLLMENT].[SCHOOL_NAME] END AS [HOME_SCHOOL_LOCATION]
	,CASE WHEN [PRIMARY_ENROLLMENT].[GRADE] IS NULL THEN [Enrollments].[GRADE] ELSE [PRIMARY_ENROLLMENT].[GRADE] END AS [HOME_GRADE]
	,[Enrollments].[SCHOOL_NAME] AS [COURSE_LOCATION]
	,[Enrollments].[GRADE] AS [CONCURRENT_GRADE]
	,[Enrollments].[EXCLUDE_ADA_ADM] AS [ADA/ADM CODE]
	,CASE WHEN [Enrollments].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [Enrollments].[EXCLUDE_ADA_ADM] = 1 THEN 'NON ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	
	
	,[GRADES].[1st 6 Wk]
	,[GRADES].[2nd 6 Wk]
	,[GRADES].[3rd 6 Wk]
	,[GRADES].[4th 6 Wk]
	,[GRADES].[5th 6 Wk]
	,[GRADES].[S1 Exam]
	,[GRADES].[S1 Grade]
	,[GRADES].[S2 Exam]
	,[GRADES].[S2 Grade]
	
FROM
	(
	SELECT
		[ENROLLMENT].*
		,ROW_NUMBER() OVER(PARTITION BY [ENROLLMENT].[STUDENT_GU] order by [ENROLLMENT].[ENTER_DATE]) AS [RN]
	FROM
		APS.YearDates AS [YEARDATES]
		
		INNER JOIN
		APS.StudentEnrollmentDetails AS [ENROLLMENT]
		ON
		[YEARDATES].[YEAR_GU] = [ENROLLMENT].[YEAR_GU]
		
	WHERE
		@AsOfDate BETWEEN YearDates.START_DATE AND YearDates.END_DATE
		AND @AsOfDate BETWEEN Enrollment.ENTER_DATE AND COALESCE(Enrollment.LEAVE_DATE, YearDates.END_DATE)
		AND [ENROLLMENT].[SCHOOL_CODE] IN ('517','592','701','702')
		AND [ENROLLMENT].[EXCLUDE_ADA_ADM] IS NOT NULL		
	) AS [Enrollments]
	
	INNER HASH JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU [STU]
	ON
	[Enrollments].[STUDENT_GU] = [STU].[STUDENT_GU]
	
	INNER JOIN
	APS.BasicSchedule AS [SCHEDULE]
	ON
	[Enrollments].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [Enrollments].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	LEFT JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]

	LEFT JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
	LEFT OUTER JOIN
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS [PRIMARY_ENROLLMENT]
	ON
	[Enrollments].[STUDENT_GU] = [PRIMARY_ENROLLMENT].[STUDENT_GU]
	
	LEFT HASH JOIN
	(
	SELECT
		*
	FROM
		(
		SELECT 
			[STUDENT_SCHOOL_YEAR_GU]
			,[SECTION_GU]
			,[GRADE_PERIOD]
			,[MARK]
		FROM
			APS.StudentGrades
		) [GRADE_PERIODS]
		PIVOT (MAX([MARK]) FOR [GRADE_PERIOD] IN ([1st 6 Wk],[2nd 6 Wk],[3rd 6 Wk],[4th 6 Wk],[5th 6 Wk],[S1 Exam],[S1 Grade],[S2 Exam],[S2 Grade])) AS [GRADES_PIVOT]
	) AS [GRADES]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [GRADES].[STUDENT_SCHOOL_YEAR_GU]
	AND [SCHEDULE].[SECTION_GU] = [GRADES].[SECTION_GU]
	
WHERE
	[Enrollments].[SCHOOL_CODE] LIKE @School