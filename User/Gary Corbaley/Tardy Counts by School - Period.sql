



SELECT
	[SCHOOL_NAME]
	,[SCHOOL_CODE]
	,COUNT([ABS_DATE]) AS [TOTAL]
FROM
	(
	SELECT
		ORG.ORGANIZATION_NAME AS [SCHOOL_NAME]
		,[sch].[SCHOOL_CODE]
		,[atd].[ABS_DATE]
		,[abr].[ABBREVIATION]
		,[abr].[DESCRIPTION]
		
	FROM
		[rev].[EPC_STU_ATT_DAILY] AS [atd]

		INNER JOIN
		[rev].[EPC_STU_ATT_PERIOD] AS [atp]
		ON
		[atd].[DAILY_ATTEND_GU]=[atp].[DAILY_ATTEND_GU]
	    
		LEFT JOIN
		[rev].[EPC_CODE_ABS_REAS_SCH_YR] AS [abry]
		ON
		[atp].[CODE_ABS_REAS_GU]=[abry].[CODE_ABS_REAS_SCH_YEAR_GU]

		LEFT JOIN
		[rev].[EPC_CODE_ABS_REAS] AS [abr]
		ON
		[abry].[CODE_ABS_REAS_GU]=[abr].[CODE_ABS_REAS_GU]

		INNER JOIN
		[rev].[EPC_STU_ENROLL] AS [enr]
		ON
		[atd].[ENROLLMENT_GU]=[enr].[ENROLLMENT_GU]
		AND [enr].[EXCLUDE_ADA_ADM] IS NULL

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [ssy]
		ON
		[enr].[STUDENT_SCHOOL_YEAR_GU]=[ssy].[STUDENT_SCHOOL_YEAR_GU]
		AND [ssy].[EXCLUDE_ADA_ADM] IS NULL

		INNER JOIN
		[rev].[REV_ORGANIZATION_YEAR] AS [oy]
		ON
		[ssy].[ORGANIZATION_YEAR_GU]=[oy].[ORGANIZATION_YEAR_GU]
	    
		INNER JOIN 
		rev.REV_ORGANIZATION AS ORG 
		ON [oy].ORGANIZATION_GU = ORG.ORGANIZATION_GU

		INNER JOIN
		[rev].[EPC_SCH] AS [sch]
		ON
		[oy].[ORGANIZATION_GU]=[sch].[ORGANIZATION_GU]

		INNER JOIN
		[APS].[YearDates] AS [yr]
		ON
		[oy].[YEAR_GU]=[yr].[YEAR_GU]
		AND ('05/25/2016' BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
		
	WHERE	 
		ISNUMERIC([abr].[ABBREVIATION]) = 1 OR [abr].[ABBREVIATION] = 'T'
	
	) AS [TARDIES]
	
GROUP BY
	[SCHOOL_NAME]
	,[SCHOOL_CODE]
	
ORDER BY
	[SCHOOL_NAME]