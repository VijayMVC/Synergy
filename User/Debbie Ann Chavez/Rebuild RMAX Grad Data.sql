

SELECT 
	STU.SIS_NUMBER
	,BS.LAST_NAME
	,BS.FIRST_NAME
	,enroll.GRADE
	,STU.EXPECTED_GRADUATION_YEAR
	,CASE WHEN  STU.GRADUATION_STATUS IS NULL THEN STU.USER_CODE_2 ELSE GRADUATION_STATUS END AS GRADUATION_STATUS
	,CASE WHEN STU.POST_SECONDARY IS NULL THEN STU.USER_CODE_4 ELSE POST_SECONDARY END AS POST_SECONDARY
	,STU.GRADUATION_DATE 
	,CASE WHEN STU.DIPLOMA_TYPE IS NULL THEN STU.USER_CODE_3 ELSE DIPLOMA_TYPE END AS DIPLOMA_TYPE
	,TRANS.TOTAL AS EARNED_CREDITS_TOTAL
FROM 
APS.BasicStudent AS BS
INNER JOIN 
rev.EPC_STU AS STU
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
			 ) AS TRANS
ON
TRANS.STUDENT_GU = STU.STUDENT_GU

INNER JOIN 
APS.PrimaryEnrollmentDetailsAsOf('20110531') AS ENROLL
ON
ENROLL.STUDENT_GU = STU.STUDENT_GU

WHERE
ENROLL.SCHOOL_CODE = '540'
