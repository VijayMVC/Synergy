

SELECT 
	[SIS Number]
	,STU.STATE_STUDENT_NUMBER
	,[School Code]
	,SCH.[STATE_SCHOOL_CODE]
	,EXCLUDE_ADA_ADM
	,[Member Days] AS DAYS_ATTENDED
	,[Member Days] - [Total Unexcused] AS DAYS_PRESENT
	,CAST(ENTER_DATE AS DATE) AS ENTER_DATE
	,CAST(LEAVE_DATE AS DATE) AS LEAVE_DATE

 FROM 
STUDENT_ATTENDANCE AS ATT
INNER JOIN 
REV.EPC_STU AS STU
ON
ATT.[SIS Number] = STU.SIS_NUMBER
INNER JOIN 
REV.EPC_SCH AS SCH
ON
ATT.[School Code] = SCH.SCHOOL_CODE

WHERE Grade NOT IN ('PK', 'P1', 'P2')

ORDER BY [SIS Number]