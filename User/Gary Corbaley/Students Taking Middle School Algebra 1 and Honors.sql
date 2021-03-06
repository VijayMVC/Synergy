




	SELECT
		[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[BIRTH_DATE]
		,[ENROLLMENTS].[GRADE]
		,[STUDENT].[GENDER]
		,[STUDENT].[HISPANIC_INDICATOR]
		,[STUDENT].[RESOLVED_RACE]
		,[STUDENT].[SPED_STATUS]
		,[STUDENT].[ELL_STATUS]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[TERM_CODE]
		,[PERSON].[FIRST_NAME] + ' ' + [PERSON].[LAST_NAME] AS [TEACHER_NAME]
		,RIGHT([STAFF].[BADGE_NUM],6) AS [STAFF_ID]
		
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[ENROLLMENTS].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		APS.[BasicStudentWithMoreInfo] AS [STUDENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
		
		INNER JOIN
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		ON
		[SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
	    
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
		
	WHERE
		[SCHEDULE].[COURSE_ID] IN ('31100','31200','3110B','3110D')
		AND [ENROLLMENTS].[GRADE] IN ('06','07','08')
		AND [ENROLLMENTS].[SCHOOL_YEAR] = '2015'
		AND [ENROLLMENTS].[EXTENSION] = 'R'
		AND [ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
		AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL
		AND [ENROLLMENTS].[LEAVE_DATE] IS NULL
		
	--) AS [STUDENTS]