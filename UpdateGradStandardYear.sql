
BEGIN TRANSACTION

UPDATE [REV].[EPC_STU]

SET
       EXPECTED_GRADUATION_YEAR = CASE
             WHEN GRADE = '06' THEN 2022
             WHEN GRADE = '07' THEN 2021
             WHEN GRADE = '08' THEN 2020
       END
	,CHANGE_DATE_TIME_STAMP = GETDATE()
	,CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'

FROM 
(
SELECT EXPECTED_GRADUATION_YEAR, GRADE, A.STUDENT_GU from  [REV].[EPC_STU] A
join  [APS].[PrimaryEnrollmentDetailsAsOf] (GETDATE()) B
on A.STUDENT_GU=B.STUDENT_GU
WHERE GRADE IN ('06', '07', '08')
) AS T1

WHERE
[REV].[EPC_STU].STUDENT_GU = T1.STUDENT_GU

COMMIT