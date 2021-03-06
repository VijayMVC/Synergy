

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

UPDATE REV.EPC_STU_SCH_YR 
	SET ATTEND_PERMIT_CODE = 'TRAN', ATTEND_PERMIT_DATE = '2015-04-01'
	, CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F', CHANGE_DATE_TIME_STAMP = GETDATE()
	
FROM (
	SELECT DISTINCT
		STUDENT_SCHOOL_YEAR_GU
FROM
( SELECT 		
	CASE  
		WHEN STU.STUDENT_GU IS NULL THEN 'No SIS Number Found'
		WHEN PRIM.STUDENT_GU IS NULL THEN 'No 2016-2017 Enrollment found' 
		WHEN PRIM.STUDENT_GU IS NOT NULL AND PRIM.GRADE IN ('05', '08') THEN '5TH/8TH GRADE Do Not Update'
		WHEN PRIM.STUDENT_GU IS NOT NULL AND PRIM.SCHOOL_CODE != [App Loc] THEN 'Not Same School Do Not Update'
	ELSE 'UPDATE' END AS [ACTION]
	,PRIM.STUDENT_SCHOOL_YEAR_GU
	,PRIM.SCHOOL_NAME AS PRIMARY_SCHOOL
	,PRIM.GRADE AS PRIMARY_GRADE
	,'2015-04-01' AS [TRANSFER_DATE_APPROVED]

	,ROLL.*

 FROM
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from AllRollovers.csv'
                ) AS [ROLL]
			LEFT JOIN 
			rev.EPC_STU AS STU
			ON
			ROLL.[APS ID] = STU.SIS_NUMBER

LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
ON
STU.STUDENT_GU = PRIM.STUDENT_GU
) AS T1 
	WHERE [ACTION] = 'UPDATE'

)  AS T2

WHERE 
	T2.STUDENT_SCHOOL_YEAR_GU = rev.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU
	AND rev.EPC_STU_SCH_YR.ATTEND_PERMIT_DATE IS NULL 
	--AND rev.EPC_STU_SCH_YR.ATTEND_PERMIT_DATE IS NULL

ROLLBACK


