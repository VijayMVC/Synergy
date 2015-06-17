



SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[HISPANIC_INDICATOR]
	,[STUDENT].[RACE_1]
	,[STUDENT].[RACE_2]
	,[STUDENT].[RACE_3]
	,[STUDENT].[RACE_4]
	,[STUDENT].[RACE_5]
	,[STUDENT].[GENDER]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[STUDENT].[LUNCH_STATUS]
	,[STUDENT].[ELL_STATUS]
	,[LCE].[TEST_NAME]
	,[LCE].[ADMIN_DATE]
	,[LCE].[VALUE_DESCRIPTION] AS [PROFICIENCY LEVEL]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[PRIMARY_DISABILITY_CODE]
	,[STUDENT].[GIFTED_STATUS]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	,[ENROLLMENTS].[GRADE]
	,[STUDENT].[CLASS_OF]
	
	,[CUM_GPA].[HS Cum Flat]
	,[CUM_GPA].[HS Cum Weighted]
	,[CUM_GPA].[MS Cum Flat]
	
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [ENROLLMENTS].[STUDENT_GU] ORDER BY [ENROLLMENTS].[ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		
	WHERE
		[ENROLLMENTS].[ENTER_DATE] IS NOT NULL
		AND [ENROLLMENTS].[SCHOOL_YEAR] = '2012'
		AND [ENROLLMENTS].[EXTENSION] = 'R'
	) AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(	
	SELECT 
	STUDENT_GU
	,TEST_NAME
	,PERFORMANCE_LEVEL
	,VALUE_DESCRIPTION 
	,ADMIN_DATE
	,ROW_NUMBER() OVER (PARTITION BY [LCE].[STUDENT_GU] ORDER BY [LCE].[ADMIN_DATE] DESC) AS RN
	FROM 
	APS.LCELatestEvaluationAsOf('2013-05-20') AS LCE
	INNER JOIN 
	APS.LookupTable ('K12.TestInfo', 'PERFORMANCE_LEVELS') AS GR
	ON
	LCE.PERFORMANCE_LEVEL = GR.VALUE_CODE
	) AS [LCE]
	ON
	[STUDENT].[STUDENT_GU] = [LCE].[STUDENT_GU]
	AND [LCE].[RN] = 1
	--AND [LCE].[ADMIN_DATE] BETWEEN '2012-08-13' AND '2013-05-20'
	
	LEFT OUTER JOIN
	(
	SELECT DISTINCT
		[GPA].[STUDENT_SCHOOL_YEAR_GU]
		
		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCF' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Flat]
		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'HSCW' THEN [GPA].[GPA] ELSE 0 END) AS [HS Cum Weighted]
		,SUM(CASE WHEN [GPA_DEF].[GPA_CODE] = 'MSCF' THEN [GPA].[GPA] ELSE 0 END) AS [MS Cum Flat]
		
	FROM	
		rev.[EPC_STU_GPA] AS [GPA]  
			
		INNER JOIN
		rev.[EPC_SCH_YR_GPA_TYPE_RUN] [GPA_RUN]
		ON
		[GPA].[SCHOOL_YEAR_GPA_TYPE_RUN_GU] = [GPA_RUN].[SCHOOL_YEAR_GPA_TYPE_RUN_GU]
		AND [GPA_RUN].[SCHOOL_YEAR_GRD_PRD_GU] IS NULL
		
		INNER JOIN
		rev.[EPC_GPA_DEF_TYPE] [GPA_TYPE] 
		ON 
		[GPA_RUN].[GPA_DEF_TYPE_GU] = [GPA_TYPE].[GPA_DEF_TYPE_GU]
		AND (
			[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Flat' 
			OR
			[GPA_TYPE].[GPA_TYPE_NAME] = 'HS Cum Weighted' 
			OR
			[GPA_TYPE].[GPA_TYPE_NAME] = 'MS Cum Flat'
			)
				
		INNER JOIN 
		rev.[EPC_GPA_DEF] [GPA_DEF]  
		ON 
		[GPA_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
		
	GROUP BY
		[GPA].[STUDENT_SCHOOL_YEAR_GU]
	) AS [CUM_GPA]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [CUM_GPA].[STUDENT_SCHOOL_YEAR_GU]
	
WHERE
	[ENROLLMENTS].[RN] = 1