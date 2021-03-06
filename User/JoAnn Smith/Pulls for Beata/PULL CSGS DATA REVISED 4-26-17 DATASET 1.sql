/*
Pull data for for Beata
Council of the Great City Schools CGCS
KPI Request

Data Set 1
ALL DATA ARE FOR 2015-16 Enrolled Students unless otherwise noted. 
80 DAY. WIDE FORMAT (1 record per student)

Student ID APS 
Student ID State
Gender
Race (resolved Race with two or more)
Special Ed Status (NOT Including gifted)
Primary Disability
ELL Status (the STARS Definition � 0 = never enrolled; 1 currently enrolled; 2 exited one year, etc)
Revised to pull from rev.epc_stu_pgm_ell_his in which Debbie reconstructed the ELL data
ELL Exit Date
FRPL Status
Grade enrolled 2014-15 (Including P1 & PK) 
Grade enrolled 2015-16 
PARCC ELA Performance Level
PARCC Math Performance Level
Total Absences (UX & EX)
Total Suspension Days
AP Enrollment 
AP Exam Scores
IB Enrollment
Dual Credit Enrollment
Dual Credit Completion
Core course (math, English, science and social studies) grade
GPA (cumulative) 
*/


--***********************************************************
--total student enrollments from RDAVM/Synergy Data Set 1
; WITH STUDENTCTE 
AS
(
SELECT 
		'2015-2016' AS [SURVEY SCHOOL YEAR]
		,BS.SIS_NUMBER AS [APS ID]
		,BS.STUDENT_GU
		,[STUDENT ID] AS [STATE ID]
		,BS.GENDER
		,BS.RACE_1
		,BS.RACE_2
		,BS.RACE_3
		,BS.RACE_4
		,BS.RACE_5
		,BS.RESOLVED_RACE
		,CASE	
			WHEN SPED_STATUS = 'Y' and GIFTED_STATUS = 'Y' 
				THEN 'N'
			WHEN SPED_STATUS = 'N' AND GIFTED_STATUS = 'N'
				THEN 'N'
			WHEN SPED_STATUS = 'Y' AND GIFTED_STATUS = 'N'
				THEN 'Y' 
		END AS SPED_STATUS
		,BS.PRIMARY_DISABILITY_CODE
		,LU.VALUE_DESCRIPTION AS [PRIMARY DISABILITY DESCRIPTION]
		--,ELL.EXIT_REASON
		--,ELL.EXIT_DATE
		--,CASE
		--	WHEN [ENGLISH PROFICIENCY] = '0' THEN 'Never Enrolled'
		--	WHEN [ENGLISH PROFICIENCY] = '1' THEN 'Currently Enrolled'
		--	WHEN [ENGLISH PROFICIENCY] = '2' THEN 'Exited One Year'
		--	WHEN [ENGLISH PROFICIENCY] = '3' THEN 'Exited Two Years'
		--	WHEN [ENGLISH PROFICIENCY] = '4' THEN 'Exited Three + Years'
		--END AS [ELL STATUS]
		--show the RDAVM data versus Synergy
		--,CASE WHEN [ENGLISH PROFICIENCY] > 1 THEN CAST(EXIT_DATE AS DATE) 
		--      WHEN [ENGLISH PROFICIENCY] = 0 THEN NULL
		--END AS [EXIT_DATE]
		,STARS.[ECONOMIC STATUS /FOOD PGM PARTICIPATION/] AS FRPL_STATUS
		,[CURRENT GRADE LEVEL] AS [STUDENT GRADE LEVEL 2015]
		,isnull(C.AP_INDICATOR, 'N') AS AP_INDICATOR
		,ISNULL(c.IB_INDICATOR, 'N') AS IB_INDICATOR
		,ROW_NUMBER() over(partition by BS.SIS_NUMBER order by BS.SIS_NUMBER, C.AP_INDICATOR DESC) as RN
	FROM
	[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]  AS STARS
	LEFT JOIN 
	rev.EPC_SCH AS SCH
	ON
	STARS.[LOCATION CODE] = SCH.STATE_SCHOOL_CODE
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
	ON
	BS.SIS_NUMBER = [ALTERNATE STUDENT ID]
	LEFT JOIN 
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') AS LU
	ON
	LU.VALUE_CODE = BS.PRIMARY_DISABILITY_CODE	
	LEFT JOIN 
	rev.EPC_STU_PGM_ELL e
	ON
	E.STUDENT_GU = BS.STUDENT_GU
	left join
	aps.ScheduleDetailsAsOf('2015-12-15') P
	on
	p.SIS_NUMBER = bs.SIS_NUMBER
	left join
	rev.EPC_CRS C
	on
	p.COURSE_GU = c.COURSE_GU
	WHERE
	[Period] = '2015-12-15'
	AND [District Code] = '001'
)
--SELECT * FROM STUDENTCTE where RN = 1 AND   [APS ID] = 100003896
,STUDENTCTE1
AS
(
SELECT
	*
FROM
	STUDENTCTE
WHERE
	RN = 1
)
--SELECT * FROM STUDENTCTE1 where [APS ID] = 100028992
,ENROLLED_GRADE2014
AS
(
SELECT
	S.[APS ID],
	STARS.[CURRENT GRADE LEVEL] AS [GRADE LEVEL 2014]
FROM
	STUDENTCTE1 S
LEFT JOIN
	[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT]  AS STARS
ON
	S.[APS ID] = STARS.[ALTERNATE STUDENT ID]
LEFT JOIN 
	rev.EPC_SCH AS SCH
ON
	STARS.[LOCATION CODE] = SCH.STATE_SCHOOL_CODE
INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
ON
	BS.SIS_NUMBER = [ALTERNATE STUDENT ID]

WHERE
	PERIOD = '2014-12-15'
)
,ELL
AS
(
	SELECT ROW_NUMBER() OVER(PARTITION BY STUDENT_GU ORDER BY STUDENT_GU, EXIT_DATE DESC) AS RN,
	STUDENT_GU,
	EXIT_DATE,
	EXIT_REASON
FROM
	REV.EPC_STU_PGM_ELL_HIS_NEW ELL --copied table over from instructional and renamed it
)
,ELL_RESULTS
AS
(
SELECT
	*
FROM
	ELL
WHERE
	RN = 1
)
--SELECT * FROM ELL WHERE RN = 1 AND STUDENT_GU = '1041596B-6AB1-44C2-B6E4-466C1F66D4F1'
--SELECT * FROM ENROLLED_GRADE2014
/*
AP EXAM information for Data Set 1
*/

,AP_EXAM
AS
(
SELECT 
	SIS_NUMBER,
	TEST_NAME,
	PL,
	TEST_SCORE,
	ADMIN_DATE
FROM
(
SELECT 
         ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER, TEST_NAME, ADMIN_DATE ORDER BY TEST_NAME DESC) AS RN
		,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
		,TEST.TEST_NAME
		,STU_PART.PERFORMANCE_LEVEL AS PL
		,SCORES.TEST_SCORE
		,STUDENTTEST.ADMIN_DATE
FROM
		rev.EPC_STU_TEST AS StudentTest
JOIN
		rev.EPC_TEST_PART AS PART
ON 
		StudentTest.TEST_GU = PART.TEST_GU
JOIN
		rev.EPC_STU_TEST_PART AS STU_PART
ON
		PART.TEST_PART_GU = STU_PART.TEST_PART_GU
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
ON
		TEST.TEST_GU = StudentTest.TEST_GU
INNER JOIN
		rev.EPC_STU AS Student
ON
		Student.STUDENT_GU = StudentTest.STUDENT_Gu
INNER JOIN
		rev.REV_PERSON AS Person
ON
		Person.PERSON_GU = StudentTest.STUDENT_GU
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
LEFT JOIN
		REV.EPC_GRAD_REQ_DEF_TST_GRPYT AS TST_GRPYT
ON
		TEST.TEST_GU = TST_GRPYT.TEST_GU
		AND PART.TEST_PART_GU = TST_GRPYT.TEST_PART_GU
LEFT JOIN
		REV.EPC_GRAD_REQ_DEF_TST_GRPY AS TST_GRPY
ON 
		TST_GRPY.GRAD_REQ_DEF_TST_GRPY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPY_GU
LEFT JOIN
		REV.EPC_GRAD_REQ_DEF_GRPYT_REQ AS DEF_GRPYT
ON
		 DEF_GRPYT.TEST_GU = TEST.TEST_GU
		AND DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU = TST_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU
LEFT JOIN
		REV.EPC_GRAD_REQ_DEF_GRPYT_PL AS GRPYT_PL
ON
		 GRPYT_PL.GRAD_REQ_DEF_TST_GRPTY_GU = DEF_GRPYT.GRAD_REQ_DEF_TST_GRPTY_GU
WHERE
		1 = 1
		AND TEST_NAME LIKE 'AP %'
		AND YEAR(ADMIN_DATE) = '2015'
) AS T1
WHERE RN = 1
)
--SELECT * FROM AP_EXAM where SIS_NUMBER = 100029214


--Found students who had N as AP Indicator but had test results for an AP Exam
--example:  100016310 who was enrolled in AP EngLitComp12 but entered and left on the
--same date, but who has an exam score
--most of the AP indicators who are N with no AP score were registered for an AP class
--and left before the school year was over but took the test
--others took the test but were not in AP classes - 100104884 didn't pass the test
--also found students with ap_indicator of Y but no AP exam scores 100004464
,AP_RESULTS
AS
(
SELECT	
	s.[APS ID],
	s.[AP_INDICATOR],
	max(CASE WHEN TEST_NAME = 'AP Caluclus AB' THEN TEST_SCORE ELSE '' END) AS [AP Calculus AB],
	max(CASE WHEN TEST_NAME = 'AP English Language and Composition' THEN TEST_SCORE ELSE '' END) AS [AP English Language and Composition],
	max(CASE WHEN TEST_NAME = 'AP US History' THEN TEST_SCORE ELSE '' END) AS [AP US History],
	max(CASE WHEN TEST_NAME = 'AP Calculus BC' THEN TEST_SCORE ELSE '' END) AS [AP Calculus BC],
	max(CASE WHEN TEST_NAME = 'AP German Language' THEN TEST_SCORE ELSE '' END) AS [AP German Language],
	max(CASE WHEN TEST_NAME = 'AP Physics C Mechanics' THEN TEST_SCORE ELSE '' END) AS [AP Physics C Mechanics],
	max(CASE WHEN TEST_NAME = 'AP Spanish Literature' THEN TEST_SCORE ELSE '' END) AS [AP Spanish Literature],
	max(CASE WHEN TEST_NAME = 'AP Biology' THEN TEST_SCORE ELSE '' END) AS [AP Biology],
	max(CASE WHEN TEST_NAME = 'AP Chemistry' THEN TEST_SCORE ELSE '' END) AS [AP Chemistry],
	max(CASE WHEN TEST_NAME = 'AP Italian Language And Culture' THEN TEST_SCORE ELSE '' END) AS [AP Italian Language And Culture],
	max(CASE WHEN TEST_NAME = 'AP Microeconomics' THEN TEST_SCORE ELSE '' END) AS [AP Microeconomics],
	max(CASE WHEN TEST_NAME = 'AP Music Theory' THEN TEST_SCORE ELSE '' END) AS [AP Music Theory],
	max(CASE WHEN TEST_NAME = 'AP Physics C Electricity and Magnetism' THEN TEST_SCORE ELSE '' END) AS [AP Physics C Electricity and Magnetism],
	max(CASE WHEN TEST_NAME = 'AP Psychology' THEN TEST_SCORE ELSE '' END) AS [AP Psychology],
	max(CASE WHEN TEST_NAME = 'AP Spanish Language' THEN TEST_SCORE ELSE '' END) AS [AP Spanish Language],
	max(CASE WHEN TEST_NAME = 'AP Studio Art Drawing' THEN TEST_SCORE ELSE '' END) AS [AP Studio Art Drawing],
	max(CASE WHEN TEST_NAME = 'AP Government and Politics: United States' THEN TEST_SCORE ELSE '' END) AS [AP Government and Politics: United States],
	max(CASE WHEN TEST_NAME = 'AP English Literature And Composition' THEN TEST_SCORE ELSE '' END) AS [AP English Literature And Composition],
	max(CASE WHEN TEST_NAME = 'AP Japanese Language And Culture' THEN TEST_SCORE ELSE '' END) AS [AP Japanese Language And Culture],
	max(CASE WHEN TEST_NAME = 'AP Studio Art: 2-D Design' THEN TEST_SCORE ELSE '' END) AS [AP Studio Art: 2-D Design],
	max(CASE WHEN TEST_NAME = 'AP Chinese Language and Culture' THEN TEST_SCORE ELSE '' END) AS [AP Chinese Language and Culture],
	max(CASE WHEN TEST_NAME = 'AP Computer Science A' THEN TEST_SCORE ELSE '' END) AS [AP Computer Science A],
	max(CASE WHEN TEST_NAME = 'AP Environmental Science' THEN TEST_SCORE ELSE '' END) AS [AP Environmental Science],
	max(CASE WHEN TEST_NAME = 'AP European History' THEN TEST_SCORE ELSE '' END) AS [AP European History],
	max(CASE WHEN TEST_NAME = 'AP French Language' THEN TEST_SCORE ELSE '' END) AS [AP French Language],
	max(CASE WHEN TEST_NAME = 'AP Human Geography' THEN TEST_SCORE ELSE '' END) AS [AP Human Geography],
	max(CASE WHEN TEST_NAME = 'AP Macroeconomics' THEN TEST_SCORE ELSE '' END) AS [AP Macroeconomics],
	max(CASE WHEN TEST_NAME = 'AP Statistics' THEN TEST_SCORE ELSE '' END) AS [AP Statistics],
	max(CASE WHEN TEST_NAME = 'AP Studio Art: 3-D Design' THEN TEST_SCORE ELSE '' END) AS [AP Studio Art: 3-D Design],
	max(CASE WHEN TEST_NAME = 'AP World History' THEN TEST_SCORE ELSE '' END) AS [AP World History]
FROM STUDENTCTE1 S
LEFT OUTER JOIN
	AP_EXAM e
ON
	E.SIS_NUMBER = S.[APS ID]
group by
	[APS ID], AP_INDICATOR	
)
--select * from AP_RESULTS where [APS ID] = 100029214

,DUAL_CREDIT
as
(
SELECT
	ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY SIS_NUMBER, DUAL_CREDIT DESC) AS RN,
	SIS_NUMBER,
	COURSE.COURSE_SHORT_TITLE, 
	ISNULL(DUAL_CREDIT, ' ') AS DUAL_CREDIT,
	CREDIT_COMPLETED,
	MARK
FROM
	APS.BasicSchedule AS [BASIC_SCHEDULE]	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[BASIC_SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN	 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[BASIC_SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
	ON
	[BASIC_SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]	
    -- Get school name
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[BASIC_SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]   
    -- Get school number
	LEFT JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[BASIC_SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	LEFT HASH JOIN 
	(	 SELECT  CREDIT_COMPLETED, MARK, TERM_CODE, STU.STUDENT_GU, COURSE_ID, SECTION_ID
	 
	 FROM 

			rev.EPC_STU_CRS_HIS AS HIS
			INNER JOIN 
			REV.EPC_STU AS STU
			ON
			HIS.STUDENT_GU = STU.STUDENT_GU
			LEFT JOIN
			[rev].[EPC_REPEAT_TAG] AS [Repeat]
			ON
			HIS.[REPEAT_TAG_GU]=[Repeat].[REPEAT_TAG_GU]
) AS CRSHIST
ON
CRSHIST.STUDENT_GU = STUDENT.STUDENT_GU
AND COURSE.COURSE_ID = CRSHIST.COURSE_ID
	
WHERE
	[RevYear].[SCHOOL_YEAR] IN ('2015')
	AND [RevYear].[EXTENSION] = 'R'
	and  SUBJECT_AREA_1 <> 'NOC'
) 
--SELECT * FROM DUAL_CREDIT
, DUAL_CREDIT1
AS
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY SIS_NUMBER ORDER BY SIS_NUMBER, DUAL_CREDIT DESC) AS RN, 
	[APS ID],
	SIS_NUMBER,
	DUAL_CREDIT,
		MAX(CASE WHEN D.RN = 1 AND DUAL_CREDIT = 'Y' THEN MARK ELSE '' END) AS DUAL_CREDIT1,
		MAX(CASE WHEN D.RN = 2 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) as DUAL_CREDIT2,
		MAX(CASE WHEN D.RN = 3 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT3,
		MAX(CASE WHEN D.RN = 4 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT4,
		MAX(CASE WHEN D.RN = 5 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT5,
		MAX(CASE WHEN D.RN = 6 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT6,
		MAX(CASE WHEN D.RN = 7 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT7,
		MAX(CASE WHEN D.RN = 8 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT8,
		MAX(CASE WHEN D.RN = 9 AND DUAL_CREDIT = 'Y'THEN MARK ELSE '' END) AS DUAL_CREDIT9
FROM
	 STUDENTCTE1 S
LEFT JOIN
	DUAL_CREDIT D
ON
	 S.[APS ID] =D.SIS_NUMBER 
GROUP BY SIS_NUMBER, [APS ID], DUAL_CREDIT
)
,DUAL_CREDIT2
AS
(
SELECT
	 * 
FROM
	 DUAL_CREDIT1
WHERE
	RN = 1 
)
--SELECT * FROM DUAL_CREDIT2
,GPA
AS
(
SELECT DISTINCT
	s.[APS ID],
	gpa.[HS Cum Flat],
	gpa.[HS Cum Weighted]
from
	StudentCTE S
left join
	aps.CumGPAForYear('2015') gpa
on
	s.[APS ID] = gpa.SIS_NUMBER
)
--SELECT * FROM GPA

,CORE_ENGLISH
AS
(

SELECT
	ROW_NUMBER() OVER(PARTITION BY [APS ID] ORDER BY [APS ID], term_code desc) AS RN,
	S.[APS ID],
	h.course_title AS [ H COURSE TITLE],
	H.TERM_CODE,
	h.MARK AS [ ENGLISH GRADE]
from
	STUDENTCTE S
LEFT JOIN
	REV.EPC_STU_CRS_HIS H
ON
	S.STUDENT_GU = H.STUDENT_GU
INNER JOIN
	REV.EPC_CRS C
ON
	C.COURSE_GU = H.COURSE_GU
where 1 = 1		
AND
	C.DEPARTMENT = 'ENG'
AND
	H.SCHOOL_YEAR = '2015'
)	
,CORE_ENGLISH2
AS
(
SELECT * FROM CORE_ENGLISH	WHERE RN = 1
)
--SELECT * FROM CORE_ENGLISH2
,CORE_MATH
AS
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY [APS ID] ORDER BY [APS ID], term_code desc) AS RN,
	S.[APS ID],
	h.course_title AS [ H COURSE TITLE],
	H.TERM_CODE,
	h.MARK AS [ MATH GRADE]
from
	STUDENTCTE S
LEFT JOIN
	REV.EPC_STU_CRS_HIS H
ON
	S.STUDENT_GU = H.STUDENT_GU
INNER JOIN
	REV.EPC_CRS C
ON
	C.COURSE_GU = H.COURSE_GU
where 1 = 1		
AND
	C.DEPARTMENT = 'MATH'
AND
	H.SCHOOL_YEAR = '2015'
)
,CORE_MATH2
AS
(
SELECT * FROM CORE_MATH WHERE RN = 1
)
,CORE_SCIENCE
AS
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY [APS ID] ORDER BY [APS ID], term_code desc) AS RN,
	S.[APS ID],
	h.course_title AS [ H COURSE TITLE],
	H.TERM_CODE,
	h.MARK AS [ SCIENCE GRADE]
from
	STUDENTCTE S
LEFT JOIN
	REV.EPC_STU_CRS_HIS H
ON
	S.STUDENT_GU = H.STUDENT_GU
INNER JOIN
	REV.EPC_CRS C
ON
	C.COURSE_GU = H.COURSE_GU
where 1 = 1		
AND
	C.DEPARTMENT = 'SCI'
AND
	H.SCHOOL_YEAR = '2015'
)
,CORE_SCIENCE2
AS
(
SELECT * FROM CORE_SCIENCE WHERE RN =1	
)
,CORE_SOCIAL_STUDIES
AS
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY [APS ID] ORDER BY [APS ID], term_code desc) AS RN,
	S.[APS ID],
	h.course_title AS [ H COURSE TITLE],
	H.TERM_CODE,
	h.MARK AS [ SOCIAL STUDIES GRADE]
from
	STUDENTCTE S
LEFT JOIN
	REV.EPC_STU_CRS_HIS H
ON
	S.STUDENT_GU = H.STUDENT_GU
INNER JOIN
	REV.EPC_CRS C
ON
	C.COURSE_GU = H.COURSE_GU
where 1 = 1		
AND
	C.DEPARTMENT = 'SOC'
AND
	H.SCHOOL_YEAR = '2015'
)
,CORE_SOCIAL_STUDIES2
AS
(
SELECT * FROM CORE_SOCIAL_STUDIES WHERE RN = 1
)
,TOTAL_ABSENCES
AS
(
SELECT

	 SA.[SIS Number] as [Student APS ID],
	 ISNULL(SA.[Total Excused],0)  as [Total Excused],
	 ISNULL(SA.[Total Unexcused],0) as [Total Unexcused]
	 
FROM 
	dbo.STUDENT_ATTENDANCE_2015 sa
LEFT JOIN
	STUDENTCTE1 S
ON
	SA.[SIS Number] = S.[APS ID]	
)
--select * from TOTAL_ABSENCES
,SUSPENSIONS
AS
(
SELECT DISTINCT
	[ENROLLMENTS].[SCHOOL_YEAR]
	,ENROLLMENTS.STUDENT_SCHOOL_YEAR_GU
	,[STUDENT].[SIS_NUMBER]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]	
	,isNull([DISCIPLINE].[SUSPENSION_DAYS], 0) as [SUSPENSION DAYS]
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [ENR].[STUDENT_GU] ORDER BY [ENR].[ENTER_DATE] DESC) AS [RN]
	FROM
		APS.StudentEnrollmentDetails AS [ENR]		
	WHERE
		[ENR].SCHOOL_YEAR = '2015'
		AND [ENR].[EXTENSION] = 'R'
		AND [ENR].[EXCLUDE_ADA_ADM] IS NULL
		AND [ENR].[SUMMER_WITHDRAWL_CODE] IS NULL
	) AS [ENROLLMENTS]	
	INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]	
	LEFT OUTER JOIN
	(
	SELECT
		SUM([Discipline].[DAYS]) AS [SUSPENSION_DAYS]
		,[Disposition_Code].[DISP_CODE]
		,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		,Discipline.STUDENT_GU
		,discipline.STUDENT_SCHOOL_YEAR_GU
	FROM	
		[REV].[EPC_STU_INC_DISCIPLINE] AS [Discipline]	
	LEFT OUTER JOIN
		REV.EPC_SCH_INCIDENT AS [INCIDENT]
	ON
		[Discipline].[SCH_INCIDENT_GU] = [INCIDENT].[SCH_INCIDENT_GU]
	LEFT OUTER JOIN
		[rev].[EPC_STU_INC_DISPOSITION] AS [Disposition]
	ON
		[Discipline].[STU_INC_DISPOSITION_GU] = [Disposition].[STU_INC_DISPOSITION_GU]
	LEFT OUTER JOIN
		[rev].[EPC_CODE_DISP] AS [Disposition_Code]
	ON
		[Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
	WHERE
		[Disposition_Code].[DISP_CODE] IN ('S OSS','S ISS', 'ZHLTSCON', 'ZHLTSCV', 'ZHLTSNRS', 'ZHLTSOTH', 'ZHLTSVQP')		
	GROUP BY
		[Discipline].[STUDENT_SCHOOL_YEAR_GU], Discipline.student_gu, Disposition_Code.DESCRIPTION, Disposition_CODE.DISP_CODE
	) AS [DISCIPLINE]
ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [DISCIPLINE].[STUDENT_SCHOOL_YEAR_GU]		
WHERE
	[ENROLLMENTS].[RN] = 1
)
,PARCC_RESULTS
AS
(
SELECT
	*
FROM
	DBO.PARCC_ELA_MATH_2015 
)
--SELECT * FROM PARCC_RESULTS
,RESULTSCTE
AS
(
SELECT
	ROW_NUMBER() OVER (PARTITION BY S.[APS ID] ORDER BY S.[APS ID]) AS ROWNUM,
	S.[APS ID],
	S.[STATE ID],
	S.GENDER,
	S.RACE_1,
	S.RACE_2,
	S.RACE_3,
	S.RACE_4,
	S.RACE_5,
	S.RESOLVED_RACE,
	S.SPED_STATUS,
	S.[PRIMARY DISABILITY DESCRIPTION],
	EL.EXIT_REASON,
	CAST(EL.EXIT_DATE AS DATE) AS [ELL EXIT DATE],
	S.FRPL_STATUS,
	GR.[GRADE LEVEL 2014] AS [STUDENT GRADE LEVEL 2014],
	S.[STUDENT GRADE LEVEL 2015],
	p.[PARCC ELA Overall Performance Level],
	p.[PARCC MATHEMATICS Overall Performance Level],
	T.[Total Excused],
	T.[Total Unexcused],
	SU.[SUSPENSION DAYS],
	A.AP_INDICATOR,
	S.IB_INDICATOR,
	A.[AP Calculus BC],
	A.[AP German Language], 
	A.[AP Physics C Mechanics], 
	A.[AP Spanish Literature], 
	A.[AP Biology], 
	A.[AP Chemistry], 
	A.[AP English Language and Composition], 
	A.[AP Italian Language And Culture],
	A.[AP Microeconomics],
	A.[AP Music Theory], 
	A.[AP Physics C Electricity and Magnetism], 
	A.[AP Psychology], 
	A.[AP Spanish Language], 
	A.[AP Studio Art Drawing],  
	A.[AP US History], 
	A.[AP Calculus AB], 
	A.[AP Government and Politics: United States], 
	A.[AP Japanese Language And Culture], 
	A.[AP Studio Art: 2-D Design], 
	A.[AP Chinese Language and Culture],
	A.[AP Computer Science A], 
	A.[AP Environmental Science], 
	A.[AP European History], 
	A.[AP French Language], 
	A.[AP Human Geography], 
	A.[AP Macroeconomics], 
	A.[AP Statistics],
	A.[AP Studio Art: 3-D Design],
	A.[AP World History],
	D.DUAL_CREDIT,
	D.DUAL_CREDIT1,
	D.DUAL_CREDIT2,
	D.DUAL_CREDIT3,
	D.DUAL_CREDIT4,
	D.DUAL_CREDIT5,
	D.DUAL_CREDIT6,
	D.DUAL_CREDIT7,
	D.DUAL_CREDIT8,
	D.DUAL_CREDIT9,
	E.[ ENGLISH GRADE],
	M.[ MATH GRADE],
	SCI.[ SCIENCE GRADE],
	SS.[ SOCIAL STUDIES GRADE],
	G.[HS Cum Flat],
	G.[HS Cum Weighted]
	
FROM
	STUDENTCTE S
LEFT JOIN
	CORE_ENGLISH2 E
ON
	E.[APS ID] = S.[APS ID]
LEFT JOIN
	CORE_MATH2 M
ON
	M.[APS ID] = S.[APS ID]
LEFT JOIN
	CORE_SCIENCE2 SCI
ON
	SCI.[APS ID] = S.[APS ID]
LEFT JOIN
	CORE_SOCIAL_STUDIES2 SS
ON
	SS.[APS ID] = S.[APS ID]
LEFT JOIN
	GPA G
ON
	G.[APS ID] = S.[APS ID]
LEFT JOIN
	AP_RESULTS A
ON
	A.[APS ID] = S.[APS ID]
LEFT JOIN	
	DUAL_CREDIT2 D
ON
	D.[APS ID] = S.[APS ID]
LEFT JOIN
	TOTAL_ABSENCES T
ON
	T.[Student APS ID] = S.[APS ID]
LEFT JOIN
	SUSPENSIONS SU
ON
	SU.SIS_NUMBER = S.[APS ID]
LEFT JOIN
	ENROLLED_GRADE2014 GR
ON
	GR.[APS ID] = S.[APS ID]
LEFT JOIN
	PARCC_RESULTS P
ON
	P.[STUDENT APS ID] = S.[APS ID]	
LEFT JOIN
	ELL_RESULTS EL
ON
	S.STUDENT_GU = EL.STUDENT_GU
	
)
SELECT * FROM RESULTSCTE WHERE ROWNUM = 1