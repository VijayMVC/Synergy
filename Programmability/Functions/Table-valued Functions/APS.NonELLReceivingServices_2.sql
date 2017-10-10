USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[NonELLReceivingServicesAsOf]    Script Date: 10/6/2017 1:08:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER FUNCTION [APS].[NonELLReceivingServicesAsOf_2](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT 
	ORGANIZATION_NAME	
	,SIS_NUMBER

	,STU_NAME
	,GRADE
	,TEST_NAME
	, PERFORMANCE_LEVEL
	,TEST_SCORE
	,SCORE_DESCRIPTION

	,ENTER_DATE
	,BADGE_NUM

	,COURSE_ID
	,SECTION_ID
	,COURSE_TITLE

	,STAFF_NAME
	
	,PRIMARY_DISABILITY_CODE
	,CASE WHEN WAIVER_TYPE = 'RALS' THEN 'Y' ELSE '' END AS PARENT_REFUSED

	,CASE 
		WHEN (STAFF_NAME  IS NULL AND WAIVER_TYPE = 'RALS') THEN 'Parent Refused' 
		WHEN (STAFF_NAME  IS NULL AND WAIVER_TYPE IS NULL) THEN 'No Appropriate Course Assigned'
	ELSE ''	END AS [STATUS]

	,ORGANIZATION_GU
	,LIST_ORDER
	,STUGUID
	,GOODWAIVER

	FROM 
	(
SELECT 
	ORG.ORGANIZATION_NAME	
	,BS.SIS_NUMBER

	,ISNULL(BS.LAST_NAME,'')  + ' ' + ISNULL(BS.FIRST_NAME,'') +  ISNULL(', ' +BS.MIDDLE_NAME,'') AS STU_NAME
	,GRADE.VALUE_DESCRIPTION AS GRADE
	,LE.TEST_NAME
	,PF.VALUE_DESCRIPTION AS PERFORMANCE_LEVEL
    ,SCORES.TEST_SCORE
	,SCORETDEF.SCORE_DESCRIPTION
	,ELL.ENTER_DATE
	,STAFF2.BADGE_NUM
	,COURSE_ID
	,SECTION_ID
	,COURSE_TITLE
	
	,STAFF.LAST_NAME + ', ' +  STAFF.FIRST_NAME AS STAFF_NAME
	
	,PRIMARY_DISABILITY_CODE
	,PARENTREFUSAL.WAIVER_TYPE

	,CASE WHEN WAIVER.WAIVER_ENTER_DATE IS NOT NULL
		AND WAIVER.WAIVER_GRADE IS NOT NULL
		AND WAIVER.WAIVER_TYPE IS NOT NULL
		AND WAIVER.WAIVER_STATUS IS NOT NULL
		AND WAIVER.WAIVER_STATUS_DATE IS NOT NULL
		AND WAIVER.WAIVER_EXIT_DATE IS NULL THEN 'Y' ELSE 'N' END AS GOODWAIVER


	--KEEP OVERALL AND NOT THE SCALE SCORE IF THERE IS MORE THAN ONE RECORD, FOR ACCESS, WAPT, LAS, PRE-LAS, NMELPA ETC HAVE ONLY 1 SCORE
	--1 SCORE FOR EACH COURSE
	,ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER, LE.TEST_NAME, COURSE_ID ORDER BY SCORE_DESCRIPTION) AS RN
	,ORG.ORGANIZATION_GU
	,GRADE.LIST_ORDER
	,ELL.STUDENT_GU AS STUGUID
 FROM

APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS PRIM
LEFT JOIN 

APS.ELLCalculatedAsOf (@AsOfDate) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU

LEFT JOIN 
APS.LCELatestEvaluationAsOf (@AsOfDate) AS LE
ON
LE.STUDENT_GU = PRIM.STUDENT_GU


LEFT JOIN rev.EPC_STU_TEST_PART AS PARTS
ON
	PARTS.STUDENT_TEST_GU = LE.STUDENT_TEST_GU

LEFT JOIN
	rev.EPC_STU_TEST_PART_SCORE AS SCORES
	ON
	SCORES.STU_TEST_PART_GU = PARTS.STU_TEST_PART_GU

	LEFT JOIN
	rev.EPC_TEST_SCORE_TYPE AS SCORET
	ON
	SCORET.TEST_GU = LE.TEST_GU
	AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU
	
	LEFT JOIN
	rev.EPC_TEST_DEF_SCORE AS SCORETDEF
	ON
	SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

LEFT JOIN
	(
SELECT 
		SCH.STUDENT_GU
		,SCH.STAFF_GU
		,SCH.ORGANIZATION_GU
		,SCH.COURSE_ID
		,SCH.SECTION_ID
		,SCH.COURSE_TITLE
		,SCH.ORGANIZATION_YEAR_GU
	 FROM
		APS.ScheduleAsOf (@AsOfDate) AS SCH
		INNER JOIN
	REV.EPC_CRS AS CRS
	ON
	SCH.COURSE_GU = CRS.COURSE_GU
	INNER JOIN 
	REV.EPC_CRS_LEVEL_LST AS LST
	ON
	CRS.COURSE_GU = LST.COURSE_GU
	WHERE
		COURSE_LEVEL = 'ESL'

) AS TAGGED

ON
PRIM.STUDENT_GU = TAGGED.STUDENT_GU
AND PRIM.ORGANIZATION_YEAR_GU = TAGGED.ORGANIZATION_YEAR_GU

LEFT HASH JOIN
rev.REV_PERSON AS STAFF
ON
TAGGED.STAFF_GU = STAFF.PERSON_GU

LEFT HASH JOIN
(
SELECT
	CurrentSPED.STUDENT_GU
	,CurrentSPED.PRIMARY_DISABILITY_CODE		
	
FROM	
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enrollment
	LEFT JOIN
	(
	SELECT
		STUDENT_GU
		,PRIMARY_DISABILITY_CODE
	FROM
		REV.EP_STUDENT_SPECIAL_ED AS SPED
	WHERE
		NEXT_IEP_DATE IS NOT NULL
		AND (
			EXIT_DATE IS NULL 
			OR EXIT_DATE >= CONVERT(DATE, @AsOfDate)
			)
	) AS CurrentSPED
	ON
	Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU
WHERE 
	CurrentSPED.STUDENT_GU IS NOT NULL

	) AS SPED

	ON
	PRIM.STUDENT_GU = SPED.STUDENT_GU

	LEFT JOIN
	APS.LCEMostRecentALSRefusalAsOf (@AsOfDate) AS PARENTREFUSAL
	ON
	PARENTREFUSAL.STUDENT_GU = PRIM.STUDENT_GU

	INNER JOIN
	APS.LookupTable ('K12','Grade') GRADE
	ON
	PRIM.GRADE = GRADE.VALUE_CODE

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	ORGYR.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	ORG.ORGANIZATION_GU = ORGYR.ORGANIZATION_GU

	LEFT HASH JOIN
	rev.EPC_STAFF AS STAFF2
	ON
	STAFF.PERSON_GU = STAFF2.STAFF_GU

	LEFT JOIN
	APS.LookupTable ('K12.TestInfo',	'PERFORMANCE_LEVELS') AS PF
	ON
	LE.PERFORMANCE_LEVEL = PF.VALUE_CODE

	LEFT JOIN
	REV.EPC_STU_PGM_ELL_WAV WAIVER 
	ON WAIVER.STUDENT_GU = PRIM.STUDENT_GU
	


) AS T1
WHERE
RN = 1
AND STUGUID IS NULL
AND COURSE_ID IS NOT NULL



GO


