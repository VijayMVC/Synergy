

SELECT 
	SIS_NUMBER
	,LAST_NAME, FIRST_NAME, MIDDLE_NAME
	, PRIM.SCHOOL_CODE, PRIM.SCHOOL_NAME, PRIM.GRADE
	,'Changed PHLOTE Status' AS EXIT_REASON
	, EXIT_DATE 
	,TEST.TEST_NAME
	,TEST.ADMIN_DATE AS TEST_DATE
	,LU.VALUE_DESCRIPTION AS PERFORMANCE_LEVEL

FROM 
REV.EPC_STU_PGM_ELL AS PGM
INNER JOIN 
REV.EPC_STU AS STU
ON
PGM.STUDENT_GU = STU.STUDENT_GU
LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf('20170814') AS PRIM 
ON
PRIM.STUDENT_GU = PGM.STUDENT_GU
LEFT JOIN 
APS.LCELatestEvaluationAsOf(GETDATE()) AS TEST
ON
TEST.STUDENT_GU = PGM.STUDENT_GU
LEFT JOIN 
APS.LookupTable('K12.TESTINFO','PERFORMANCE_LEVELS') AS LU
ON
LU.VALUE_CODE = TEST.PERFORMANCE_LEVEL
INNER JOIN 
REV.REV_PERSON AS PERS
ON
STU.STUDENT_GU = PERS.PERSON_GU


WHERE
EXIT_REASON = 'EY-'

ORDER BY EXIT_DATE