
/*************************************************************

--UPDATE DIPLOMA TYPE TO STANDARD FOR 09-12 WHERE IT IS BLANK

***************************************************************/

BEGIN TRANSACTION

UPDATE REV.EPC_STU 
SET DIPLOMA_TYPE = '01'
FROM 
(
SELECT SIS_NUMBER, STATE_STUDENT_NUMBER
, SCHOOL_CODE, SCHOOL_NAME, DIPLOMA_TYPE, GRADUATION_DATE, GRADUATION_STATUS
, GRADE, YEAR_END_STATUS
, STU.STUDENT_GU  FROM 
REV.EPC_STU AS STU
INNER JOIN 
APS.PrimaryEnrollmentDetailsAsOf('2017-05-25') AS PRIM
ON
STU.STUDENT_GU = PRIM.STUDENT_GU
WHERE
DIPLOMA_TYPE IS NULL
AND GRADE  IN ( '09', '10', '11', '12')
AND SCHOOL_CODE NOT IN ('TRAN', '022', '910')

) AS T1
WHERE
REV.EPC_STU.STUDENT_GU = T1.STUDENT_GU

ROLLBACK