



EXECUTE AS LOGIN='QueryFileUser'
GO

;WITH
PERIOD_ATTENDANCE AS
(
SELECT
	-- GROUP DAILY TOTALS BY ABSENCE TYPE
	[STUDENT_GU]
	,SUM(CASE WHEN [ABSENCE CODE] = 'UX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'PERIOD UNEXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'EX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'PERIOD EXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'T' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'PERIOD TARDY'
FROM
	(
	SELECT
		[STUDENT_GU]
		-- GET PERIOD TOTALS
		,COUNT([BELL_PERIOD]) AS [ABSENCE PERIODS]
		,[ABSENCE CODE]
	FROM	
		(
		SELECT 
			SIS_NUMBER
			, ORG.ORGANIZATION_NAME
			, ESAD.ABS_DATE
			, BELL_PERIOD
			, CASE
				WHEN ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T' THEN 'T'  
				WHEN ECAR.ABBREVIATION = 'ABS' THEN 'UX'
				ELSE 'EX'END 
			AS [ABSENCE CODE]
			--,ECAR.ABBREVIATION AS [ABSENCE CODE]
			,S.STUDENT_GU
			, SSY.STUDENT_SCHOOL_YEAR_GU
			, ESAP.PERIOD_ATTEND_GU
			, ESAD.DAILY_ATTEND_GU
			
		FROM rev.EPC_STU_ATT_DAILY        AS ESAD
		LEFT JOIN rev.EPC_STU_ATT_PERIOD  AS ESAP   ON ESAP.DAILY_ATTEND_GU             = ESAD.DAILY_ATTEND_GU
		INNER JOIN rev.EPC_STU_ENROLL           AS ESE    ON ESE.ENROLLMENT_GU                = ESAD.ENROLLMENT_GU 
		INNER JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU       = ESE.STUDENT_SCHOOL_YEAR_GU 
		INNER JOIN rev.EPC_STU								AS S      ON S.STUDENT_GU = SSY.STUDENT_GU 
		INNER JOIN rev.REV_ORGANIZATION_YEAR AS ORGYR ON SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
		INNER JOIN rev.REV_ORGANIZATION AS ORG ON ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
		INNER JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU = ESAP.CODE_ABS_REAS_GU 
		AND  ECARSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU 
		INNER JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECAR.CODE_ABS_REAS_GU            = ECARSY.CODE_ABS_REAS_GU 
		INNER JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = ORGYR.YEAR_GU 
							   --This view only runs for the current school year and Regular Extension
								AND Y.SCHOOL_YEAR  = '2014'
								AND Y.EXTENSION  = 'R'
		WHERE
		--	ECAR.ABBREVIATION = 'T'
			--ESAD.ABS_DATE <= GETDATE()
			Y.SCHOOL_YEAR = '2014'
			AND Y.EXTENSION = 'R'
		) AS [PERIOD_ATT]
		
	GROUP BY
		[STUDENT_GU]
		,[ABSENCE CODE]
	) AS [PERIOD_ATT]
	
GROUP BY
	[STUDENT_GU]
)

, DAILY_ATTENDANCE AS
(
SELECT
	[STUDENT_GU]
	,ORGANIZATION_YEAR_GU
	-- GROUP DAILY TOTALS BY ABSENCE TYPE
	,SUM(CASE WHEN [ABSENCE CODE] = 'UX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY UNEXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'EX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY EXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'T' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY TARDY'
	--,[ABSENCE CODE]
	--,ABS_DATE
	
FROM
	(
	SELECT
		[STUDENT_GU]
		-- GET TOTAL DAYS
		,COUNT(ABS_DATE) AS [ABSENCE PERIODS]
		--,ABS_DATE 
		,[ABSENCE CODE]
		,ORGANIZATION_YEAR_GU
	FROM	
		(
		SELECT 
		SIS_NUMBER
		, ORG.ORGANIZATION_NAME
		, SSY.ORGANIZATION_YEAR_GU
		, ESAD.ABS_DATE
		, CASE
				WHEN ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T' THEN 'T'  
				WHEN ECAR.ABBREVIATION = 'ABS' OR ECAR.ABBREVIATION = 'UX' THEN 'UX'
				ELSE 'EX'END 
			AS [ABSENCE CODE]
		--, ECAR.ABBREVIATION  AS [ABSENCE CODE]
		, S.STUDENT_GU
		, SSY.STUDENT_SCHOOL_YEAR_GU
		, ESAD.DAILY_ATTEND_GU

		FROM rev.EPC_STU_ATT_DAILY        AS ESAD
		INNER  JOIN rev.EPC_STU_ENROLL           AS ESE    ON ESE.ENROLLMENT_GU                = ESAD.ENROLLMENT_GU 
		INNER  JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU       = ESE.STUDENT_SCHOOL_YEAR_GU 
		INNER  JOIN rev.EPC_STU								AS S      ON S.STUDENT_GU = SSY.STUDENT_GU 
		INNER  JOIN rev.REV_ORGANIZATION_YEAR AS ORGYR ON SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
		INNER  JOIN rev.REV_ORGANIZATION AS ORG ON ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

		INNER  JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU    = ESAD.CODE_ABS_REAS1_GU 											
		AND ECARSY.ORGANIZATION_YEAR_GU     = ORGYR.ORGANIZATION_YEAR_GU 

		INNER  JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECARSY.CODE_ABS_REAS_GU             = ECAR.CODE_ABS_REAS_GU 

		INNER  JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = ORGYR.YEAR_GU 
		--This view only runs for the current school year and Regular Extension
		AND Y.SCHOOL_YEAR  = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
		AND Y.EXTENSION  = 'R'

		WHERE
		--DAILY CONTAINS PERIOD TOO, SO EXCLUDE MID AND HIGH
		ORGANIZATION_NAME LIKE '%Elementary%'
		--AND ESAD.ABS_DATE <= GETDATE()
		AND Y.SCHOOL_YEAR = '2014'
		AND Y.EXTENSION = 'R'
		) AS [DAILY_ATT]
		
	GROUP BY
		[STUDENT_GU]
		,[ABSENCE CODE]
		,ORGANIZATION_YEAR_GU
	) AS [DAILY_ATT]
	
GROUP BY
	[STUDENT_GU]
	,ORGANIZATION_YEAR_GU
)


-------------------------------------------------------

SELECT
	[FILE].*
	--,[ENROLLMENTS].*
	,[STUDENT].[HISPANIC_INDICATOR]
	,[STUDENT].[RACE_1]
	,[STUDENT].[RACE_2]
	,[STUDENT].[RACE_3]
	,[STUDENT].[RACE_4]
	,[STUDENT].[RACE_5]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[GENDER]
	,[STUDENT].[LUNCH_STATUS]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	,[STUDENT].[GIFTED_STATUS]
	,[DISCIPLINE].[TOTAL] AS [DISCIPLINE_EVENTS]
	,[DAILY_ATTENDANCE].[DAILY UNEXCUSED]
	,[DAILY_ATTENDANCE].[DAILY EXCUSED]
	,[DAILY_ATTENDANCE].[DAILY TARDY]
	--,[DAILY_ATTENDANCE].*
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM A_Montoya_Assessment_Data.csv'  
		)AS [FILE]
		
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[FILE].[Student ID] = [STUDENT].[SIS_NUMBER]
	
	INNER JOIN
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
		
	WHERE
		SCHOOL_YEAR = '2014'
		AND EXTENSION = 'R'
	) AS [ENROLLMENTS]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [RN] = 1
	
	LEFT OUTER JOIN
	(
	SELECT
		COUNT([DISCIPLINE].[INCIDENT_ROLE]) AS [TOTAL]
		,[DISCIPLINE].[STUDENT_GU]
		,[StudentSchoolYear].[YEAR_GU]
	FROM
		rev.EPC_STU_INC_DISCIPLINE AS [DISCIPLINE]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[DISCIPLINE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
	GROUP BY
		[DISCIPLINE].[STUDENT_GU]
		,[StudentSchoolYear].[YEAR_GU]
	) AS [DISCIPLINE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [DISCIPLINE].[STUDENT_GU]
	AND [ENROLLMENTS].[YEAR_GU] = [DISCIPLINE].[YEAR_GU]
	
	LEFT OUTER JOIN
	DAILY_ATTENDANCE AS [DAILY_ATTENDANCE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [DAILY_ATTENDANCE].[STUDENT_GU]
	AND [ENROLLMENTS].[ORGANIZATION_YEAR_GU] = [DAILY_ATTENDANCE].[ORGANIZATION_YEAR_GU]
	
	--WHERE
	--	[STUDENT].[SIS_NUMBER] = '970110629'


REVERT
GO