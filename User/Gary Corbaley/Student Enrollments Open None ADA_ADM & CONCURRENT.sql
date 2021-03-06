

DECLARE @Year INT = 2015
DECLARE @ADAADM INT = NULL

IF @ADAADM IS NULL
BEGIN
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,CONVERT(VARCHAR(10),[ENROLLMENTS].[ENTER_DATE],101) AS [ENTER_DATE]
	,CONVERT(VARCHAR(10),[ENROLLMENTS].[LEAVE_DATE],101) AS [LEAVE_DATE]
	,[ENROLLMENTS].[EXCLUDE_ADA_ADM]
	,[ENROLLMENTS].[CONCURRENT]
	,[ENROLLMENTS_16].[SCHOOL_YEAR] AS [SCHOOL_YEAR_NEXT]
	,[ENROLLMENTS_16].[SCHOOL_CODE] AS [SCHOOL_CODE_NEXT]
	,[ENROLLMENTS_16].[SCHOOL_NAME] AS [SCHOOL_NAME_NEXT]
	,CONVERT(VARCHAR(10),[ENROLLMENTS_16].[ENTER_DATE],101) AS [ENTER_DATE_NEXT]
	,CONVERT(VARCHAR(10),[ENROLLMENTS_16].[LEAVE_DATE],101) AS [LEAVE_DATE_NEXT]
	,[ENROLLMENTS_16].[EXCLUDE_ADA_ADM] AS [EXCLUDE_ADA_ADM_NEXT]
	,[ENROLLMENTS_16].[CONCURRENT] AS [CONCURRENT_NEXT]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS_16]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [ENROLLMENTS_16].[STUDENT_GU]
	AND [ENROLLMENTS].[SCHOOL_YEAR] + 1 = [ENROLLMENTS_16].[SCHOOL_YEAR]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = @Year
	--[ENROLLMENTS].[YEAR_GU] = @Year
	AND [ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
ORDER BY
	[STUDENT].[LAST_NAME]
END
IF ISNUMERIC(@ADAADM) = 1
BEGIN
SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,CONVERT(VARCHAR(10),[ENROLLMENTS].[ENTER_DATE],101) AS [ENTER_DATE]
	,CONVERT(VARCHAR(10),[ENROLLMENTS].[LEAVE_DATE],101) AS [LEAVE_DATE]
	,[ENROLLMENTS].[EXCLUDE_ADA_ADM]
	,[ENROLLMENTS].[CONCURRENT]
	,[ENROLLMENTS_16].[SCHOOL_YEAR] AS [SCHOOL_YEAR_NEXT]
	,[ENROLLMENTS_16].[SCHOOL_CODE] AS [SCHOOL_CODE_NEXT]
	,[ENROLLMENTS_16].[SCHOOL_NAME] AS [SCHOOL_NAME_NEXT]
	,CONVERT(VARCHAR(10),[ENROLLMENTS_16].[ENTER_DATE],101) AS [ENTER_DATE_NEXT]
	,CONVERT(VARCHAR(10),[ENROLLMENTS_16].[LEAVE_DATE],101) AS [LEAVE_DATE_NEXT]
	,[ENROLLMENTS_16].[EXCLUDE_ADA_ADM] AS [EXCLUDE_ADA_ADM_NEXT]
	,[ENROLLMENTS_16].[CONCURRENT] AS [CONCURRENT_NEXT]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENTS_16]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [ENROLLMENTS_16].[STUDENT_GU]
	AND [ENROLLMENTS].[SCHOOL_YEAR] + 1 = [ENROLLMENTS_16].[SCHOOL_YEAR]
	
WHERE
	[ENROLLMENTS].[SCHOOL_YEAR] = @Year
	--[ENROLLMENTS].[YEAR_GU] = @Year
	AND (@ADAADM = 3 OR [ENROLLMENTS].[EXCLUDE_ADA_ADM] = @ADAADM)
ORDER BY
	[STUDENT].[LAST_NAME]
END