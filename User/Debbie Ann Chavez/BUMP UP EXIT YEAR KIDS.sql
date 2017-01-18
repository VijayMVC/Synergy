
/******************  THIS IS TO BUMP UP THE EY1'S AND 2'S*************************


SELECT SIS_NUMBER, ENTRY_DATE, EXIT_DATE, EXIT_REASON FROM (
SELECT 
	STUDENT_GU
	,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTRY_DATE DESC) AS RN
	,ENTRY_DATE
	,EXIT_REASON
	,EXIT_DATE
 FROM 
rev.EPC_STU_PGM_ELL_HIS AS HIST
) AS T1
INNER JOIN 
APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PRIM
ON
T1.STUDENT_GU = PRIM.STUDENT_GU
INNER JOIN 
rev.EPC_STU AS STU
ON
PRIM.STUDENT_GU = STU.STUDENT_GU

WHERE
RN = 1
AND EXIT_REASON = 'EY2'
--AND EXIT_DATE < '2016-07-01'


ORDER BY EXIT_REASON, ENTRY_DATE


*****************************************************************************************************/

/*THIS IS TO CREATE EY1 RECORDS FOR THE STUDENTS THAT TESTED PROFICIENT AND SHOULD NOT BE ELL ANYMORE 

*********************************************************************************************************/

BEGIN TRANSACTION 

INSERT INTO
rev.EPC_STU_PGM_ELL_HIS 

([STU_PGM_ELL_HIS_GU]
      ,[STUDENT_GU]
      ,[PROGRAM_CODE]
      ,[ENTRY_DATE]
      ,[PARTICIPATION_STATUS]
      ,[EXIT_DATE]
      ,[EXIT_REASON]
      ,[ELL_GRADE]
      ,[LANGUAGE_ABILITY]
      ,[DES_CURRENT_CODE]
      ,[DES_CURRENT_DATE]
      ,[DOCUMENT_DATE]
      ,[DOCUMENT_NUMBER]
      ,[MAINSTREAM_ELIGIBILITY]
      ,[CHANGE_ID_STAMP]
      ,[CHANGE_DATE_TIME_STAMP]
      ,[ADD_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP]
      ,[PROGRAM_QUALIFICATION]
	  )

SELECT 
	--DISTINCT ADMIN_DATE
	NEWID() AS STU_PGM_ELL_HIS_GU
	,STU.STUDENT_GU AS STUDENT_GU
	,1 AS PROGRAM_CODE
	,'2015-08-13' AS ENTRY_DATE
	,NULL AS PARTICAPATION_STATUS
	,NULL AS EXIT_DATE
	,'EY1' AS EXIT_REASON
	,NULL AS ELL_GRADE
	,NULL AS LANGUAGE_ABILITY
	,NULL AS DES_CURRENT_CODE
	,NULL AS DES_CURRENT_DATE
	,NULL AS DOCUMENT_DATE
	,NULL AS DOCUMENT_NUMBER
	,NULL AS MAINSTREAM_ELIGIBILITY
	,NULL AS CHANGE_ID_STAMP
	,NULL AS CHANGE_DATE_TIME_STAMP
	,GETDATE() AS [ADD_DATE_TIME_STAMP]
    ,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS [ADD_ID_STAMP]
	,1 AS PROGRAM_QUALIFICATION
			
	--SIS_NUMBER, LASTTEST.PERFORMANCE_LEVEL, LASTTEST.TEST_NAME, LASTTEST.ADMIN_DATE
 FROM 
APS.LCELatestEvaluationAsOf(GETDATE()) AS LASTTEST
INNER JOIN 
rev.EPC_STU AS STU 
ON
LASTTEST.STUDENT_GU = STU.STUDENT_GU

WHERE 
IS_ELL = 0
AND ADMIN_DATE BETWEEN '2014-07-01' AND '2015-07-01'



ROLLBACK 
