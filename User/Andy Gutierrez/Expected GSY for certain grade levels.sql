 SELECT SIS_NUMBER, GRADE, SCHOOL_NAME, EXPECTED_GRADUATION_YEAR FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU
WHERE
GRADE IN ('06', '07', '08')