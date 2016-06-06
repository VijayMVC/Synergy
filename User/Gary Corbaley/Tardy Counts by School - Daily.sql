

--SELECT
--	[SCHOOL_NAME]
--	,[SCHOOL_CODE]
--	,COUNT(ABS_DATE) AS [TOTAL_TARDIES]
--FROM
--	(
	SELECT 
		--SIS_NUMBER
		ORG.ORGANIZATION_NAME AS [SCHOOL_NAME]
		, [School].[SCHOOL_CODE]
		, ESAD.ABS_DATE
		, CASE
				WHEN ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T' THEN 'T'  
				WHEN ECAR.ABBREVIATION = 'ABS' THEN 'UX'
				--WHEN ECAR.ABBREVIATION = 'UF' THEN 'UF'
				WHEN ECAR.ABBREVIATION = 'UP' THEN 'UX'
				ELSE 'EX'END 
			AS [ABSENCE CODE]
		--, ECAR.ABBREVIATION  AS [ABSENCE CODE]
		--, S.STUDENT_GU
		--, SSY.STUDENT_SCHOOL_YEAR_GU
		, ESAD.DAILY_ATTEND_GU
		--,ESAD.*

	FROM 
		rev.EPC_STU_ATT_DAILY        AS ESAD
		INNER JOIN rev.EPC_STU_ATT_PERIOD AS ESAP ON ESAD.[DAILY_ATTEND_GU] = ESAP.[DAILY_ATTEND_GU]
		INNER  JOIN rev.EPC_STU_ENROLL           AS ESE    ON ESE.ENROLLMENT_GU                = ESAD.ENROLLMENT_GU 
		INNER  JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU       = ESE.STUDENT_SCHOOL_YEAR_GU 
		--INNER  JOIN rev.EPC_STU								AS S      ON S.STUDENT_GU = SSY.STUDENT_GU 
		INNER  JOIN rev.REV_ORGANIZATION_YEAR AS ORGYR ON SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
		INNER  JOIN rev.REV_ORGANIZATION AS ORG ON ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
		INNER  JOIN rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON ORG.[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]

		INNER  JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU    = ESAD.CODE_ABS_REAS1_GU 											
		AND ECARSY.ORGANIZATION_YEAR_GU     = ORGYR.ORGANIZATION_YEAR_GU 

		INNER  JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECARSY.CODE_ABS_REAS_GU             = ECAR.CODE_ABS_REAS_GU 

		INNER  JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = ORGYR.YEAR_GU 
		--This view only runs for the current school year and Regular Extension
		AND Y.SCHOOL_YEAR  = (2015)
		AND Y.EXTENSION  = 'R'

	WHERE
		--DAILY CONTAINS PERIOD TOO, SO EXCLUDE MID AND HIGH
		--ORGANIZATION_NAME LIKE '%Elementary%'
		--AND ESAD.ABS_DATE BETWEEN '08/13/2014' AND '02/11/2015'
		--AND 
		ESAD.ABS_DATE <= '05/25/2016'
		AND (ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T')
--	) AS [TARDIES]
	
--GROUP BY
--	[SCHOOL_NAME]
--	,[SCHOOL_CODE]
	
--ORDER BY
--	[SCHOOL_NAME]
	