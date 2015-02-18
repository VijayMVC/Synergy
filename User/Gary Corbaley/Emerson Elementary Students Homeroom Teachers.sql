


; WITH
-- From School of Record [EPC_STU_YR]
ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
)

-- From APS.BasicStudent
, STUDENT_DETAILS AS
(
SELECT
	-- Basic Student Demographics
	[STUDENT].[STUDENT_GU]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]	
	,[STUDENT].[HOME_ADDRESS] AS [HOME_ADDRESS]
	,[STUDENT].[HOME_ADDRESS_2] AS [HOME_ADDRESS_2]
	,[STUDENT].[HOME_CITY] AS [HOME_CITY]
	,[STUDENT].[HOME_STATE] AS [HOME_STATE]
	,[STUDENT].[HOME_ZIP] AS [HOME_ZIP]
	,[STUDENT].[MAIL_ADDRESS] AS [MAIL_ADDRESS]
	,[STUDENT].[MAIL_ADDRESS_2] AS [MAIL_ADDRESS_2]
	,[STUDENT].[MAIL_CITY] AS [MAIL_CITY]
	,[STUDENT].[MAIL_STATE] AS [MAIL_STATE]
	,[STUDENT].[MAIL_ZIP] AS [MAIL_ZIP]
    
FROM
	APS.BasicStudent AS [STUDENT]	
)

, SCHEDULE AS
(
	SELECT
		--[COURSE].*
		[SCHEDULE].*
		--,[COURSE].[COURSE_ID]
		--,[COURSE].[COURSE_TITLE]
		--,[SCHEDULE].[COURSE_ENTER_DATE]
		--,[SCHEDULE].[COURSE_LEAVE_DATE]
		--,[SCHEDULE].[SECTION_ID]
		--,[SCHEDULE].[TERM_CODE]
		,[COURSE].[DUAL_CREDIT]
		,[COURSE].[OTHER_PROVIDER_NAME]
		--,[COURSE].[CREDIT]
		--,[COURSE].[DEPARTMENT]
		--,[COURSE].[SUBJECT_AREA_1]
		--,[COURSE].[SUBJECT_AREA_2]
		--,[COURSE].[SUBJECT_AREA_3]
		--,[COURSE].[SUBJECT_AREA_4]
		--,[COURSE].[SUBJECT_AREA_5]
		
		--[ALL_STAFF_SCH_YR].*
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		,[STAFF].[BADGE_NUM]
		,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
	FROM
		--APS.BasicSchedule AS [SCHEDULE]
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		-- Get both primary and secodary staff
		INNER JOIN
		(
		SELECT
			[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_GU]
			,[ORGANIZATION_YEAR_GU]
			,1 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			
		UNION ALL
			
		SELECT
			[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_SCHOOL_YEAR].[STAFF_GU]
			,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
			,0 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
			
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		) AS [ALL_STAFF_SCH_YR]
		ON
	   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
	   
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
)

SELECT
	[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[MAIL_ADDRESS]
	--,[STUDENT].[MAIL_ADDRESS_2]
	,[STUDENT].[MAIL_CITY]
	,[STUDENT].[MAIL_STATE]
	,[STUDENT].[MAIL_ZIP]
	,[SCHEDULE].[TEACHER NAME]
	,REPLACE([SCHEDULE].[BADGE_NUM],'e','') AS [STAFF_ID]

	--,[ENROLLMENTS].*
	--,[STUDENT].*
	--,[SCHEDULE].[TEACHER NAME]
	--,[SCHEDULE].[PRIMARY_STAFF]
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	STUDENT_DETAILS AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	SCHEDULE AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.[EPC_SCH_YR_SECT] AS [SECTION]
	ON
	[SCHEDULE].[SECTION_GU] = [SECTION].[SECTION_GU]
	
WHERE
	--[ENROLLMENTS].[SCHOOL_NAME] LIKE '%Emer%'
	[ENROLLMENTS].[SCHOOL_CODE] = '255'
	AND [SECTION].[PERIOD_BEGIN] = 1