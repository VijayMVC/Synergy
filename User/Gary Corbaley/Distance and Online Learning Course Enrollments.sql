

DECLARE @SchoolGu VARCHAR = '%'
DECLARE @AsOfDate DATETIME = GETDATE()
--DECLARE @Grade AS VARCHAR(2) = '%'

DECLARE @Distance AS VARCHAR(1) = 'Y'
DECLARE @Online AS VARCHAR(1) = 'Y'

SELECT
	[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[COURSE].[COURSE_TITLE]
	,[COURSE].[COURSE_ID]
	,[SCHEDULES].[SECTION_ID]
	,[SCHEDULES].[TERM_CODE]
	,[COURSE].[AP_INDICATOR]
	,[PERSON].[FIRST_NAME] + ' ' + [PERSON].[LAST_NAME] AS [STAFF_NAME]
	,[STUDENT].[SIS_NUMBER] AS [STUDENT_ID]
	,[STUDENT].[FIRST_NAME] + ' ' + [STUDENT].[LAST_NAME] AS [STUDENT_NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	
	,[COURSE].[DISTANCE_LEARNING]
	,[COURSE].[ONLINE_COURSE]
	
FROM
	APS.ScheduleAsOf(@AsOfDate) AS [SCHEDULES]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[SCHEDULES].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[SCHEDULES].[ENROLLMENT_GRADE_LEVEL] = [Grades].[VALUE_CODE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULES].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[SCHEDULES].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN
    rev.[EPC_STAFF] AS [STAFF]
    ON
    [SCHEDULES].[STAFF_GU] = [STAFF].[STAFF_GU]
    
    INNER JOIN
    rev.[REV_PERSON] AS [PERSON]
    ON
    [STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
	
WHERE
	[Organization].[ORGANIZATION_GU] LIKE @SchoolGu
	--AND [Grades].[VALUE_DESCRIPTION] LIKE @Grade

	AND
	(
	[COURSE].[DISTANCE_LEARNING]  = @Distance
	OR [COURSE].[ONLINE_COURSE] = @Online
	)
	
	--AND [COURSE].[COURSE_ID] LIKE '11013%'