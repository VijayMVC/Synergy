

SELECT 
	SIS_NUMBER, GRADE, SCHOOL_CODE, SCHOOL_NAME, COURSE_ID, COURSE_TITLE, SECTION_ID, DEPARTMENT, SUBJECT_AREA_1

 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
WHERE
(SCH.COURSE_TITLE LIKE '%MATH%'
OR SCH.COURSE_TITLE LIKE '%MTH%')
AND SCH.DEPARTMENT != 'Math'
AND GRADE > '05'
AND GRADE != 'K'

ORDER BY SCHOOL_CODE, SIS_NUMBER