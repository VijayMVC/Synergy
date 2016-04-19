
/*

BEGIN TRANSACTION 

UPDATE REV.EPC_STU_ENROLL

SET GRADE = SSYFIX.SSY_LU_GRADE

FROM 

(
*/

SELECT 
	STU.SIS_NUMBER, PRIMARIES.GRADE AS SSY_PRIMARY_GRADE,  ENROLLS.GRADE AS ENROLL_ADAS_GRADE,
	PRIMARIES.LU_GRADE AS SSY_LU_GRADE, ENROLLS.LU_GRADE2 AS ENROLL_LU_GRADE, ENROLLS.STUDENT_SCHOOL_YEAR_GU, ENROLLS.ENROLLMENT_GU, PRIMARIES.ORGANIZATION_NAME, Non_Primary_School

 FROM 
(SELECT STUDENT_GU, LU.VALUE_DESCRIPTION AS GRADE, STUDENT_SCHOOL_YEAR_GU
,LU.VALUE_CODE AS LU_GRADE, PRIM.ENROLLMENT_GU, ORGANIZATION_NAME

 FROM APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU
ON
PRIM.GRADE = LU.VALUE_CODE

INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
PRIM.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

) AS PRIMARIES


--GET SECONDARY ENROLLMENTS
INNER JOIN 
 (SELECT * FROM  APS.OpenNonPrimaryEnrollments 
 WHERE Primary_School IS NOT NULL)
 
 AS SSYADAS

ON
SSYADAS.STUDENT_GU = PRIMARIES.STUDENT_GU

INNER JOIN 
rev.EPC_STU AS STU
ON
PRIMARIES.STUDENT_GU = STU.STUDENT_GU
------------------------------------------------------------------------------------------------------

-- GET ENROLL RECORD
INNER JOIN 
(SELECT VALUE_DESCRIPTION AS GRADE, STUDENT_SCHOOL_YEAR_GU, ENROLL.GRADE AS LU_GRADE2, ENROLLMENT_GU  

FROM 
	REV.EPC_STU_ENROLL AS ENROLL

	INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU
ON
ENROLL.GRADE = LU.VALUE_CODE
	
) AS ENROLLS

ON
ENROLLS.STUDENT_SCHOOL_YEAR_GU = SSYADAS.STUDENT_SCHOOL_YEAR_GU
----------------------------------------------------------------------------------------------------


WHERE
ENROLLS.LU_GRADE2 != PRIMARIES.LU_GRADE
AND  PRIMARIES.GRADE NOT IN ('PK', 'P1', 'P2')


/*
) AS SSYFIX

WHERE
SSYFIX.ENROLLMENT_GU= rev.EPC_STU_ENROLL.ENROLLMENT_GU
--AND SSYFIX.LU_GRADE != rev.EPC_STU_ENROLL_ACTIVITY.GRADE

ROLLBACK

*/



