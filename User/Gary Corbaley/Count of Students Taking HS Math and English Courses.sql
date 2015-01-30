

DECLARE @CourseListMath TABLE(
            COURSE_ID VARCHAR(9)
            ,COURSE_GROUP VARCHAR(3)
)


INSERT INTO @CourseListMath
VALUES
('330400','ALG')
,('330401','ALG')
,('330402','ALG')
,('330403','ALG')
,('330471','ALG')
,('330472','ALG')
,('330801','ALG')
,('330802','ALG')
,('330811','ALG')
,('330812','ALG')
,('3304000','ALG')
,('060C41','ALG')
,('060C42','ALG')
,('061C1','ALG')
,('061C11','ALG')
,('061C12','ALG')
,('061C41','ALG')
,('061C42','ALG')
,('061C51','ALG')
,('061C52','ALG')
,('062C11','ALG')
,('062C12','ALG')
,('33040C','ALG')
,('33040C1','ALG')
,('33040C2','ALG')
,('33040DE1','ALG')
,('33040DE2','ALG')
,('33040DI1','ALG')
,('33040DI2','ALG')
,('3304A1','ALG')
,('3304A2','ALG')
,('MATH322','ALG')

,('3603B1','AL2')
,('3603B2','AL2')
,('36040DI2','AL2')
,('360401','AL2')
,('360402','AL2')
,('360403','AL2')
,('062C21','AL2')
,('062C22','AL2')
,('36040C','AL2')
,('36040C1','AL2')
,('36040C2','AL2')
,('36040DE1','AL2')
,('36040DE2','AL2')
,('3604A1','AL2')
,('3604A2','AL2')
,('360350','AL2')
,('360351','AL2')
,('360352','AL2')
,('3603500','AL2')
,('060C71','AL2')
,('060C72','AL2')
,('061C71','AL2')
,('061C72','AL2')
,('062D11','AL2')
,('062D12','AL2')
,('36035DE1','AL2')
,('36035DE2','AL2')
,('360801','AL2')
,('360802','AL2')
,('MATH421','AL2')
,('MATH2810','AL2')
,('MATH312 ','AL2')

,('350401','GEO')
,('350402','GEO')
,('350403','GEO')
,('350801','GEO')
,('350802','GEO')
,('060C61','GEO')
,('060C62','GEO')
,('061C31','GEO')
,('061C32','GEO')
,('062C31','GEO')
,('062C32','GEO')
,('35040C','GEO')
,('35040C1','GEO')
,('35040C2','GEO')
,('35040DE1','GEO')
,('35040DE2','GEO')
,('35040DI1','GEO')
,('35040DI2','GEO')
,('3504A1','GEO')
,('3504A2','GEO')

SELECT
	[COURSE_TITLE]
	,[COURSE_ID]
	
	,[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,COUNT([SIS_NUMBER]) AS [STUDENT_COUNT]
FROM
(
SELECT DISTINCT
	[COURSE].[COURSE_TITLE]
	,[COURSE].[COURSE_ID]
	,[SCHEDULE].[SECTION_ID]
	,CASE WHEN (SELECT [COURSE_LIST].[COURSE_GROUP] FROM @CourseListMath AS [COURSE_LIST] WHERE [COURSE_LIST].[COURSE_ID] = [COURSE].[COURSE_ID]) IS NULL THEN [COURSE].[SUBJECT_AREA_1] ELSE (SELECT [COURSE_LIST].[COURSE_GROUP] FROM @CourseListMath AS [COURSE_LIST] WHERE [COURSE_LIST].[COURSE_ID] = [COURSE].[COURSE_ID]) END AS [COURSE_GROUP]
	,[SCHEDULE].[TERM_CODE]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
FROM 
	APS.ScheduleAsOf('03/01/2015') AS [SCHEDULE]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[SCHEDULE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[COURSE].[COURSE_ID] IN (SELECT [COURSE_ID] FROM @CourseListMath)
	OR
	[COURSE].[SUBJECT_AREA_1] IN ('E09','E10','E11')
	
) AS [STUDENT_COURSES]

GROUP BY
	[COURSE_TITLE]
	,[COURSE_ID]
	,[SCHOOL_CODE]
	,[SCHOOL_NAME]
	
ORDER BY
	[SCHOOL_CODE]