

SELECT
	ID_NBR
	,STATE_ID
	,[SBA SCHOOL YEAR] + ' - ' + [SBA SCH_YR] AS 'SBA SCHOOL YEAR'
	,[SBA GRADE]
	,[SBA TEST]
	,[SBA SS]
	,[SBA PL]
FROM
(
SELECT
	ID_NBR
	,STATE_ID
	,CAST (SBA.school_year AS VARCHAR) AS 'SBA SCHOOL YEAR'
	,CAST (SBA.school_year + 1 AS VARCHAR) AS 'SBA SCH_YR'
	,SBA.test_level_name AS 'SBA GRADE'
	,SBA.test_section_name AS 'SBA TEST'
	,scaled_score AS 'SBA SS'
	,score_group_name AS 'SBA PL'
FROM
(

SELECT
	DISTINCT ID_NBR
	,STUD.state_id
FROM
	[TRASH_Student K3Plus SmartStart Demographics and Attendance 031816] AS K3

LEFT JOIN
	allstudents_ALL AS STUD
	ON K3.ID_NBR = STUD.student_code
) AS IDS

LEFT JOIN
	SBA AS SBA
	ON IDS.ID_NBR = SBA.student_code


  WHERE SBA.test_section_name IN ('MATH','READING','SCIENCE','WRITING')

) AS SBA