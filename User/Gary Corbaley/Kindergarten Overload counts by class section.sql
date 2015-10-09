







SELECT
	[SCHOOL_NAME]
	,[COURSE_ID]
	,[SECTION_ID]
	,[STAFF].[BADGE_NUM]
	,[STAFF_PERSON].[FIRST_NAME]
	,[STAFF_PERSON].[LAST_NAME]
	,[ASSIGNED_STAFF].[PRIMARY_TEACHER]
	,[STUDENT_COUNT]
	,[MAX_GRADE]
FROM
	(
	SELECT
		[SCHOOL_NAME]
		,[COURSE_ID]
		,[SECTION_ID]
		,[SECTION_GU]
		,COUNT([STUDENT_GU]) AS [STUDENT_COUNT]
		,MAX([LIST_ORDER]) AS [MAX_GRADE]
	FROM
		(
		SELECT
			[ENROLLMENT].[GRADE]
			,[ENROLLMENT].[LIST_ORDER]
			,[ENROLLMENT].[SCHOOL_NAME]
			,[SCHEDULE].[COURSE_ID]
			,[SCHEDULE].[SECTION_ID]
			,[SCHEDULE].[COURSE_TITLE]
			,[SCHEDULE].[SECTION_GU]
			,[SCHEDULE].[COURSE_GU]
			,[ENROLLMENT].[STUDENT_GU]
			--,[SCHEDULE].*
		FROM
			APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
			
			INNER JOIN
			APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
			ON
			[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
			AND [ENROLLMENT].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]		
			
		WHERE
			[SCHEDULE].[COURSE_ID] IN ('00004000','00008000','00014000','00018000','00052015','00056015')
		) AS [CLASSES]
		
	GROUP BY
		[SCHOOL_NAME]
		,[COURSE_ID]
		,[SECTION_ID]
		,[SECTION_GU]
	) AS [CLASS_COUNTS]
	
	LEFT OUTER JOIN
	APS.SectionsAndAllStaffAssigned AS [ASSIGNED_STAFF]
	ON
	[CLASS_COUNTS].[SECTION_GU] = [ASSIGNED_STAFF].[SECTION_GU]
	
	LEFT OUTER JOIN
	rev.EPC_STAFF AS [STAFF]
	ON
	[ASSIGNED_STAFF].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	LEFT OUTER JOIN
	rev.REV_PERSON AS [STAFF_PERSON]
	ON
	[ASSIGNED_STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
WHERE
	[MAX_GRADE] IN ('20','30')