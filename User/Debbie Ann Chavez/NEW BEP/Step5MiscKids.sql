


/*******************************************************************************************

-- FOR RECORDS THAT ARE NOT PULLED WITH THE NIGHTLY PROCESS (BECAUSE OF BACKDATED SCHEDULES)
-- AND DO NOT HAVE A COURSE LEAVE DATE, THESE MAY BE STUDENTS WHERE THE TEACHER CHANGED AND IS NOT QUALIFIED ANYMORE
-- USE CURRENT DATE TO CLOSE OUT 

********************************************************************************************/



UPDATE REV.EPC_STU_PGM_ELL_BEP 
	SET EXIT_DATE = GETDATE(), [CHANGE_ID_STAMP] = '27CDCD0E-BF93-4071-94B2-5DB792BB735F', [CHANGE_DATE_TIME_STAMP] = GETDATE()

--SELECT * 

FROM (
SELECT 
	
	KIDSBACKDATED.SIS_NUMBER
	,KIDSBACKDATED.STU_PGM_ELL_BEP_GU
	,ESLBEPCLASSES.COURSE_EXIT_DATE

-----------------------FOR THESE STUDENTS -----------------------------------------
FROM (
 SELECT
	STU.STUDENT_GU, STU.SIS_NUMBER, BEP.STU_PGM_ELL_BEP_GU
 FROM 
REV.EPC_STU_PGM_ELL_BEP AS BEP
LEFT JOIN 
(
	SELECT 
		NEWID() AS STU_PGM_ELL_BEP
		,STU.STUDENT_GU AS STUDENT_GU
		,STU.SIS_NUMBER
		,MAX(SCH.COURSE_ENTER_DATE) AS ENTER_DATE
		,LU.VALUE_CODE AS PROGRAM_CODE
		,BEP.[HOUR] AS PROGRAM_INTENSITY
		--, BEP.MODEL, 
		,SCH.COURSE_LEAVE_DATE AS EXIT_DATE
		,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS [ADD_ID_STAMP]
		,GETDATE() AS [ADD_DATE_TIME_STAMP]
		, NULL AS [CHANGE_ID_STAMP]
		, NULL AS [CHANGE_DATE_TIME_STAMP]

	 FROM 
		APS.NewBEPStudentsModelsAndHoursAsOf(GETDATE()) AS BEP
		INNER HASH JOIN 
		REV.EPC_STU AS STU
		ON
		BEP.SIS_NUMBER = STU.SIS_NUMBER
		INNER HASH JOIN 
		APS.NewBEPModelsAndHoursDetailsAsOf(GETDATE()) AS MODELS
		ON
		BEP.SIS_NUMBER = MODELS.SIS_NUMBER
		INNER HASH JOIN 
		APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
		ON
		SCH.SIS_NUMBER = MODELS.SIS_NUMBER
		AND SCH.ORGANIZATION_NAME = MODELS.SCHOOL_NAME
		AND SCH.COURSE_ID = MODELS.COURSE_ID
		AND SCH.SECTION_ID = MODELS.SECTION_ID
		INNER JOIN 
		APS.LookupTable ('K12.ProgramInfo', 'BEP_PROGRAM_CODE') AS LU
		ON
		LU.VALUE_DESCRIPTION = BEP.MODEL

	--WHERE STU.SIS_NUMBER = 980001535

	GROUP BY STU.STUDENT_GU, STU.SIS_NUMBER, BEP.[HOUR], BEP.MODEL, VALUE_CODE, COURSE_LEAVE_DATE
) AS UNIQUERECORDS

	ON
	BEP.STUDENT_GU = UNIQUERECORDS.STUDENT_GU
	INNER JOIN 
	REV.EPC_STU AS STU
	ON
	STU.STUDENT_GU = BEP.STUDENT_GU
		
WHERE
	UNIQUERECORDS.STUDENT_GU IS NULL 
	AND BEP.EXIT_DATE IS NULL

) AS KIDSBACKDATED
-----------------------------------------------------------------------------------------------------------

LEFT JOIN 
(
SELECT 
	SCH.STUDENT_GU, MAX(COURSE_LEAVE_DATE) AS COURSE_EXIT_DATE
 FROM 
APS.ScheduleForYear('A3F9F1FB-4706-49AA-B3A3-21F153966191') AS SCH
INNER JOIN 
REV.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
WHERE COURSE_LEVEL IN ('BEP', 'ESL') AND COURSE_LEAVE_DATE IS NOT NULL
GROUP BY STUDENT_GU 
) AS ESLBEPCLASSES

ON
KIDSBACKDATED.STUDENT_GU = ESLBEPCLASSES.STUDENT_GU

) AS CLOSEOUT


WHERE

REV.EPC_STU_PGM_ELL_BEP.STU_PGM_ELL_BEP_GU = CLOSEOUT.STU_PGM_ELL_BEP_GU
AND
 CLOSEOUT.COURSE_EXIT_DATE IS NULL



