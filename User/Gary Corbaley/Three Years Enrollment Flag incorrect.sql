

	
BEGIN TRAN

UPDATE rev.[EPC_STU]
	SET [ENROLL_LESS_THREE_OVR] = 'N'

FROM
	rev.[EPC_STU] AS [STUDENT]
	
	INNER JOIN
	(
	SELECT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[ENROLL_LESS_THREE_OVR]
		,[STUDENT].[STUDENT_GU]
	FROM	
		(	
		SELECT
			[STUDENT_GU]
			,COUNT([SCHOOL_YEAR]) AS [ENROLLMENT_YEARS]
		FROM
			(	
			SELECT DISTINCT
				[StudentSchoolYear].[STUDENT_GU]
				,[RevYear].[SCHOOL_YEAR]
			FROM
				rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
				
				INNER JOIN 
				rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
				ON 
				[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
				
				INNER JOIN 
				rev.REV_YEAR AS [RevYear] -- Contains the School Year
				ON 
				[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
					
			) AS [STUDENT_YEARS]

		GROUP BY
			[STUDENT_GU]
		) AS [STUDENT_YEARS_ENROLLED]
		
		INNER JOIN
		rev.[EPC_STU] AS [STUDENT]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[STUDENT_YEARS_ENROLLED].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
		FROM
			rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		) AS [LAST_ENROLLED_SSY]
		ON
		[STUDENT].[STUDENT_GU] = [LAST_ENROLLED_SSY].[STUDENT_GU]
		AND [LAST_ENROLLED_SSY].[RN] = 1
		
		LEFT JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[LAST_ENROLLED_SSY].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		LEFT JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		LEFT JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[LAST_ENROLLED_SSY].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[STUDENT_YEARS_ENROLLED].[ENROLLMENT_YEARS] = 3
		AND [STUDENT].[ENROLL_LESS_THREE_OVR] = 'Y'
		--AND [STUDENT].[SIS_NUMBER] = '970087794'
		AND [Grades].[VALUE_DESCRIPTION] = '04'
		
	) AS [MATCHED_FLAGS]
	ON
	[STUDENT].[STUDENT_GU] = [MATCHED_FLAGS].[STUDENT_GU]

ROLLBACK
	
	
	
--E11FC8A8-18EA-499B-8632-F95E94F4B06E