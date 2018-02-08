BEGIN TRAN
DECLARE @TestWindow VARCHAR(10) 
SET @TestWindow = 'Spring'
SELECT
	(fld_LST_NME + ', ' + fld_FRST_NME) AS [STUDENT NAME]
	,fld_ID_NBR AS [STUDENT ID]
	,fld_GRDE AS [GARDE LEVEL]
	,fld_TestLoc AS [TEST LOCATION]
	,fld_AssessmentWindow AS [ASSESSMENT WINDOW]
	,fld_Q1 AS [CLASSROOM BEHAVIOR Q1]
	,fld_Q2 AS [CLASSROOM BEHAVIOR Q2]
	,fld_Q3 AS [CLASSROOM BEHAVIOR Q3]
	,fld_Q4 AS [CLASSROOM BEHAVIOR Q4]
	,fld_Q5 AS [CLASSROOM BEHAVIOR Q5]
	,fld_Q6 AS [CLASSROOM BEHAVIOR Q6]
	,fld_Q7 AS [PHYSICAL DEVELOPMENT Q7]
	,fld_Q8 AS [PHYSICAL DEVELOPMENT Q8]
	,fld_Q9 AS [PHYSICAL DEVELOPMENT Q9]
	,fld_Q10 AS[VISUAL ARTS MUSIC Q 10]
	,fld_Q11 AS[VISUAL ARTS MUSIC Q 11]
	,fld_Q12 AS[SCIENCE HEALT AND SAFETY Q12]
	,fld_Q13 AS[SCIENCE HEALT AND SAFETY Q13]
	,fld_Q14 AS[SCIENCE HEALT AND SAFETY Q14]
	,fld_Q15 AS[SOCIAL STUDIES Q15]
	,fld_Q16 AS[SOCIAL STUDIES Q16]
	,fld_Q17 AS [MATH Q17]
	,fld_Q18 AS [MATH Q18]
	,fld_Q19 AS [MATH Q19]
	,fld_Q20 AS [MATH Q20]
	,fld_Q21 AS [MATH Q21]
	,fld_Q22 AS [MATH Q22]
	,fld_Q23 AS [MATH Q23]
	,fld_Q24 AS [MATH Q24]
	,fld_Q25 AS [MATH Q25]
	,fld_Q27 AS [ELA FOUNDATION READING SKILLS Q27]
	,fld_Q28 AS [ELA FOUNDATION READING SKILLS Q28]
	,fld_Q29 AS [ELA FOUNDATION READING SKILLS Q29]
	,fld_Q30 AS [ELA FOUNDATION READING SKILLS Q30]
	,fld_Q31 AS [ELA LITERATURE Q31]
	,fld_Q32 AS [ELA LITERATURE Q32]
	,fld_Q33 AS [ELA LITERATURE Q33]
	,fld_Q34 AS [ELA INFORMATION TEXT Q34]
	,fld_Q35 AS [ELA INFORMATION TEXT Q35]
	,fld_Q37 AS [ELA WRITING Q37]
	,fld_Q38 AS [ELA WRITING Q38]
	,fld_Q39 AS [ELA SPEAKING AND LISTENING Q39]
	,fld_Q40 AS [ELA SPEAKING AND LISTENING Q40]
FROM
	[046-WS02].db_KDPR.dbo.Results AS KSBPR
WHERE
	KSBPR.fld_AssessmentWindow = @TestWindow	
	AND fld_ID_NBR > 100

ROLLBACK