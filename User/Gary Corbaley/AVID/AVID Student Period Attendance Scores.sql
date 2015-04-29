





DECLARE @SCHOOL_YEAR INT = 2014

;WITH
SBA_TEST AS
(
SELECT 
       ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER, PART_DESCRIPTION ORDER BY ADMIN_DATE DESC) AS RN
       ,StudentTest.[STUDENT_GU]
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,SIS_NUMBER
       ,TEST.TEST_NAME
       ,PART.PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER
FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

    INNER JOIN
    rev.EPC_STU_TEST_PART_SCORE AS SCORES
    ON
    SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

    LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = StudentTest.TEST_GU
    AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE


WHERE
       TEST_NAME like 'SBA%'
       --AND SIS_NUMBER = 563541697
       AND SCORE_DESCRIPTION IN ('Scale')
	   --AND PART_DESCRIPTION IN ('Math', 'Reading')
       --AND TEST_NAME = 'EOC Music 9 12 V001'

--ORDER BY SIS_NUMBER
--ORDER BY TEST_SCORE
)

,SSY_ENROLLMENTS AS
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
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].[STUDENT_GU] ORDER BY [StudentSchoolYear].[ENTER_DATE] DESC) AS RN
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
	
WHERE
	[StudentSchoolYear].[EXCLUDE_ADA_ADM] IS NULL
)

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
			ESAD.ABS_DATE <= GETDATE()
		) AS [PERIOD_ATT]
		
	GROUP BY
		[STUDENT_GU]
		,[ABSENCE CODE]
	) AS [PERIOD_ATT]
	
GROUP BY
	[STUDENT_GU]
)

------------------------------------------------------------------

SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[AVID_STUDENTS].[GRADE] AS [CURRENT_GRADE]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [CURRENT_LOCATION]
	
	,[PERIOD_ATTENDANCE].*
	
	--,[SBA_TEST].[TEST_NAME]
	--,[SBA_TEST].[PART_DESCRIPTION]
	--,[SBA_TEST].[SCORE_DESCRIPTION]
	--,[SBA_TEST].[PERFORMANCE_LEVEL]
	--,[SBA_TEST].[TEST_SCORE]
	--,[SBA_TEST].[ADMIN_DATE]
	--,[SBA_TEST].[PART_NUMBER]
	
	--,[ENROLLMENTS].*

FROM
	(
	SELECT DISTINCT
		[SCHEDULE].[STUDENT_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	FROM
		-- Get full schedule
		APS.BasicSchedule AS [SCHEDULE]
		
		INNER JOIN
		-- Get Course details
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[COURSE].[COURSE_ID] IN ('55507','555071','555072','55508','555081','555082','555091','555092','555101','555102','555111','555112','555121','555122')
		AND [RevYear].[SCHOOL_YEAR] = @SCHOOL_YEAR
		AND [RevYear].[EXTENSION] = 'R'
		
	) AS [AVID_STUDENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[AVID_STUDENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	PERIOD_ATTENDANCE as [PERIOD_ATTENDANCE]
	ON
	[AVID_STUDENTS].[STUDENT_GU] = [PERIOD_ATTENDANCE].[STUDENT_GU]
	
	LEFT OUTER JOIN
	SSY_ENROLLMENTS AS [ENROLLMENTS]
	ON
	[AVID_STUDENTS].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	AND [ENROLLMENTS].[RN] = 1
	
ORDER BY
	[STUDENT].[SIS_NUMBER]