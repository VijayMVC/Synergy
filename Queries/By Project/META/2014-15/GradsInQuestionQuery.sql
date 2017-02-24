

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT * FROM
  
 
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from GRADUATES2014_2015.csv'
                ) AS [D1]

LEFT JOIN 
(
	SELECT
		SIS_NUMBER
		,SCHOOL_YEAR
		,SCHOOL_CODE
		,ENTER_DATE
		,ENTER_DESCRIPTION
		,LEAVE_DATE
		,LEAVE_DESCRIPTION
		,SCHOOL_NAME
		,SUMMER_WITHDRAWL_CODE
		,SUMMER_WITHDRAWL_DATE
	FROM
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS RN
		FROM
			APS.StudentEnrollmentDetails AS [ENROLLMENTS]
			
		WHERE
			--[ENROLLMENTS].[YEAR_GU] = @YEAR_GU 
			[ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
			--AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL
		) AS [LATEST_ENROLLMENT]
	WHERE
		[RN] = 1
) AS MRENROLL

ON
D1.SIS_NUMBER = MRENROLL.SIS_NUMBER

LEFT JOIN 
(
		SELECT 
				STU.SIS_NUMBER
				,SUM(CREDIT_COMPLETED) AS TOTAL_CREDITS_COMPLETED
				
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
			 GROUP BY STU.SIS_NUMBER
			 ) AS T1

ON
T1.SIS_NUMBER = D1.SIS_NUMBER
