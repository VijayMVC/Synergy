



--SELECT TOP 100
--	*
--FROM
--	rev.EPC_VACCINATION_DEF
	--rev.EPC_STU_IMM_DOSAGE
	--rev.EPC_STU_IMM_VACCINE
	

SELECT --TOP 10000
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],GETDATE()) / 12 AS [AGE]
	,[StudentSchoolYear].[STUDENT_GU]
	--,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	--,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	--,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	--,[StudentSchoolYear].[ENTER_DATE]
	--,[StudentSchoolYear].[LEAVE_DATE]
	--,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	--,[StudentSchoolYear].[ACCESS_504]
	--,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
	--	WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
	--	ELSE '' END AS [CONCURRENT]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	

	
	,[VACCINATIONS].*
	
	,[VACCINATIONS].[VACCINATION_NAME] AS [RULE_1_TYPE]
	,[VACCINATIONS].[EXEMPT] AS [RULE_2_EXEMPT]
	,DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) AS [RULE_3_FIRST_DOSAGE_MONTHS]
	,DATEDIFF(WEEK,[VACCINATIONS].[DOSAGE_1],[VACCINATIONS].[DOSAGE_2]) AS [RULE_4_SECOND_DOSAGE_WEEKS]
	,DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) AS [RULE_5_FIRST_DOSAGE_AGE]
	,DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_2]) AS [RULE_6_SECOND_DOSAGE_AGE]
	
	,CASE 
		  -- STUDENTS UNDER AGE 4 AND ONLY ONE DOSAGE
		  WHEN (DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],GETDATE()) / 12) < 4				-- AGE LESS THAN 4
		  AND DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) >= 12	-- FIRST DOSAGE AFTER 12 MONTHS
		  AND [VACCINATIONS].[DOSAGE_2] IS NULL											-- SECOND DOSAGE
		  THEN 'COMPLIANT'
		  
		  -- STUDENTS UNDER AGE 4 WITH TWO DOSAGES
		  WHEN (DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],GETDATE()) / 12) < 4				-- AGE LESS THAN 4
		  AND DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) >= 12	-- FIRST DOSAGE AFTER 12 MONTHS
		  AND DATEDIFF(WEEK,[VACCINATIONS].[DOSAGE_1],[VACCINATIONS].[DOSAGE_2]) >= 4	-- SECOND DOSAGE NO SOONER THAN 4 WEEKS
		  THEN 'COMPLIANT'
		  
		  -- STUDENTS AGE 4 AND OLDER
		  WHEN (DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],GETDATE()) / 12) >= 4				-- AGE GREATER THAN OR EQUAL TO 4 
		  AND DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) >= 12	-- FIRST DOSAGE AFTER 12 MONTHS
		  AND DATEDIFF(WEEK,[VACCINATIONS].[DOSAGE_1],[VACCINATIONS].[DOSAGE_2]) >= 4	-- SECOND DOSAGE NO SOONER THAN 4 WEEKS
		  AND (DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) / 12) < 4		-- FIRST DOSAGE BEFORE AGE 4
		  --AND DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_2]) >= 4
		  --AND (DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],GETDATE()) >= 4 AND [VACCINATIONS].[DOSAGE_2] IS NOT NULL)
		  THEN 'COMPLIANT'
		   
		  WHEN [VACCINATIONS].[EXEMPT] IS NOT NULL THEN 'EXEMPT'
		  END AS [RULE_7]
		  
	,CASE WHEN DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) < 12	-- FIRST DOSAGE UNDER 12 MONTHS
		  OR DATEDIFF(WEEK,[VACCINATIONS].[DOSAGE_1],[VACCINATIONS].[DOSAGE_2]) < 4		-- SECOND DOSAGE WITHIN 4 WEEKS
		  OR DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_1]) >= 4		-- FIRST DOSAGE AFTER AGE 4
		  --OR DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],[VACCINATIONS].[DOSAGE_2]) < 4
		  OR [VACCINATIONS].[DOSAGE_1] IS NULL											-- NO FIRST DOSAGE
		  OR (DATEDIFF(YEAR,[STUDENT].[BIRTH_DATE],GETDATE()) >= 4 AND [VACCINATIONS].[DOSAGE_2] IS NULL) -- NO SECOND DOSAGE AFTER AGE 4
		  THEN 'NOT COMPLIANT'
		   
		  WHEN [VACCINATIONS].[EXEMPT] IS NOT NULL THEN 'EXEMPT'
		  END AS [RULE_8]
		
	
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
	--------------------------------------------------------------
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	---------------------------------------------------------------
	LEFT OUTER JOIN
	--APS.StudentImmunizations AS [VACCINATIONS]
	(
	SELECT
		[VAC_DOSAGES].[STUDENT_GU]
		,[VAC_DOSAGES].[VACCINATION_NAME]
		,[VAC_DOSAGES].[EXEMPT]
		,[VAC_DOSAGES].[EXEMPT REASON]
		,[VAC_DOSAGES].[EXEMPT_GRANTED]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 1 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_1]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 2 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_2]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 3 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_3]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 4 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_4]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 5 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_5]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 6 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_6]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 7 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_7]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 8 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_8]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 9 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_9]
		,MAX(CASE WHEN [VAC_DOSAGES].[RN] = 10 THEN [VAC_DOSAGES].[IMMUNIZATION_DATE] END) AS [DOSAGE_10]
		
	FROM
		(
		SELECT
			[VACCINE].[STUDENT_GU]
			,[DOSAGE].[IMMUNIZATION_DATE]
			,[VACCINATION_DEF].[VACCINATION_NAME]
			,[VACCINE].[EXEMPT]
			,[EXEMPTIONS].[VALUE_DESCRIPTION] AS [EXEMPT REASON]
			,[VACCINE].[EXEMPT_GRANTED]
			,ROW_NUMBER() OVER (PARTITION BY [VACCINE].[STUDENT_GU], [VACCINATION_DEF].[VACCINATION_NAME] ORDER BY [DOSAGE].[IMMUNIZATION_DATE]) [RN]
		FROM	
			rev.[EPC_STU_IMM_VACCINE] AS [VACCINE]
			
			INNER JOIN
			rev.[EPC_STU_IMM_DOSAGE] AS [DOSAGE]
			ON
			[VACCINE].[STU_IMM_VACCINE_GU] = [DOSAGE].[STU_IMM_VACCINE_GU]
			
			LEFT OUTER JOIN
			rev.[EPC_VACCINATION_DEF] AS [VACCINATION_DEF]
			ON
			[VACCINE].[VACCINATION_DEF_GU] = [VACCINATION_DEF].[VACCINATION_DEF_GU]
			
			LEFT OUTER JOIN
			APS.LookupTable('K12.VaccinationInfo','Exemptions') AS [EXEMPTIONS]
			ON
			[VACCINE].[EXEMPT] = [EXEMPTIONS].[VALUE_CODE]
			
		) AS [VAC_DOSAGES]	
		
	GROUP BY
		[VAC_DOSAGES].[STUDENT_GU]
		,[VAC_DOSAGES].[VACCINATION_NAME]
		,[VAC_DOSAGES].[EXEMPT]
		,[VAC_DOSAGES].[EXEMPT REASON]
		,[VAC_DOSAGES].[EXEMPT_GRANTED]
	) AS [VACCINATIONS]
	ON
	[Enrollments].[STUDENT_GU] = [VACCINATIONS].[STUDENT_GU]
	AND [VACCINATIONS].[VACCINATION_NAME] = 'MMR'
	
	
	
WHERE
--	[Grades].[VALUE_DESCRIPTION] IN ('K','PK')
	
	--AND [VACCINATIONS].[VACCINATION_NAME] = 'Measles'	
	
	(DATEDIFF(MONTH,[STUDENT].[BIRTH_DATE],GETDATE()) / 12) <= 4
	--AND [VACCINATIONS].[DOSAGE_2] IS NOT NULL
	
	--AND [STUDENT].[SIS_NUMBER] = '980009277'