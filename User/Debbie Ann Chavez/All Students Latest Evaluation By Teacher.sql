
SELECT SCHOOL_CODE, SCHOOL_NAME, PRIM.GRADE, TEST.PERFORMANCE_LEVEL,COURSE_ID, SECTION_ID, COURSE_TITLE
	,PERS.LAST_NAME, PERS.FIRST_NAME
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
LEFT JOIN 
APS.LCELatestEvaluationAsOf(GETDATE()) AS TEST
ON
PRIM.STUDENT_GU = TEST.STUDENT_GU
INNER JOIN 
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU 

LEFT JOIN 
( SELECT SCH.STAFF_GU, SCH.SIS_NUMBER, SCH.COURSE_ID, SCH.SECTION_ID, SCH.COURSE_TITLE FROM 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
) AS TEACHERS
ON
TEACHERS.SIS_NUMBER = STU.SIS_NUMBER 

LEFT JOIN 
rev.REV_PERSON AS PERS
ON
PERS.PERSON_GU = TEACHERS.STAFF_GU

WHERE
SCHOOL_CODE = '270'


ORDER BY SCHOOL_CODE