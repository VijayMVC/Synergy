


SELECT 
	SCHOOL_NAME, SCHOOL_CODE, BS.SIS_NUMBER, LAST_NAME, FIRST_NAME, GRADE, STU.EXPECTED_GRADUATION_YEAR, TOTAL AS TOTAL_CREDITS_EARNED
	   
	   ,CASE
	    WHEN EXPECTED_GRADUATION_YEAR = '2021' THEN '<6'  
	    WHEN EXPECTED_GRADUATION_YEAR = '2020' THEN '6-12.99999'
	    WHEN EXPECTED_GRADUATION_YEAR = '2019' THEN '13-18.99999'
	    WHEN EXPECTED_GRADUATION_YEAR <= '2018' THEN '>=19'
	    ELSE ''
     END AS EXPECTED_CREDITS


		,CASE 
				--9th
				 WHEN  EXPECTED_GRADUATION_YEAR =2021  AND TOTAL > 6.00 THEN 'OutsideCreditRangeforGradYear'

				--10
				 WHEN  EXPECTED_GRADUATION_YEAR =2020  AND TOTAL <6.00 THEN 'OutsideCreditRangeforGradYear'
				 WHEN  EXPECTED_GRADUATION_YEAR =2020  AND TOTAL >=13.00 THEN 'OutsideCreditRangeforGradYear'

				-- 11
				 WHEN  EXPECTED_GRADUATION_YEAR =2019  AND TOTAL <13.00 THEN 'OutsideCreditRangeforGradYear'
				 WHEN  EXPECTED_GRADUATION_YEAR =2019  AND TOTAL >=19.00 THEN 'OutsideCreditRangeforGradYear'

				-- 12+
				 WHEN  EXPECTED_GRADUATION_YEAR <=2018  AND TOTAL < 19.00 THEN 'OutsideCreditRangeforGradYear'
	
			ELSE ''
		END AS RECLASSIFY_ICON



 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.BasicStudentWithMoreInfo AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
INNER JOIN 
REV.EPC_STU AS STU
ON
BS.STUDENT_GU = STU.STUDENT_GU 

LEFT JOIN 
	(
		SELECT 
				SUM(CREDIT_COMPLETED) AS TOTAL
				,STU.STUDENT_GU 
			 FROM 

			rev.EPC_STU_CRS_HIS AS HIS
			INNER JOIN 
			REV.EPC_STU AS STU
			ON
			HIS.STUDENT_GU = STU.STUDENT_GU
			LEFT JOIN
			[rev].[EPC_REPEAT_TAG] AS [Repeat]
			ON
			HIS.[REPEAT_TAG_GU]=[Repeat].[REPEAT_TAG_GU]

			WHERE
			HIS.COURSE_HISTORY_TYPE = 'HIGH'
			 AND ISNULL([Repeat].[REPEAT_CODE],'')!='R'
			 GROUP BY STU.STUDENT_GU
			 ) AS T1
ON
T1.STUDENT_GU = STU.STUDENT_GU


WHERE
GRADE >='09'
AND GRADE NOT IN ('K', 'PK', 'P1', 'P2')

ORDER BY EXPECTED_GRADUATION_YEAR