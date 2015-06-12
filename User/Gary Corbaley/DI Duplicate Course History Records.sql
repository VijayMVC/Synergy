

SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,CASE WHEN [Organization].[ORGANIZATION_NAME] IS NULL THEN [NON_DST_SCHOOL].[NAME] ELSE [Organization].[ORGANIZATION_NAME] END AS [SCHOOL_NAME]
	,[COURSE_HISTORY_DUPLICATES].[SCHOOL_YEAR]
	,[COURSE_HISTORY_DUPLICATES].[COURSE_ID]
	,[COURSE_HISTORY_DUPLICATES].[COURSE_TITLE]
	,[COURSE].[DEPARTMENT]
	,[COURSE_HISTORY_DUPLICATES].[TERM_CODE]
	,[COURSE_HISTORY_DUPLICATES].[REPEAT_TAG_GU]
	,[COURSE_HISTORY_DUPLICATES].[MARK]
	,[COURSE_HISTORY_DUPLICATES].[COURSE_HISTORY_TYPE]
	
FROM
	rev.EPC_STU_CRS_HIS AS [COURSE_HISTORY_DUPLICATES]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[COURSE_HISTORY_DUPLICATES].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT] 
	ON
	[COURSE_HISTORY_DUPLICATES].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[COURSE_HISTORY_DUPLICATES].[SCHOOL_IN_DISTRICT_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	rev.EPC_SCH_NON_DST AS [NON_DST_SCHOOL]
	ON
	[COURSE_HISTORY_DUPLICATES].[SCHOOL_NON_DISTRICT_GU] = [NON_DST_SCHOOL].[SCHOOL_NON_DISTRICT_GU]
	
WHERE
	[SCHOOL_YEAR] = '2014'
--	[STUDENT].[SIS_NUMBER] = '970112082'
	
ORDER BY
	[STUDENT].[SIS_NUMBER]
	,[COURSE_HISTORY_DUPLICATES].[TERM_CODE]