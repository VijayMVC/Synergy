
BEGIN TRANSACTION

UPDATE 
rev.EPC_STU_PGM_ELL_HIS

SET EXIT_DATE = NULL, EXIT_REASON = NULL 

FROM 
(
SELECT HIST.STU_PGM_ELL_HIS_GU
FROM 
(
SELECT 
	DISTINCT HIST.STUDENT_GU, STU.SIS_NUMBER
 FROM
APS.LCELatestEvaluationAsOf(GETDATE()) AS ALT
INNER JOIN
rev.EPC_STU_PGM_ELL_HIS AS HIST
ON
ALT.STUDENT_GU = HIST.STUDENT_GU
INNER JOIN
rev.EPC_STU AS STU
ON
HIST.STUDENT_GU = STU.STUDENT_GU

WHERE
TEST_NAME = 'ALT ACCESS'
AND HIST.EXIT_DATE IS NOT NULL
) 
AS ALTKIDS

INNER JOIN

(SELECT 
	STU_PGM_ELL_HIS_GU
	,STUDENT_GU
	,ENTRY_DATE
	,EXIT_DATE
	,EXIT_REASON
	,ROW_NUMBER () OVER(PARTITION BY STUDENT_GU ORDER BY ENTRY_DATE) AS RN

 FROM 
rev.EPC_STU_PGM_ELL_HIS
)

AS HIST

ON
HIST.STUDENT_GU = ALTKIDS.STUDENT_GU

) AS CHANGEALL

WHERE
rev.EPC_STU_PGM_ELL_HIS.STU_PGM_ELL_HIS_GU = CHANGEALL.STU_PGM_ELL_HIS_GU


COMMIT