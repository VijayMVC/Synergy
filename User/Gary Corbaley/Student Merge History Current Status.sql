




SELECT	
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[GRADE]
	,CONVERT(VARCHAR(10),[MERGE_HISTORY].[DATE_RUN],101) AS [DATE_RUN]
	,[MERGE_HISTORY].[OLD_PERM_ID]
	,[MERGE_HISTORY].[OLD_STATE_ID]
	,[MERGE_HISTORY].[REASON]
	,[MERGE_HISTORY].[USER_RAN]
	
FROM
	rev.UD_UD_EPC_STU_MERGE_HISTORY AS [MERGE_HISTORY]
	
	LEFT OUTER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[MERGE_HISTORY].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails 
		
	WHERE
		SCHOOL_YEAR <= 2015
		AND EXTENSION = 'R'
		--AND EXCLUDE_ADA_ADM IS NULL
	) AS [ENROLLMENTS]
	ON
	[MERGE_HISTORY].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]