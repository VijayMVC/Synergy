/* Dataset 2 for CGSC
GRADE 9 ONLY�this is for any 9th grader GSY 2019 who HAS NOT been reclassified
Student ID APS
Student ID State
Gender
Race (resolved Race with two or more)
Special Ed Status (NOT Including gifted)
Primary Disability
ELL Status (the STARS Definition � 0 = never enrolled; 1 currently enrolled; 2 exited one year, etc)
ELL Exit Date
Algebra Enrollment year
Algebra completion status
Core course (math, English, science and social studies) grade (in tables department will be math, english, science
social studies)
GPA (cumulative)

�	Data Set 2 > 9th grader who has not been reclassified > just include 9th graders with a Grad Standard Year=2019
�	Data Set 2 > Algebra Enrollment Year > check for 1st year student took Algebra class (Deb can tell you what course group to look for)
�	Data Set 2 > Algebra completion Status >  Letter Grade awarded  
*/


;with StudentCTE
as 
(
SELECT	
		'2015-2016' AS [SURVEY SCHOOL YEAR]
		,BS.SIS_NUMBER AS [APS ID]
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
		,CASE
			WHEN [ENGLISH PROFICIENCY] = '0' THEN 'Never Enrolled'
			WHEN [ENGLISH PROFICIENCY] = '1' THEN 'Currently Enrolled'
			WHEN [ENGLISH PROFICIENCY] = '2' THEN 'Exited One Year'
			WHEN [ENGLISH PROFICIENCY] = '3' THEN 'Exited Two Years'
			WHEN [ENGLISH PROFICIENCY] = '4' THEN 'Exited Three + Years'
		END AS [ELL STATUS]
		,CASE WHEN [ENGLISH PROFICIENCY] > 1 THEN CAST(EXIT_DATE AS DATE) 
		      WHEN [ENGLISH PROFICIENCY] = 0 THEN NULL
		END AS [EXIT_DATE]
		,[CURRENT GRADE LEVEL] AS [STUDENT GRADE LEVEL 2016]
		,BS.STUDENT_GU
		--,STU.EXPECTED_GRADUATION_YEAR
		,ROW_NUMBER() over(partition by BS.SIS_NUMBER order by BS.SIS_NUMBER) as RN
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
	left join
	rev.epc_stu stu
	on bs.student_gu = stu.student_gu
	WHERE
	[Period] = '2015-12-15'
	AND [District Code] = '001'
	and [CURRENT GRADE LEVEL] = '09'
	and stu.expected_graduation_year = 2019
)
--select * from StudentCTE where rn = 1
--get algebra scores
,ALGEBRACTE1
AS
(
SELECT
	ROW_NUMBER() OVER(PARTITION BY [APS ID], H.COURSE_TITLE ORDER BY TERM_CODE) AS RN,
	S.[APS ID],
	h.course_title AS H_COURSE_TITLE,
	H.TERM_CODE,
	h.MARK AS ALGEBRA_GRADE,
	h.SCHOOL_YEAR,
	h.CALENDAR_YEAR
from
	rev.EPC_STU_CRS_HIS h
inner join
	rev.UD_CRS_GROUP g
on
	h.COURSE_GU = g.COURSE_GU
INNER JOIN
	STUDENTCTE S
ON
	S.STUDENT_GU = H.STUDENT_GU
where 1 = 1		
AND
	g.[GROUP] in ('ALG 1 S1', 'ALG 1 S2', 'ALG 2 S1', 'ALG 2 S2')
AND
	SCHOOL_YEAR = 2015
GROUP BY
	S.[APS ID],
	H.COURSE_TITLE,
	H.TERM_CODE,
	H.MARK,
	H.SCHOOL_YEAR, 
	H.CALENDAR_YEAR
)

	--SELECT * FROM ALGEBRACTE1 where [APS ID] = 100091446
,ALGEBRACTE2
AS
(
select
	S.[APS ID],
	MAX(CASE WHEN A.RN = 1 THEN H_COURSE_TITLE END) AS COURSE_TITLE_1,
	MAX(CASE WHEN A.RN = 1 THEN ALGEBRA_GRADE END) AS ALGEBRA_GRADE_1,
	MAX(CASE WHEN A.RN = 1 THEN TERM_CODE END) AS ALGEBRA_TERM_CODE_1,
	MAX(CASE WHEN A.RN = 2 THEN H_COURSE_TITLE END) AS COURSE_TITLE_2,
	MAX(CASE WHEN A.RN = 2 THEN ALGEBRA_GRADE END) AS ALGEBRA_GRADE_2,
	MAX(CASE WHEN A.RN = 2 THEN TERM_CODE END) AS ALGEBRA_TERM_CODE_2,
	MAX(CASE WHEN A.RN = 3 THEN H_COURSE_TITLE END) AS COURSE_TITLE_3,
	MAX(CASE WHEN A.RN = 3 THEN ALGEBRA_GRADE END) AS ALGEBRA_GRADE_3,
	MAX(CASE WHEN A.RN = 3 THEN TERM_CODE END) AS ALGEBRA_TERM_CODE_3,
	MAX(CASE WHEN A.RN = 4 THEN H_COURSE_TITLE END) AS COURSE_TITLE_4,
	MAX(CASE WHEN A.RN = 4 THEN ALGEBRA_GRADE END) AS ALGEBRA_GRADE_4,
	MAX(CASE WHEN A.RN = 4 THEN TERM_CODE END) AS ALGEBRA_TERM_CODE_4


FROM	
	ALGEBRACTE1 A
LEFT JOIN
	StudentCTE S
ON
	 A.[APS ID] = S.[APS ID]	
GROUP BY
	S.[APS ID],
	H_COURSE_TITLE
)

--select * from ALGEBRACTE2 WHERE [APS ID]	 = 100091446

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
	S.[ELL STATUS],
	CAST(S.EXIT_DATE AS DATE) AS [ELL EXIT DATE],
	--a.SCHOOL_YEAR,
	--a.CALENDAR_YEAR,
	A.ALGEBRA_TERM_CODE_1,
	A.COURSE_TITLE_1,
	A.ALGEBRA_GRADE_1,
	A.ALGEBRA_TERM_CODE_2,
	A.COURSE_TITLE_2,
	A.ALGEBRA_GRADE_2,
	A.ALGEBRA_TERM_CODE_3,
	A.COURSE_TITLE_3,
	A.ALGEBRA_GRADE_3,
	A.ALGEBRA_TERM_CODE_4,
	A.COURSE_TITLE_4,
	A.ALGEBRA_GRADE_4,
	E.[ ENGLISH GRADE],
	M.[ MATH GRADE],
	SCI.[ SCIENCE GRADE],
	SS.[ SOCIAL STUDIES GRADE],
	G.[HS Cum Flat],
	G.[HS Cum Weighted]
	
FROM
	STUDENTCTE S
LEFT JOIN
	ALGEBRACTE2 A
ON
	A.[APS ID] = S.[APS ID]
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
)
SELECT * FROM RESULTSCTE WHERE ROWNUM = 1 