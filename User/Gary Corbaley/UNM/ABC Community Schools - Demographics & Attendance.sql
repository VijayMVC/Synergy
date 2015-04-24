

--DECLARE @ATT_DATE DATETIME = '10/08/2014' -- 40 day
DECLARE @ATT_DATE DATETIME = '12/01/2014' -- 80 day


; WITH 
 ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,[StudentSchoolYear].[LEAVE_CODE]
	,[LEAVE_CODES].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf('12/19/2014') AS [Enrollments]
	
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
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODES]
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODES].[VALUE_CODE]

WHERE
	-- GET ONLY 1ST SEMESTER ENROLLMENTS
	[RevYear].[SCHOOL_YEAR] = 2014
	AND [RevYear].[EXTENSION] = 'R'
	AND [Enrollments].[ENTER_DATE] <= '12/19/2014'
	AND '12/19/2014' >= COALESCE([Enrollments].[LEAVE_DATE],'12/19/2014')
	--AND [Enrollments].[CONCURRENT] = ''	

)

-- From Student School Year [EPC_STU_SCH_YR]
,SSY_ENROLLMENTS AS
(
SELECT
	*
	,ROW_NUMBER() OVER (PARTITION BY [ENROLLMENTS].[STUDENT_GU] ORDER BY [ENROLLMENTS].[ENTER_DATE] DESC) AS [RN]
FROM
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
		,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
		,[Organization].[ORGANIZATION_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[Grades].[LIST_ORDER]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		,[StudentSchoolYear].[LEAVE_CODE]
		,[LEAVE_CODES].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
		,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
		,[StudentSchoolYear].[ACCESS_504]
		,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
			WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
			ELSE '' END AS [CONCURRENT]
		,[RevYear].[SCHOOL_YEAR]
		,[RevYear].[EXTENSION]
	FROM
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		
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
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODES]
		ON
		[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODES].[VALUE_CODE]
		
	) AS [ENROLLMENTS]
WHERE
	-- GET ONLY 1ST SEMESTER ENROLLMENTS
	[ENROLLMENTS].[SCHOOL_YEAR] = 2014
	AND [ENROLLMENTS].[EXTENSION] = 'R'
	AND [ENROLLMENTS].[ENTER_DATE] <= '12/19/2014'
	AND '12/19/2014' >= COALESCE([ENROLLMENTS].[LEAVE_DATE],'12/19/2014')
)

-- From APS.BasicStudent
, STUDENT_DETAILS AS
(
SELECT
	-- Basic Student Demographics
	[STUDENT].[STUDENT_GU]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[GENDER]
	,[STUDENT].[CLASS_OF]	
	--,[STUDENT].[HOME_ADDRESS] AS [HOME_ADDRESS]
	--,[STUDENT].[HOME_ADDRESS_2] AS [HOME_ADDRESS_2]
	--,[STUDENT].[HOME_CITY] AS [HOME_CITY]
	--,[STUDENT].[HOME_STATE] AS [HOME_STATE]
	--,[STUDENT].[HOME_ZIP] AS [HOME_ZIP]
	--,[STUDENT].[MAIL_ADDRESS] AS [MAIL_ADDRESS]
	--,[STUDENT].[MAIL_ADDRESS_2] AS [MAIL_ADDRESS_2]
	--,[STUDENT].[MAIL_CITY] AS [MAIL_CITY]
	--,[STUDENT].[MAIL_STATE] AS [MAIL_STATE]
	--,[STUDENT].[MAIL_ZIP] AS [MAIL_ZIP]
	
	-- Format Primary Phone
	--,'(' + left([PERSON].[PRIMARY_PHONE],3) + ')' 
 --      + substring([PERSON].[PRIMARY_PHONE], 4,3)+ '-'
 --                  + RIGHT([PERSON].[PRIMARY_PHONE],4) AS [PRIMARY_PHONE]
    
    -- Most Recent Lunch Status
    ,CASE WHEN [FRMHistory].[FRM_CODE] IS NULL THEN 'N' ELSE [FRMHistory].[FRM_CODE] END AS [FRM_CODE]
    
    -- Most Recent ELL Status
    ,CASE WHEN [ELL_PGM].[PROGRAM_CODE] = '1' AND [ELL_PGM].[EXIT_DATE] IS NULL THEN 'Y' ELSE 'N' END AS [ELL_STATUS]
    
    -- Current SPED or Gifted Status
    ,[CurrentSPED].[PRIMARY_DISABILITY_CODE]
    -- SPED Not Gifted
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] != 'GI' AND [CurrentSPED].[PRIMARY_DISABILITY_CODE] IS NOT NULL THEN 'Y' ELSE 'N' END AS [SPED_STATUS]
    ,CASE WHEN [CurrentSPED].[PRIMARY_DISABILITY_CODE] = 'GI' OR [CurrentSPED].[SECONDARY_DISABILITY_CODE] = 'GI' THEN 'Y' ELSE 'N' END AS [GIFTED_STATUS]
    
    -- Prefered Home Contact Language
    --,CASE WHEN [Contact_Language].[VALUE_DESCRIPTION] IS NULL THEN [STUDENT].[HOME_LANGUAGE] ELSE [Contact_Language].[VALUE_DESCRIPTION] END AS [HOME_LANGUAGE2]
    
    ,[STUDENT].[HISPANIC_INDICATOR]
    ,[ETHNIC_CODES].[RACE_1]
    ,[ETHNIC_CODES].[RACE_2]
    ,[ETHNIC_CODES].[RACE_3]
    ,[ETHNIC_CODES].[RACE_4]
    ,[ETHNIC_CODES].[RACE_5]
    
    ,CASE 
		WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN 'Hispanic'
		WHEN [ETHNIC_CODES].[RACE_2] IS NOT NULL THEN 'Two or More'
		ELSE [ETHNIC_CODES].[RACE_1]
	END AS [RESOLVED_RACE]
    
    --,[PARENT_NAMES].[Parents]
    
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	LEFT JOIN
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
    
    LEFT JOIN
    rev.EPC_STU_PGM_ELL AS [ELL_PGM]
    ON
    [STUDENT].[STUDENT_GU] = [ELL_PGM].[STUDENT_GU] 
    
    LEFT JOIN
    (
	SELECT
		  ROW_NUMBER() OVER (PARTITION BY [STU].[STUDENT_GU] order by [FRM].[ENTER_DATE],[STU].[STUDENT_GU]) [RN]
		, [STU].[STUDENT_GU]
		, [FRM].[FRM_CODE]
	FROM 
		rev.EPC_STU [STU]
		
		LEFT JOIN 
		rev.EPC_STU_PGM_FRM_HIS [FRM] 
		ON
		[FRM].[STUDENT_GU] = [STU].[STUDENT_GU]
		AND [FRM].[ENTER_DATE] IS NOT NULL 
		AND ([FRM].[EXIT_DATE] IS NOT NULL OR [FRM].[EXIT_DATE] > GETDATE())
	) AS [FRMHistory]
	ON
	[STUDENT].[STUDENT_GU] = [FRMHistory].[STUDENT_GU]
	AND [FRMHistory].[RN] = 1
	
	---- Get Home Contact Language
	--LEFT JOIN
	--APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
	--ON
	--[ELL_PGM].[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]
	
	-- Get All Racial Codes
	LEFT JOIN
	(
	SELECT
		[ETHNIC_PIVOT].[PERSON_GU]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[1]) AS [RACE_1]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[2]) AS [RACE_2]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[3]) AS [RACE_3]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[4]) AS [RACE_4]
		,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[5]) AS [RACE_5]
	FROM
		(
		SELECT
			[SECONDARY_ETHNIC_CODES].[PERSON_GU]
			,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
			,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
		) [PVT]
		PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	
	---- Get concatenated list of parent names
	--LEFT JOIN
	--(
	--SELECT
	--   PNm.STUDENT_GU
	--, ROW_NUMBER() OVER(PARTITION BY PNm.STUDENT_GU order by PNm.STUDENT_GU) rno
	--, Parents = STUFF(  COALESCE(', ' + Pnm.[1], '')
	--				   + COALESCE(', ' + Pnm.[2], '') 
	--				   + COALESCE(', ' + Pnm.[3], '') 
	--				   + COALESCE(', ' + Pnm.[4], '') 
	--				   , 1, 1,'')
	--FROM
	--  (
	--	SELECT 
	--		stu.STUDENT_GU
	--	  , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU))) rn
	--	  , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
	--	FROM rev.EPC_STU stu
	--	JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.LIVES_WITH = 'Y'
	--	JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
	--  ) 
	--  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
	--) AS [PARENT_NAMES]
	--ON
	--[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	--AND [PARENT_NAMES].[rno] = 1
	
)

--/*
, PERIOD_ATTENDANCE AS
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
		,SUM([BELL_PERIOD]) AS [ABSENCE PERIODS]
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
								AND Y.SCHOOL_YEAR  = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
								AND Y.EXTENSION  = 'R'
		WHERE
		--	ECAR.ABBREVIATION = 'T'
			ESAD.ABS_DATE <= @ATT_DATE
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
	-- GROUP DAILY TOTALS BY ABSENCE TYPE
	,SUM(CASE WHEN [ABSENCE CODE] = 'UX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY UNEXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'EX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY EXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'T' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY TARDY'
FROM
	(
	SELECT
		[STUDENT_GU]
		-- GET TOTAL DAYS
		,COUNT(ABS_DATE) AS [ABSENCE PERIODS]
		,[ABSENCE CODE]
	FROM	
		(
		SELECT 
		SIS_NUMBER
		, ORG.ORGANIZATION_NAME
		, ESAD.ABS_DATE
		, CASE
				WHEN ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T' THEN 'T'  
				WHEN ECAR.ABBREVIATION = 'ABS' THEN 'UX'
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
		AND ESAD.ABS_DATE <= @ATT_DATE
		) AS [DAILY_ATT]
		
	GROUP BY
		[STUDENT_GU]
		,[ABSENCE CODE]
	) AS [DAILY_ATT]
	
GROUP BY
	[STUDENT_GU]
)
--*/
---------------------------------------------------------------------------------------------------
/*
SELECT
	[ENROLLMENTS].[SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	,CASE WHEN [ENROLLMENTS].[ENTER_DATE] > '08/14/2014' OR [ENROLLMENTS].[LEAVE_DATE] < '12/19/2014' THEN 'Y' ELSE 'N' END AS [MOBILITY]
	,[STUDENT].[GENDER]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[FRM_CODE] AS [LUNCH]
	,[STUDENT].[ELL_STATUS]
	,[STUDENT].[SPED_STATUS]
	--,[ENROLLMENTS].[STUDENT_GU]	
	
	
FROM
	SSY_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	STUDENT_DETAILS AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[RN] = 1
	
	-- THESE CONDITIONS WERE MOVED TO SSY_ENROLLMENTS IN ORDER TO GET THE MOST RECENT 1st SEMESTER ENROLLMENT
	--[ENROLLMENTS].[SCHOOL_YEAR] = 2014
	--AND [ENROLLMENTS].[EXTENSION] = 'R'
	--AND [ENROLLMENTS].[ENTER_DATE] <= '12/19/2014'
	--AND '12/19/2014' >= COALESCE([ENROLLMENTS].[LEAVE_DATE],'12/19/2014')
	
	AND [ENROLLMENTS].[SCHOOL_CODE] IN ('255', '260', '279', '285', '333', '379', '413', '460', '470', '520', '570', '576')
	
	--AND [ENROLLMENTS].[ENTER_DATE] < '08/13/2014'
	
--ORDER BY
--	[ENROLLMENTS].[STUDENT_GU]
--	,[ENROLLMENTS].[RN]
--*/	

--/*
SELECT
	[ENROLLMENTS].[SCHOOL_YEAR]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	--,[ENROLLMENTS].[GRADE]
	--,[ENROLLMENTS].[ENTER_DATE]
	--,[ENROLLMENTS].[LEAVE_DATE]
	--,[ENROLLMENTS].[LEAVE_CODE]
	--,[ENROLLMENTS].[LEAVE_DESCRIPTION]
	--,CASE WHEN [ENROLLMENTS].[ENTER_DATE] > '08/14/2014' THEN 'Y' ELSE 'N' END AS [MOBILITY]
	--,[STUDENT].[GENDER]
	--,[STUDENT].[RESOLVED_RACE]
	--,[STUDENT].[FRM_CODE] AS [LUNCH]
	--,[STUDENT].[ELL_STATUS]
	--,[STUDENT].[SPED_STATUS]
	--,[ENROLLMENTS].[STUDENT_GU]	
	,[DAILY_ATTENDANCE].[DAILY UNEXCUSED]
	,[DAILY_ATTENDANCE].[DAILY EXCUSED]
	,[DAILY_ATTENDANCE].[DAILY TARDY]
	,[PERIOD_ATTENDANCE].[PERIOD UNEXCUSED]
	,[PERIOD_ATTENDANCE].[PERIOD EXCUSED]
	,[PERIOD_ATTENDANCE].[PERIOD TARDY]
	
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	STUDENT_DETAILS AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	PERIOD_ATTENDANCE AS [PERIOD_ATTENDANCE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [PERIOD_ATTENDANCE].[STUDENT_GU]
	
	LEFT OUTER JOIN
	DAILY_ATTENDANCE AS [DAILY_ATTENDANCE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [DAILY_ATTENDANCE].[STUDENT_GU]
	
WHERE
	--[ENROLLMENTS].[RN] = 1
	
	-- THESE CONDITIONS WERE MOVED TO SSY_ENROLLMENTS IN ORDER TO GET THE MOST RECENT 1st SEMESTER ENROLLMENT
	--[ENROLLMENTS].[SCHOOL_YEAR] = 2014
	--AND [ENROLLMENTS].[EXTENSION] = 'R'
	--AND [ENROLLMENTS].[ENTER_DATE] <= '12/19/2014'
	--AND '12/19/2014' >= COALESCE([ENROLLMENTS].[LEAVE_DATE],'12/19/2014')
	
	[ENROLLMENTS].[SCHOOL_CODE] IN ('255', '260', '279', '285', '333', '379', '413', '460', '470', '520', '570', '576')
	
	--AND [ENROLLMENTS].[ENTER_DATE] < '08/13/2014'
	
	--AND [PERIOD_ATTENDANCE].[ABSENCE CODE] = 'T'
	
ORDER BY
	[ENROLLMENTS].[STUDENT_GU]
	--,[ENROLLMENTS].[RN]
	
-- */
