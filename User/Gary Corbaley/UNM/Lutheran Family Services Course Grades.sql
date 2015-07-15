



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STATE_STUDENT_NUMBER]
		,'2014-R' AS [SCHOOL_YEAR]
		
		,[COURSE_HISTORY].[TERM_CODE]
		,[COURSE_HISTORY].[COURSE_ID]
		,[COURSE_HISTORY].[COURSE_TITLE]
		,[COURSE].[DEPARTMENT]		
		,[COURSE_HISTORY].[MARK] AS [GRADE]
		,'COURSE HISTORY/TRANSCRIPT' AS [TYPE]			
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Lutheran_Family_Services_2014.csv' 
		)AS [FILE]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[FILE].[APS ID] = [STUDENT].[SIS_NUMBER]
		
		--INNER JOIN
		--(
		--SELECT
		--	*
		--	,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, SCHOOL_YEAR ORDER BY ENTER_DATE DESC) AS RN
		--FROM
		--	APS.[StudentEnrollmentDetails]
		--WHERE
		--	SCHOOL_YEAR = '2014'
		--	AND EXTENSION = 'R'
		
		--)  AS [ENROLLMENT]
		--ON
		--[STUDENT].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
		--AND [ENROLLMENT].[RN] = 1
		
		INNER JOIN
		rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
		ON
		[STUDENT].[STUDENT_GU] = [COURSE_HISTORY].[STUDENT_GU]
		AND [COURSE_HISTORY].[SCHOOL_YEAR] = '2014'
		
		LEFT OUTER JOIN
		-- Get Course details
		rev.EPC_CRS AS [COURSE]
		ON
		[COURSE_HISTORY].[COURSE_GU] = [COURSE].[COURSE_GU]
		
REVERT
GO