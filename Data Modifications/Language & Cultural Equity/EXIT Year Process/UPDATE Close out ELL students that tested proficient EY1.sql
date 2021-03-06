
/********************************************************************************
	CREATED BY DEBBIE ANN CHAVEZ	
	DATE 7/1/2015

	THIS PROCESS CLOSES OUT THE ELL RECORD WITH AN EY1 FOR STUDENTS THAT 
	TESTED PROFICIENT

	CHANGE THE DATE RANGE OF THE TEST ASSESSMENTS AND CHANGE THE CLOSE OUT DATE

*********************************************************************************/
BEGIN TRANSACTION

UPDATE rev.EPC_STU_PGM_ELL_HIS
SET 	
	EXIT_REASON = 'EY1'
	--CHANGE THIS DATE
	, EXIT_DATE = '2016-07-01',
	CHANGE_DATE_TIME_STAMP = GETDATE() 
	,CHANGE_ID_STAMP =   '27CDCD0E-BF93-4071-94B2-5DB792BB735F'

--SELECT HISTORY.EXIT_REASON, EXIT_DATE, SIS_NUMBER, TEST_NAME
FROM 
APS.LCELatestEvaluationAsOf(GETDATE()) AS LASTTEST
INNER JOIN 
rev.EPC_STU AS STU 
ON
LASTTEST.STUDENT_GU = STU.STUDENT_GU
INNER JOIN
rev.EPC_STU_PGM_ELL_HIS AS HISTORY
ON
STU.STUDENT_GU = HISTORY.STUDENT_GU

WHERE 
IS_ELL = 0

--CHANGE THESE VALUES
AND ADMIN_DATE BETWEEN '2015-07-01' AND '2016-07-01'

ROLLBACK