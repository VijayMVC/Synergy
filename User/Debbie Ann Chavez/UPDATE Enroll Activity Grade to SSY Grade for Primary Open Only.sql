
BEGIN TRANSACTION 

UPDATE REV.EPC_STU_ENROLL_ACTIVITY

SET GRADE = LU_GRADE

FROM 

(

SELECT 
	SIS_NUMBER, PRIMARIES.GRADE AS SSY_PRIMARY_GRADE,  ENROLLS.GRADE AS ENROLL_GRADE, ACTIVITY_GRADE 
	,PRIMARIES.LU_GRADE, ENROLLS.LU_GRADE2, PRIMARIES.ENROLLMENT_GU, ORGANIZATION_NAME

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

INNER JOIN 

(SELECT LU.VALUE_DESCRIPTION AS GRADE, STUDENT_SCHOOL_YEAR_GU, ACT.GRADE AS LU_GRADE2
,ENROLL.ENROLLMENT_GU, LU2.VALUE_DESCRIPTION AS ACTIVITY_GRADE 

FROM 
	REV.EPC_STU_ENROLL AS ENROLL

	INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU
ON
ENROLL.GRADE = LU.VALUE_CODE

INNER JOIN 
rev.EPC_STU_ENROLL_ACTIVITY AS ACT
ON
ENROLL.ENROLLMENT_GU = ACT.ENROLLMENT_GU

INNER JOIN 
APS.LookupTable('K12', 'GRADE') AS LU2
ON
ACT.GRADE = LU2.VALUE_CODE
	
) AS ENROLLS

ON
ENROLLS.ENROLLMENT_GU = PRIMARIES.ENROLLMENT_GU

INNER JOIN 
rev.EPC_STU AS STU
ON
PRIMARIES.STUDENT_GU = STU.STUDENT_GU

WHERE
ENROLLS.LU_GRADE2 != PRIMARIES.LU_GRADE
AND  PRIMARIES.GRADE NOT IN ('PK', 'P1', 'P2')



) AS SSYFIX


WHERE
SSYFIX.ENROLLMENT_GU= rev.EPC_STU_ENROLL_ACTIVITY.ENROLLMENT_GU
AND SSYFIX.LU_GRADE != rev.EPC_STU_ENROLL_ACTIVITY.GRADE

ROLLBACK


