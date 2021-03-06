



SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[GENDER]
	,[STUDENT].[LUNCH_STATUS]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	,CASE WHEN [AVID_STUDENTS].[GRADE] IS NOT NULL THEN 'Y' ELSE 'N' END AS [TOOK AT LEAST 1 AVID CLASS THIS YEAR]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT DISTINCT
		[SCHEDULE].[STUDENT_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	FROM
		-- Get full schedule
		APS.BasicSchedule AS [SCHEDULE]
		
		INNER JOIN
		-- Get Course details
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[COURSE].[COURSE_ID] IN ('55507','555071','555072','55508','555081','555082','555091','555092','555101','555102','555111','555112','555121','555122','55506E')
		--AND [SCHEDULE].[ORGANIZATION_GU] LIKE @School
		AND [RevYear].[SCHOOL_YEAR] = '2015'
		
	) AS [AVID_STUDENTS]
	ON
	[STUDENT].[STUDENT_GU] = [AVID_STUDENTS].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[SCHOOL_CODE] IN 
	('460',
	'416',
	'470',
	'413',
	'420',
	'427',
	'457',
	'410',
	'445',
	'405',
	'465',
	'407',
	'440',
	'425',
	'415',
	'475',
	'448',
	'450',
	'520',
	'530',
	'570',
	'560',
	'590',
	'514',
	'540',
	'576')
	


	