
EXECUTE AS LOGIN='QueryFileUser'
GO


--DECLARE @AsOfDate AS DATETIME = '2014-12-15'
	   

SELECT DISTINCT FINAL.*
,CASE 

WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING' 
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'BRIDG' THEN 'BRIDGING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'REACH' THEN 'REACHING'

WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'FEP' THEN 'BRIDGING'
WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'BEG' THEN 'ENTERING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'EARLI' THEN 'EMERGING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'IMM' THEN 'DEVELOPING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'EARLA' THEN 'EXPANDING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'ADV' THEN 'BRIDGING'

WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'FEP' THEN 'IFEP'
WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'NULL' THEN 'NULL'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'C-PRO' THEN 'IFEP'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'ADV' THEN 'IFEP'

WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'BRIDG' THEN 'IFEP'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ADV' THEN 'IFEP'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'REACH' THEN 'IFEP'

WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'ALT-EMERGING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'ENGA' THEN 'ALT-ENGAGING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ALT-ENTERING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'EXPL' THEN 'ALT-EXPLORING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'INIT' THEN 'ALT-INITIATING'

ELSE PERFORMANCE_LEVEL END AS CONSOLIDATED_PERFORMANCE_LEVEL

,CASE 

WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING' 
WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'BRIDG' THEN 'BRIDGING'
WHEN EOY_TEST_NAME = 'ACCESS' AND EOY_PERFORMANCE_LEVEL = 'REACH' THEN 'REACHING'

WHEN EOY_TEST_NAME = 'LAS' AND EOY_PERFORMANCE_LEVEL = 'FEP' THEN 'BRIDGING'
WHEN EOY_TEST_NAME = 'LAS' AND EOY_PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN EOY_TEST_NAME = 'LAS' AND EOY_PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN EOY_TEST_NAME = 'NMELPA' AND EOY_PERFORMANCE_LEVEL = 'BEG' THEN 'ENTERING'
WHEN EOY_TEST_NAME = 'NMELPA' AND EOY_PERFORMANCE_LEVEL = 'EARLI' THEN 'EMERGING'
WHEN EOY_TEST_NAME = 'NMELPA' AND EOY_PERFORMANCE_LEVEL = 'IMM' THEN 'DEVELOPING'
WHEN EOY_TEST_NAME = 'NMELPA' AND EOY_PERFORMANCE_LEVEL = 'EARLA' THEN 'EXPANDING'
WHEN EOY_TEST_NAME = 'NMELPA' AND EOY_PERFORMANCE_LEVEL = 'ADV' THEN 'BRIDGING'

WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_PERFORMANCE_LEVEL = 'FEP' THEN 'IFEP'
WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN EOY_TEST_NAME = 'SCREENER' AND EOY_PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN EOY_TEST_NAME = 'SCREENER' AND EOY_PERFORMANCE_LEVEL = 'NULL' THEN 'NULL'
WHEN EOY_TEST_NAME = 'SCREENER' AND EOY_PERFORMANCE_LEVEL = 'C-PRO' THEN 'IFEP'
WHEN EOY_TEST_NAME = 'SCREENER' AND EOY_PERFORMANCE_LEVEL = 'ADV' THEN 'IFEP'

WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'BRIDG' THEN 'IFEP'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'ADV' THEN 'IFEP'
WHEN EOY_TEST_NAME = 'WAPT' AND EOY_PERFORMANCE_LEVEL = 'REACH' THEN 'IFEP'

WHEN EOY_TEST_NAME = 'ALT ACCESS' AND EOY_PERFORMANCE_LEVEL = 'EMERG' THEN 'ALT-EMERGING'
WHEN EOY_TEST_NAME = 'ALT ACCESS' AND EOY_PERFORMANCE_LEVEL = 'ENGA' THEN 'ALT-ENGAGING'
WHEN EOY_TEST_NAME = 'ALT ACCESS' AND EOY_PERFORMANCE_LEVEL = 'ENTER' THEN 'ALT-ENTERING'
WHEN EOY_TEST_NAME = 'ALT ACCESS' AND EOY_PERFORMANCE_LEVEL = 'EXPL' THEN 'ALT-EXPLORING'
WHEN EOY_TEST_NAME = 'ALT ACCESS' AND EOY_PERFORMANCE_LEVEL = 'INIT' THEN 'ALT-INITIATING'

ELSE EOY_PERFORMANCE_LEVEL END AS EOY_CONSOLIDATED_PERFORMANCE_LEVEL

,ROW_NUMBER() OVER (PARTITION BY STATE_STUDENT_NUMBER ORDER BY YEAR_END_STATUS) AS RN

FROM (
	
	SELECT 
	SY
	,SCHOOL
	,SCHOOL_NAME
	,SIS_NUMBER
	,[LAST NAME LONG]
	,[FIRST NAME LONG]
	,[HISPANIC INDICATOR]
	,[ETHNIC CODE SHORT]
	,[GENDER CODE]
		,CASE 
			WHEN GRADE = 'KF' THEN 'K'
			WHEN GRADE IN ('C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4') THEN 'Continuing Special Education Student'
		ELSE GRADE END AS GRADE

		,PHLOTE AS PHLOTE
		, CASE 
			WHEN PHLOTE = 'N' AND PERFORMANCE_LEVEL != '' THEN 'Y' 
			WHEN [ENGLISH PROFICIENCY] IN ('ELL', 'FEPM', 'FEPE') THEN 'Y'
			WHEN TEST_NAME IS NULL AND PHLOTE = 'Y' THEN 'N'
		ELSE PHLOTE END AS ADJUSTED_PHLOTE
		


		,[ENGLISH PROFICIENCY] AS ENGLISH_PROFICIENCY
		
		,CASE 
				WHEN [ENGLISH PROFICIENCY] = '' AND IS_ELL = 1 THEN 'ELL'
				WHEN [ENGLISH PROFICIENCY] != '' AND TEST_NAME IN ('WAPT', 'SCREENER', 'PRE-LAS') AND IS_ELL = 0  THEN 'IFEP'
				WHEN [ENGLISH PROFICIENCY] = '' AND IS_ELL = 0 AND TEST_NAME IN ('WAPT', 'SCREENER', 'PRE-LAS') THEN 'IFEP'

				WHEN [ENGLISH PROFICIENCY] = ''  AND TEST_NAME IN ('WAPT', 'SCREENER', 'PRE-LAS') AND IS_ELL = -1 THEN 'IFEP'

				WHEN [ENGLISH PROFICIENCY] = '' AND TEST_NAME IN ('LAS', 'NMELPA', 'ACCESS') AND IS_ELL  = 0   THEN 'FEPE'

				WHEN PHLOTE = 'Y' AND ADMIN_DATE IS NULL AND  PRIMARY_LANGUAGE != 'American Sign language' THEN 'NOT DETERMINABLE'

				WHEN PHLOTE = 'N' AND ADMIN_DATE IS NULL THEN '' 
		ELSE  [ENGLISH PROFICIENCY] END AS [ADJUSTED ENGLISH PROFICIENCY]
		
		
		--,[ENGLISH PROFICIENCY]
		--,IS_ELL
		--,ADMIN_DATE
		,STATE_STUDENT_NUMBER
	    ,YEAR_END_STATUS
		,LEAVE_DATE
		,LEAVE_DESCRIPTION

		,CHILD_FIRST_LANGUAGE
		,PRIMARY_LANGUAGE

		, PERFORMANCE_LEVEL
		, ADMIN_DATE AS [Test Date]
		, TEST_NAME
		, TEST_SCORE
		--, SCORE_DESCRIPTION


		, CASE 
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  = 'FEP' THEN '5 '
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEP'	THEN '3'

			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPA' THEN	'3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPa' THEN	'3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPB' THEN	'3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPb' THEN	'3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPC' THEN	'3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPc' THEN '3'

			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPd' THEN '3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPD' THEN '3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='LEPe' THEN '3'
			WHEN TEST_NAME = 'LAS' AND TEST_SCORE  ='NEP'  THEN '1'
			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  ='FEP' THEN	'5'

			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  ='Fully Engl' THEN '5'
			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  = 'LEP' THEN	'3'
			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  = 'Limited En' THEN	'3'
			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  = 'NEP' THEN	'1'
			WHEN TEST_NAME = 'PRE-LAS' AND TEST_SCORE  = 'Non-Englis' THEN	'1'
		ELSE TEST_SCORE END AS ACCESS_EQUIVALENT_SCORE


		, [English Model]
		, [Bilingual Model]

		
		, BEPProgramDescription
		,  [Dual Language Immersion]
		,  [Maintenance Bilingual]
		,  [Content Based English as a Second Language] 
		,  ALSED
		,  ALSSH

		, [Parent Refused]
		,[Receiving Service]
		
		, FIRST_TIME_SENIOR
		, GRADUATED
		, DIPLOMA_TYPE

		,DROPOUT
		,SPED
		,GIFTED

		
		,EOY_PERFORMANCE_LEVEL
		,EOY_TEST_DATE
		,EOY_TEST_NAME
		,EOY_TEST_SCORE
		
		, CASE 
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  = 'FEP' THEN '5 '
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEP'	THEN '3'

			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPA' THEN	'3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPa' THEN	'3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPB' THEN	'3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPb' THEN	'3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPC' THEN	'3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPc' THEN '3'

			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPd' THEN '3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPD' THEN '3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='LEPe' THEN '3'
			WHEN EOY_TEST_NAME = 'LAS' AND EOY_TEST_SCORE  ='NEP'  THEN '1'
			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  ='FEP' THEN	'5'

			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  ='Fully Engl' THEN '5'
			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  = 'LEP' THEN	'3'
			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  = 'Limited En' THEN	'3'
			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  = 'NEP' THEN	'1'
			WHEN EOY_TEST_NAME = 'PRE-LAS' AND EOY_TEST_SCORE  = 'Non-Englis' THEN	'1'
		ELSE EOY_TEST_SCORE END AS EOY_ACCESS_EQUIVALENT_SCORE
	
	
	 FROM (
	   
	   SELECT 
		'2015' AS SY
		--, SCH.SCHOOL_CODE		
		, CASE 
			WHEN [LOCATION CODE] > '900' THEN ENR.SCHOOL_CODE 
			WHEN [LOCATION CODE] = '040' THEN ENR.SCHOOL_CODE
			ELSE [LOCATION CODE] END AS SCHOOL
		, CASE 
			WHEN [LOCATION CODE] > '900' THEN ENR.SCHOOL_NAME 
			WHEN [LOCATION CODE] = '040' THEN ENR.SCHOOL_NAME
			ELSE ORG.ORGANIZATION_NAME END AS SCHOOL_NAME
		,ALS.SIS_NUMBER
		,[LAST NAME LONG]
		,[FIRST NAME LONG]
		,[HISPANIC INDICATOR]
		,[ETHNIC CODE SHORT]
		,[GENDER CODE]
		
		,CASE 
			WHEN ENR.GRADE IS NULL THEN [CURRENT GRADE LEVEL]
			WHEN [CURRENT GRADE LEVEL] = '12' THEN ENR.GRADE 
			--WHEN [CURRENT GRADE LEVEL] = 'PK' THEN ENR.GRADE
			WHEN [CURRENT GRADE LEVEL] = 'KF' THEN ENR.GRADE
		ELSE [CURRENT GRADE LEVEL] END AS GRADE
		
		,ISNULL(CASE 
			WHEN PHL.DATE_ASSIGNED IS NOT NULL THEN 'Y'		
		ELSE 'N' END,'NOT IDENTIFIED AS OF 80TH DAY') AS PHLOTE
				
		,CASE
			WHEN [ENGLISH PROFICIENCY] IN (2,3) THEN 'FEPM'
			WHEN [ENGLISH PROFICIENCY] = 4 THEN 'FEPE'
			WHEN [ENGLISH PROFICIENCY] = 1 THEN 'ELL'
			ELSE '' 
		END AS [ENGLISH PROFICIENCY]

		,ALS.STATE_STUDENT_NUMBER
	    ,CASE WHEN YEARENDSTATUS.STUDENT_GU IS NULL THEN 'Z NO ENROLLMENT FOUND - DUP STATEID' ELSE YEARENDSTATUS.YEAR_END_STATUS END AS YEAR_END_STATUS
		,YEARENDSTATUS.LEAVE_DATE
		,YEARENDSTATUS.LEAVE_DESCRIPTION

		,CHILD_FIRST_LANGUAGE
		,BS.HOME_LANGUAGE AS PRIMARY_LANGUAGE

		,ISNULL(ACCESS.PERFORMANCE_LEVEL,'') AS PERFORMANCE_LEVEL
		,ISNULL(ACCESS.TEST_NAME,'')  AS TEST_NAME
		,ISNULL(ACCESS.TEST_SCORE,'')  AS TEST_SCORE
		--,ISNULL(ACCESS.SCORE_DESCRIPTION,'')  AS SCORE_DESCRIPTION
		,ACCESS.IS_ELL
		,ACCESS.ADMIN_DATE
/*
		,CASE WHEN [ENGMODEL].[Field5] = 'BEP' THEN 'Bilingual Model'
			  WHEN [ENGMODEL].[Field5] = 'ESL' THEN 'English Model'
		ELSE ''
		END AS BILINGUAL_ENGLISH_MODEL
		

		--DONT COUNT KIDS IN BOTH, EVEN THOUGH STARS HAS THEM IN BOTH MODELS-----------------------------------------------------  
		,CASE WHEN [ENGLISH PROFICIENCY] = 1 AND [Bilingual Model] = 'BEP' THEN '' 
			  WHEN [ENGLISH PROFICIENCY] = 1 AND [English Model] = 'ESL' THEN [English Model]
		ELSE '' END AS [English Model]
		
		,CASE WHEN [ENGLISH PROFICIENCY] = 1 AND [Bilingual Model] = 'BEP' THEN [Bilingual Model] ELSE '' END AS [Bilingual Model]
		---------------------------------------------------------------------------------------------------------------------------
*/
		,ISNULL([English Model],'') AS [English Model]
		,ISNULL([Bilingual Model],'') AS [Bilingual Model]

		
		,ISNULL(BEPProgramDescription,'') AS BEPProgramDescription
				
		, CASE WHEN ALS2W > 0 THEN 'ALS2W' ELSE '' END  AS [Dual Language Immersion]
		, CASE WHEN ALSMP > 0 THEN 'ALSMP' ELSE '' END  AS [Maintenance Bilingual]
		
		, CASE WHEN ALSES > 0 THEN 'ALSES' ELSE '' END AS [Content Based English as a Second Language] 
		, CASE WHEN ALSED > 0 THEN 'ALSED' ELSE '' END AS ALSED
		, CASE WHEN ALSSH > 0 THEN 'ALSSH' ELSE '' END AS ALSSH

		,ISNULL([Parent Refused],'') AS [Parent Refused]
		,CASE WHEN [English Model] = 'ESL' THEN 'Receiving Service' ELSE '' END AS [Receiving Service]
		
		,CASE WHEN FRSTSENIOR.STUDENT_GU IS NULL AND ENR.GRADE = '12' THEN 'Y' ELSE 'N' END AS FIRST_TIME_SENIOR
		,ISNULL(CAST(CASE WHEN GRADS.GRADUATION_DATE IS NOT NULL THEN CAST(GRADUATION_DATE AS DATE) ELSE NULL END AS VARCHAR),'') AS GRADUATED
		,CASE WHEN GRADS.DIPLOMA_TYPE IS NOT NULL THEN DIPLOMA_TYPE ELSE '' END AS DIPLOMA_TYPE

		,CASE WHEN DROPOUT.State_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS DROPOUT

		,CASE WHEN SPED.PRIMARY_DISABILITY_CODE = 'GI' THEN 'Y' ELSE '' END AS GIFTED
		,CASE WHEN SPED.SIS_NUMBER IS NOT NULL THEN SPED.PRIMARY_DISABILITY_CODE ELSE '' END AS SPED

		
		--EOY TESTS-------------------------------------------------------------
		,ISNULL(EOYTESTS.PERFORMANCE_LEVEL,'') AS EOY_PERFORMANCE_LEVEL
		,ISNULL(EOYTESTS.TEST_NAME,'')  AS EOY_TEST_NAME
		,ISNULL(EOYTESTS.TEST_SCORE,'')  AS EOY_TEST_SCORE
		,EOYTESTS.ADMIN_DATE AS EOY_TEST_DATE
		

	    FROM 
	  
	  (
	   SELECT 
				[SY]
				, [LOCATION CODE]
				,[LAST NAME LONG]
				,[FIRST NAME LONG]
				,[HISPANIC INDICATOR]
				,[ETHNIC CODE SHORT]
				,[GENDER CODE]
				,[CURRENT GRADE LEVEL]
				,[ENGLISH PROFICIENCY]
				,[Field13]
	           ,SIS_NUMBER
			   ,STATE_STUDENT_NUMBER
		  ,STUDENT_GU
		  --SELECT * 
		  FROM
				--Uses the 80th Day Stars File
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS
				INNER JOIN 
				(SELECT * FROM REV.EPC_STU WHERE STATE_STUDENT_NUMBER != '635938505/11/201758') AS STU
				ON STARS.[STUDENT ID] = STU.STATE_STUDENT_NUMBER
				           
		  WHERE
				[Period] = '2014-12-15'
				--[Period] =  '2014-12-15'
				AND [DISTRICT CODE] = '001'
				AND [CURRENT GRADE LEVEL] != 'PK'
				--SKIPPING THIS CHILD BECAUSE HE WAS REPORTED AS 'KF' AND IN SYNERGY THE GRADE IS 'PK' AND WE DON'T WANT PRE-K'S
				AND STATE_STUDENT_NUMBER ! = 262891187

) AS ALS

LEFT JOIN 
APS.PHLOTEAsOf('2014-12-15') AS PHL
ON
ALS.STUDENT_GU = PHL.STUDENT_GU

--LEFT JOIN 
--(SELECT * FROM 
--rev.EPC_STU_PGM_ELL_HIS
--WHERE
--EXIT_DATE BETWEEN  '2014-06-01' AND '2014-08-14'
--) AS FEP
--ON
--ALS.STUDENT_GU = FEP.STUDENT_GU

---------GET SCHOOL NAME FOR GOOD STARS LOCATIONS------------------------------------
LEFT JOIN 
rev.EPC_SCH AS SCH
ON
ALS.[LOCATION CODE] = SCH.SCHOOL_CODE

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU
-------------------------------------------------------------------------------------

--GET SYNERGY LOCATION AND NAME WHERE STARS LOCATIONS ARE ROLLED UP, STATE LOCATIONS
LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS ENR
ON
ALS.STUDENT_GU = ENR.STUDENT_GU
----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------

--GET LAST ENROLLMENT FOR YEAR END STATUS - G, P, R
LEFT JOIN 
(
SELECT STUDENT_GU, YEAR_END_STATUS, LEAVE_DATE, PRIM.LEAVE_DESCRIPTION FROM 
APS.LatestPrimaryEnrollmentInYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B') AS PRIM
) AS YEARENDSTATUS

ON
YEARENDSTATUS.STUDENT_GU = ALS.STUDENT_GU


------------------------------------------------------------------------------------------------





--PULL STUDENTS FIRST LANGUAGE
LEFT JOIN 
(
SELECT
	STUDENT_GU
	,DATE_ASSIGNED
	,Q2_CHILD_FIRST_LANGUAGE
	,LANGUAGES AS CHILD_FIRST_LANGUAGE
FROM
	(
	SELECT
		STUDENT_GU
		,Q1_LANGUAGE_SPOKEN_MOST
		,Q2_CHILD_FIRST_LANGUAGE
		,Q3_LANGUAGES_SPOKEN
		,Q4_OTHER_LANG_UNDERSTOOD
		,Q5_OTHER_LANG_COMMUNICATED
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY DATE_ASSIGNED DESC) AS RN
		,DATE_ASSIGNED
		,LU.VALUE_DESCRIPTION AS LANGUAGES
	FROM
		rev.UD_HLS_HISTORY AS HLSHistory
		INNER JOIN 
		APS.LookupTable('K12', 'LANGUAGE') AS LU
		ON
		LU.VALUE_CODE = Q2_CHILD_FIRST_LANGUAGE
	WHERE
		DATE_ASSIGNED <= ('2014-12-15')
	) AS RowedHLS
WHERE
	RN = 1
) AS FIRSTLANG

ON
FIRSTLANG.STUDENT_GU = ALS.STUDENT_GU

----------------------------------------------------------------------------------------------
LEFT JOIN 
APS.BasicStudent AS BS
ON
ALS.STUDENT_GU = BS.STUDENT_GU

----------------------------------------------------------------------------------------------
--PULL ACCESS TEST SCORES 
LEFT JOIN 
(
SELECT 	
	LCETEST.STUDENT_GU
	,LCETEST.PERFORMANCE_LEVEL
	,LCETEST.TEST_NAME
	,SCORES.TEST_SCORE
	,SCORE_DESCRIPTION 
	,LCETEST.IS_ELL
	,LCETEST.ADMIN_DATE
FROM 
APS.LCELatestEvaluationAsOf('2014-12-15') AS LCETEST

INNER HASH JOIN
rev.EPC_TEST_PART AS PART
ON LCETEST.TEST_GU = PART.TEST_GU
--AND LCETEST.TEST_NAME = 'ACCESS'

INNER HASH JOIN
rev.EPC_STU_TEST_PART AS STU_PART
ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
AND STU_PART.STUDENT_TEST_GU = LCETEST.STUDENT_TEST_GU

INNER HASH JOIN
rev.EPC_STU_TEST_PART_SCORE AS SCORES
ON
SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

LEFT JOIN
rev.EPC_TEST_SCORE_TYPE AS SCORET
ON
SCORET.TEST_GU = LCETEST.TEST_GU
AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

LEFT JOIN
rev.EPC_TEST_DEF_SCORE AS SCORETDEF
ON
SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

WHERE
SCORETDEF.SCORE_DESCRIPTION IN ('Language Proficiency','OVERALL LP') 

) AS ACCESS

ON
ACCESS.STUDENT_GU = ALS.STUDENT_GU

/*-----------------------------------------------------------------------------------------------

--PULL ENGLISH AND BILINGUAL MODEL FROM STARS - BEP AND ESL 
--STARS DATABASE HAS THIS INCORRECT SO READING SYNERGY INSTEAD
-------------------------------------------------------------------------------------------------*/
/*
LEFT JOIN 
(
SELECT 
	[STUDENT ID]
	,[Field5]
 FROM 
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[PROGRAMS_FACT] AS BilingualModel

  WHERE
				[Period] = '2014-12-15'
				AND [DISTRICT CODE] = '001'
				AND BilingualModel.[Field5] IN ('ESL','BEP')
) AS ENGMODEL
ON
ALS.STATE_STUDENT_NUMBER = ENGMODEL.[STUDENT ID]
*/



/*-----------------------------------------------------------------------------------------------------------

--Students and Their Providers for English Model
------------------------------------------------------------------------------------------------------------*/

LEFT JOIN
(
	SELECT DISTINCT
	SIS_NUMBER
	,CASE WHEN RCVINGSERV.COURSE_ID IS NOT NULL THEN 'ESL' ELSE '' END AS [English Model]
	,RCVINGSERV.PARENT_REFUSED AS [Parent Refused]
	,CASE WHEN RCVINGSERV.STATUS = 'No Appropriate Course Assigned' THEN 'Y' ELSE '' END AS [Not Receiving Service]
    FROM 
	APS.LCEStudentsAndProvidersAsOf('2014-12-15') AS RCVINGSERV
	) AS RCVINGSERV
ON
RCVINGSERV.SIS_NUMBER = ALS.SIS_NUMBER

/*-----------------------------------------------------------------------------------------------------------

--Bilingual Students for Bilingual Model
------------------------------------------------------------------------------------------------------------*/

LEFT JOIN 
(SELECT 
SIS_NUMBER
,CASE WHEN SIS_NUMBER IS NOT NULL THEN 'BEP' ELSE '' END AS [Bilingual Model] 
FROM 
APS.LCEBilingualAsOf('2014-12-15') AS BP
INNER JOIN 
REV.EPC_STU AS STU
ON BP.STUDENT_GU = STU.STUDENT_GU
) AS BEP
ON
ALS.SIS_NUMBER = BEP.SIS_NUMBER


/*-----------------------------------------------------------------------------------------------------------

--PULL ENGLISH AND BILINGUAL MODEL FROM STARS - BEP AND ESL

** STARS DATABASE REPORTING ALL STUDENTS WITH TAGS (100% RECEIVING SERVICE) SO WE'RE USING SYNERGY INSTEAD
------------------------------------------------------------------------------------------------------------*/
LEFT JOIN 
/*(
SELECT 
*
FROM 
(
SELECT 
	[Student_ID]
	,CASE WHEN FIELD_18 = 1 THEN 'Dual Language Immersion'
		 WHEN FIELD_18 = 2 THEN 'Maintenance Bilingual'
		 WHEN FIELD_18 = 3 THEN 'Enrichment'
		 WHEN FIELD_18 = 4 THEN 'Transitional Bilingual'
		 WHEN FIELD_18 = 5 THEN 'Heritage Language'
		 WHEN FIELD_18 = 7 THEN 'Structured English Immersion'
		 WHEN FIELD_18 = 8 THEN 'Content Based English as a Second Language'
		 WHEN FIELD_18 = 9 THEN 'Pull Out English as a Second Language'
		 WHEN FIELD_18 = 10 THEN 'Specifically Designed Academic Instruction in English'
		 WHEN FIELD_18 = 11 THEN 'Sheltered Instruction Observation Protocol'
		 WHEN FIELD_18 = 12 THEN 'Other Model'
	ELSE '' END AS TAGS		 

 FROM
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from 80DBEP.csv'
                ) AS [B1]
) AS GET
PIVOT 
(
MAX([TAGS])
FOR [TAGS] IN ([Dual Language Immersion], [Maintenance Bilingual], [Enrichment],[Content Based English as a Second Language] )
) AS PIVOTME
) AS MODELTAGS
ON
MODELTAGS.[Student_ID] = ALS.STATE_STUDENT_NUMBER
*/

/*-----------------------------------------------------------------------------------------------------------

--Use Bilingual Model and Hours Function for Tags and Indicators
--DAC 5/8/2017 - CHANGED CODE TO PULL TAGS FOR ALL LCECLASSES NOT JUST BILINGUAL
------------------------------------------------------------------------------------------------------------*/

(SELECT StudentID, MAX(BEPProgramDescription) AS BEPProgramDescription
--, MAX(ALS2W) AS ALS2W, MAX(ALSED) AS ALSED, MAX(ALSSH) AS ALSSH, MAX(ALSES) AS ALSES, MAX(ALSMP) AS ALSMP 
FROM 
APS.BilingualModelAndHoursDetailsAsOf('2014-12-15') AS BEPKIDS
GROUP BY StudentID
) AS MODELTAGS

ON
MODELTAGS.StudentID = ALS.SIS_NUMBER

--DAC 5/8/2017 - CHANGED CODE TO PULL TAGS FOR ALL LCECLASSES NOT JUST BILINGUAL

LEFT HASH JOIN 
(
SELECT 
	SIS_NUMBER
	,SUM(ALSSH) AS ALSSH
	,SUM(ALSED) AS ALSED
	,SUM(ALS2W) AS ALS2W
	,SUM(ALSMP) AS ALSMP
	,SUM(ALSES) AS ALSES
 FROM 
(
SELECT 
	SCH.SIS_NUMBER
	,CASE WHEN LCECLASS.ALSSH IS NOT NULL THEN 1 ELSE 0 END AS ALSSH
	,CASE WHEN LCECLASS.ALSED IS NOT NULL THEN 1 ELSE 0 END AS ALSED
	,CASE WHEN LCECLASS.ALS2W IS NOT NULL THEN 1 ELSE 0 END AS ALS2W
	,CASE WHEN LCECLASS.ALSMP IS NOT NULL THEN 1 ELSE 0 END AS ALSMP
	,CASE WHEN LCECLASS.ALSES IS NOT NULL THEN 1 ELSE 0 END AS ALSES
	
 FROM 
APS.ScheduleDetailsAsOf('2014-12-15') AS SCH
INNER JOIN 
APS.LCEClassesWithMoreInfoAsOf('2014-12-15') AS LCECLASS
ON
LCECLASS.ORGANIZATION_YEAR_GU = SCH.ORGANIZATION_YEAR_GU
AND LCECLASS.COURSE_GU = SCH.COURSE_GU
AND LCECLASS.SECTION_GU = SCH.SECTION_GU
--WHERE 
--(ALSSH = 'ALSSH' OR
--ALSED = 'ALSED')
GROUP BY SIS_NUMBER	,CASE WHEN LCECLASS.ALSSH IS NOT NULL THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.ALSED IS NOT NULL THEN 1 ELSE 0 END
		,CASE WHEN LCECLASS.ALS2W IS NOT NULL THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.ALSMP IS NOT NULL THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.ALSES IS NOT NULL THEN 1 ELSE 0 END

) AS T1
GROUP BY SIS_NUMBER
) AS TAGSFORALL
ON
ALS.SIS_NUMBER = TAGSFORALL.SIS_NUMBER

-----------------------------------------------------------------------------------------------

--PULL FIRST TIME SENIORS
-------------------------------------------------------------------------------------------------
LEFT JOIN 
(
SELECT SIS_NUMBER, GRADE, BS.CLASS_OF, BS.STUDENT_GU FROM 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS PRIM
INNER JOIN 
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
WHERE
GRADE = '12'
AND CLASS_OF != '2015'
) AS FRSTSENIOR
ON
FRSTSENIOR.STUDENT_GU = ALS.STUDENT_GU

-----------------------------------------------------------------------------------------------

--PULL GRADUATION DATE AND DIPLOMA TYPE
-------------------------------------------------------------------------------------------------
LEFT JOIN 
(
SELECT bs.GRADUATION_DATE, BS.STUDENT_GU, LU.VALUE_DESCRIPTION AS DIPLOMA_TYPE FROM 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS PRIM
INNER JOIN 
rev.epc_stu AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
INNER JOIN 
APS.LookupTable('K12', 'DIPLOMA_TYPE') AS LU
ON
LU.VALUE_CODE = BS.DIPLOMA_TYPE
WHERE
GRADUATION_DATE BETWEEN '2014-08-01' AND '2015-08-01'
) AS GRADS
ON
GRADS.STUDENT_GU = ALS.STUDENT_GU



-----------------------------------------------------------------------------------------------

--READ A FILE OF DROPOUTS FROM THE STATE
-------------------------------------------------------------------------------------------------

LEFT JOIN
(
SELECT * FROM
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DROPOUT20142015.csv'
                ) AS [D1]
) AS DROPOUT
ON
DROPOUT.State_ID = ALS.STATE_STUDENT_NUMBER



-----------------------------------------------------------------------------------------------

--PULL SPED AND GIFTED
-------------------------------------------------------------------------------------------------


LEFT JOIN 
	(
SELECT
            CurrentSPED.SIS_NUMBER
            ,CurrentSPED.PRIMARY_DISABILITY_CODE
FROM   
            APS.PrimaryEnrollmentsAsOf('2014-12-15') AS Enrollment
            LEFT JOIN
            (
            SELECT
                        STU.SIS_NUMBER
						,SPED.STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
						INNER JOIN
						rev.EPC_STU AS STU
						ON
						SPED.STUDENT_GU = STU.STUDENT_GU

            WHERE
                        NEXT_IEP_DATE IS NOT NULL
                        AND (
                                    EXIT_DATE IS NULL 
                                    OR EXIT_DATE >= CONVERT(DATE, '2014-12-15')
                                    )
            ) AS CurrentSPED
            ON
            Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU
WHERE 
            CurrentSPED.STUDENT_GU IS NOT NULL
	)

AS SPED
ON
SPED.SIS_NUMBER = ALS.SIS_NUMBER



---------------------------------------------------------------------------------------------------------
--PULL TEST SCORES FOR THE END OF THE YEAR TO SEE GROWTH AND HOW STUDENT TESTED FOR THE NEXT SCHOOL YEAR
LEFT HASH JOIN 
(
SELECT 	
	LCETEST.STUDENT_GU
	,LCETEST.PERFORMANCE_LEVEL
	,LCETEST.TEST_NAME
	,SCORES.TEST_SCORE
	,SCORE_DESCRIPTION 
	,LCETEST.IS_ELL
	,LCETEST.ADMIN_DATE
FROM 
APS.LCELatestEvaluationAsOf('2015-07-01') AS LCETEST

INNER HASH JOIN
rev.EPC_TEST_PART AS PART
ON LCETEST.TEST_GU = PART.TEST_GU
--AND LCETEST.TEST_NAME = 'ACCESS'

INNER HASH JOIN
rev.EPC_STU_TEST_PART AS STU_PART
ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
AND STU_PART.STUDENT_TEST_GU = LCETEST.STUDENT_TEST_GU

INNER HASH JOIN
rev.EPC_STU_TEST_PART_SCORE AS SCORES
ON
SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

LEFT JOIN
rev.EPC_TEST_SCORE_TYPE AS SCORET
ON
SCORET.TEST_GU = LCETEST.TEST_GU
AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

LEFT JOIN
rev.EPC_TEST_DEF_SCORE AS SCORETDEF
ON
SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

WHERE
SCORETDEF.SCORE_DESCRIPTION IN ('Language Proficiency','OVERALL LP') 

) AS EOYTESTS

ON
EOYTESTS.STUDENT_GU = ALS.STUDENT_GU





) AS T1


WHERE
SCHOOL NOT IN ('901', '910', '983', '973')

) AS FINAL


