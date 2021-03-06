USE 
SCHOOLNET
GO



TRUNCATE TABLE [SchoolNet].[dbo].[IAAT]

INSERT INTO [SchoolNet].[dbo].[IAAT]

SELECT
STUDENT.first_name AS 'Firstname'
,STUDENT.last_name AS 'Lastname'
--,student_name
,student_id AS 'Student ID'
,'2014' AS 'Academic Year'
,STUDENT.grade_code AS 'Grade'
,'' AS 'School Name'
,STUDENT.school_code AS 'School Code'
,LEFT([Overall Exam Score], CHARINDEX('.',[Overall Exam Score])-1) AS 'Overall Exam Score (0-60)'
,[Overall Exam Percent Score] AS 'Overall Exam Percent'
,[Overall Exam Proficiency Level] AS 'Overall Exam Performance Level'
,[Overall Exam Proficiency Level Text] AS 'Overall Exam Performance Level Text'
,LEFT([PART 1 (Time: 10 minutes) Score], CHARINDEX('.',[PART 1 (Time: 10 minutes) Score])-1) AS 'Pre-Algebraic Number Skills & Concepts Score (0-15)'
,[PART 1 (Time: 10 minutes) Percent Score] AS 'Pre-Algebraic Number Skills & Concepts Percent'
,LEFT ([PART 2 (Time: 10 minutes) Score], CHARINDEX('.', [PART 2 (Time: 10 minutes) Score])-1) AS 'Interpreting Mathematical Information Score (0-15)'
,[PART 2 (Time: 10 minutes) Percent Score] AS 'Interpretiing Mathematical Information Percent'
,LEFT([PART 3 (Time: 10 minutes) Score], CHARINDEX('.',[PART 3 (Time: 10 minutes) Score])-1) AS 'Representing Relationships Score (0-15)'
,[PART 3 (Time: 10 minutes) Percent Score] AS 'Representing Relationships Percent'
,LEFT([PART 4 (Time: 10 minutes) Score], CHARINDEX('.',[PART 4 (Time: 10 minutes) Score])-1) AS 'Using Symbols Score (0-15)'
,[PART 4 (Time: 10 minutes) Percent Score] AS 'Using Symbols Percent'
,'2014-2015' AS SCH_YR
,CASE
	WHEN assessment_id = '8478' THEN 'IAAT Form A'
	WHEN assessment_id = '8477' THEN 'IAAT Form B'
	ELSE 'WTF'
END AS Form
,STUDENT.DOB AS DOB


FROM
(
SELECT *
	   ----[assessment_id]
    --  [assessment_name]
    --  ,[assessment_date]
    --  ,[student_id]
    --  ,[student_name]
    --  ,[proficiency_measure]
    --  ,[proficiency_score]
  FROM [SchoolNet].[dbo].[Performance_Tasks]
  PIVOT (MAX (PROFICIENCY_SCORE) FOR PROFICIENCY_MEASURE IN ([Overall Exam Score],[Overall Exam Proficiency Level],[Overall Exam Proficiency Level Text],[Overall Exam Percent Score],[PART 1 (Time: 10 minutes) Score],[PART 1 (Time: 10 minutes) Percent Score],[PART 2 (Time: 10 minutes) Score],[PART 2 (Time: 10 minutes) Percent Score],[PART 3 (Time: 10 minutes) Percent Score],[PART 3 (Time: 10 minutes) Score],[PART 4 (Time: 10 minutes) Percent Score],[PART 4 (Time: 10 minutes) Score])) AS IAAT
) AS T1
--LEFT JOIN
--	[046-WS02].[db_STARS_History].[dbo].[STUDENT] AS STUDENT
--	ON
--	T1.[student_id]= STUDENT.[ALTERNATE STUDENT ID]
--	AND STUDENT.SY = '2015' 
--	AND (STUDENT.PERIOD = '2014-12-15')
--WHERE ASSESSMENT_ID IN ('8477','8478')
----AND student_id = '100013523'
----and student.birthdate is null

LEFT OUTER JOIN
	ALLSTUDENTS AS STUDENT
	ON
	T1.student_id = STUDENT.student_code
WHERE assessment_id IN ('8477','8478')

ORDER BY student.student_code

