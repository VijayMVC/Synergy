

SELECT 
	SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,CASE 
			WHEN T2.EXIT_REASON = 'EY3' THEN '4'
			WHEN T2.EXIT_REASON = 'EY2' THEN '3'
			WHEN T2.EXIT_REASON = 'EY1' THEN '2'
			WHEN T2.STUDENT_GU IS NULL THEN '0'
			WHEN T2.EXIT_REASON IS NULL THEN '1'
		ELSE '' END AS ENGLISH_PROFICIENCY
			

 FROM 
APS.PrimaryEnrollmentsAsOf('2015-10-14') AS PRIM
LEFT JOIN
(
SELECT * FROM (
SELECT 
	STUDENT_GU
	,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTRY_DATE DESC) AS RN
	,ENTRY_DATE
	,EXIT_REASON
	,EXIT_DATE
 FROM 
rev.EPC_STU_PGM_ELL_HIS AS HIST
) AS T1
WHERE
RN = 1
) AS T2

ON
PRIM.STUDENT_GU = T2.STUDENT_GU

INNER JOIN
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU




