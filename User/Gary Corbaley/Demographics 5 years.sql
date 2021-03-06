



SELECT
	'2014-2015' AS [SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	,[STUDENT].[GENDER]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[PRIMARY_DISABILITY_CODE]
	,[CurrentSPED].[SECONDARY_DISABILITY_CODE]
	,[STUDENT].[LUNCH_STATUS]
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, SCHOOL_YEAR ORDER BY ENTER_DATE DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
	WHERE
		SCHOOL_YEAR = '2014'
		AND EXTENSION = 'R'
		AND EXCLUDE_ADA_ADM IS NULL
		AND ENTER_DATE IS NOT NULL	
	)  AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                            )
	) AS [CurrentSPED]
    ON
    [STUDENT].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]
	
--WHERE
--	[ENROLLMENTS].[RN] = 1