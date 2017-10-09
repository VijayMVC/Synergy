
UPDATE REV.EPC_STU_PGM_ELL_HIS

SET PARTICIPATION_STATUS = PARTICIPATION
FROM 
(
SELECT * FROM(
SELECT 
	
	CASE WHEN PARENT_REFUSED = 'Y' THEN 6
		WHEN COURSE_ID IS NOT NULL AND GRADE IN ('K', '01', '02', '03', '04','05') THEN 8
		WHEN COURSE_ID IS NOT NULL AND GRADE NOT IN ('K', '01', '02', '03', '04','05') THEN 9
	ELSE NULL END AS PARTICIPATION

	,COURSE_ID, GRADE, PARENT_REFUSED, STUDENT_GU

 FROM 
APS.LCEStudentsAndProvidersAsOf_2('20170814') AS SERVICED 
INNER JOIN REV.EPC_STU AS STU
ON
SERVICED.SIS_NUMBER = STU.SIS_NUMBER
) AS T2
WHERE
PARTICIPATION IS NOT NULL

) AS T1

WHERE
REV.EPC_STU_PGM_ELL_HIS.EXIT_REASON IS NULL 
AND REV.EPC_STU_PGM_ELL_HIS.EXIT_DATE IS NULL
AND T1.STUDENT_GU = REV.EPC_STU_PGM_ELL_HIS.STUDENT_GU