--BEGIN TRAN
USE
Assessments
GO

TRUNCATE TABLE [EXIT EXAM STATUS]
INSERT INTO [EXIT EXAM STATUS]

SELECT * FROM
(
SELECT
   [ID_NBR]
  ,[LAST_NAME]
  ,[FIRST_NAME]
  ,[M_NAME]
  ,[SCHOOL]
  ,[CURRENT GRADE] AS GRADE
  ,[READING] AS 'Reading SBA'
  ,CASE WHEN [PASS FAIL_READING] IS NULL OR [PASS FAIL_READING] = '' THEN 'NYT' ELSE [PASS FAIL_READING] END AS [PASS FAIL_READING]
  ,[MATH] AS 'Math SBA'
  ,CASE WHEN [PASS FAIL_MATH] IS NULL OR [PASS FAIL_MATH] = '' THEN 'NYT' ELSE [PASS FAIL_MATH] END AS [PASS FAIL_MATH]
  ,[TOTAL SCORE READING MATH] AS 'Combo MR SBA'
  ,CASE WHEN [PASS FAIL_RM] IS NULL OR [PASS FAIL_RM] = '' THEN 'NYT' ELSE [PASS FAIL_RM] END AS [PASS FAIL_RM]
  ,[SCIENCE] AS 'Science SBA'
  ,CASE WHEN [PASS FAIL_SCIENCE] IS NULL OR [PASS FAIL_SCIENCE] = '' THEN 'NYT' ELSE [PASS FAIL_SCIENCE] END AS [PASS FAIL_SCIENCE]
  ,CASE WHEN [PASS FAIL_SCIENCE] = 'PASS' THEN 'PASS'
	WHEN [PASS FAIL_SCIENCE] != 'PASS' AND SC_FC != '000000000000' AND [SCIE] = '2' THEN 'FAIL'
	WHEN [PASS FAIL_SCIENCE] != 'PASS' AND SC_FC != '000000000000' AND [SCIE] < 2 THEN 'SCIENCE SBA ATTEMPTS NOT EXHAUSTED' 
	WHEN [PASS FAIL_SCIENCE] = 'PASS' AND SC_FC != '000000000000' AND [SCIE] < 2 THEN 'SCIENCE SBA ATTEMPTS NOT EXHAUSTED' 
	WHEN [SCIE] IS NULL THEN ''
  ELSE 'FAIL'
  END AS [SCI_FD]
  --,[WRITING] AS 'Writing EOC'
  --,CASE WHEN [PASS FAIL_WRITING] IS NULL OR [PASS FAIL_WRITING] = '' THEN 'NYT' ELSE [PASS FAIL_WRITING] END AS [PASS FAIL_WRITING]
  -- THIS IS AN OLD VERSION OF HISTORY NOT VALID FOR THIS REPORT ---
  --,[HISTORY]
  --,[PASS FAIL_HISTORY]
  --,[CHEMISTRY] AS 'Chemistry EOC'
  --,CASE WHEN [PASS FAIL_CHEMISTRY] IS NULL OR [PASS FAIL_CHEMISTRY] = '' THEN 'NYT' ELSE [PASS FAIL_CHEMISTRY] END AS [PASS FAIL_CHEMISTRY]
  --,[BIOLOGY] AS 'Biology EOC'
  --,CASE WHEN [PASS FAIL_BIOLOGY] IS NULL OR [PASS FAIL_BIOLOGY] = '' THEN 'NYT' ELSE [PASS FAIL_BIOLOGY] END AS [PASS FAIL_BIOLOGY]
  --,[EOC_READING] AS 'Reading EOC'
  --,CASE WHEN [PASS FAIL_EOC_READING] IS NULL OR [PASS FAIL_EOC_READING] = '' THEN 'NYT' ELSE [PASS FAIL_EOC_READING] END AS [PASS FAIL_EOC_READING]
  --,[SOCIAL STUDIES]
  --,[ECONOMICS] AS 'Economics EOC'
  --,CASE WHEN [PASS FAIL_ECON] IS NULL OR [PASS FAIL_ECON] = '' THEN 'NYT' ELSE [PASS FAIL_ECON] END AS [PASS FAIL_ECON]
  --,[NMHIST] AS 'NMHIST EOC'
  --,CASE WHEN [PASS FAIL_NMHIST] IS NULL OR [PASS FAIL_NMHIST] = '' THEN 'NYT' ELSE [PASS FAIL_NMHIST] END AS [PASS FAIL_NMHIST]
  --,[USGOV] AS 'USGOV EOC'
  --,CASE WHEN [PASS FAIL_USGOV] IS NULL OR [PASS FAIL_USGOV] = '' THEN 'NYT' ELSE [PASS FAIL_USGOV] END AS [PASS FAIL_USGOV]
  ,[PASSED_ALL_REQUIRED_TESTS] AS [PASSED ALL REQUIRED TESTS]
  --,SBA_FC
  --,RE_FC
  --,SC_FC
  --,SS_FC
  ,CASE WHEN LTRIM (Take_SBA) IS NULL OR LTRIM (Take_SBA) = '' THEN 'N/A' ELSE Take_SBA
  END AS Take_SBA
  ,CASE WHEN LTRIM (Take_EOC) IS NULL OR LTRIM (Take_EOC) = '' THEN 'N/A' ELSE Take_EOC
  END AS Take_EOC
  ,MATE AS 'MATH SBA ATTEMPTS'
  ,REAE AS 'READING SBA ATTEMPTS'
  ,SCIE AS 'SCIENCE SBA ATTEMPTS'
  ,SOC_STU AS EOC_SOCIAL_STUDIES_ATTEMPTS
  ,WRIT AS EOC_WRITING_ATTEMPTS
FROM
	(
	SELECT
	   *	
	  ,CASE
		WHEN TAKE_SBA IS NULL AND TAKE_EOC = '' THEN 'YES' ELSE 'NO' 
		END AS [PASSED_ALL_REQUIRED_TESTS]
	/*** FILL IN THE Take_EoC FILED FOR EOC TESTS STILL NEEDED ***/ 
	FROM
	(
		SELECT
			   *
			  ,CASE
				WHEN TAKE_SBA IS NULL THEN LTRIM(SS + ' ' + WRI) ELSE
				LTRIM (SS + ' ' + WRI + ' ' + REA + ' ' + MAT + ' ' + SCI) 
			   END AS Take_EoC
		
		/*** CREATE LIST OF EOC TESTS STUDENT STILL NEEDS TO TAKE***/	   
		FROM
			(	
			SELECT
			  *
			  ,CASE WHEN SS_FC = '00000000000000000' THEN 'SS' ELSE '' END AS 'SS'
			  ,CASE WHEN MA_FC = '00' THEN 'MA' ELSE '' END AS 'MA'
			  ,CASE WHEN (SUBSTRING (SBA_FC,1,1) = '1' OR SUBSTRING (SBA_FC,3,1) = '1') THEN '' ELSE
					CASE WHEN RE_FC = '0000000' THEN 'READING' ELSE '' END 
				END AS 'REA'
			  ,CASE WHEN SC_FC = '000000000000' THEN 'SCI' ELSE '' END AS 'SCI'
			  ,CASE WHEN WR_FC = '0000000' THEN 'WRI' ELSE '' END AS 'WRI'
			  ,CASE WHEN (SUBSTRING (SBA_FC,2,1) = '1' OR SUBSTRING (SBA_FC,3,1) = '1') THEN '' ELSE 
					CASE WHEN MA_FC = '0000000' THEN 'MATH' ELSE '' END
				END AS 'MAT'
			
			/*** DETERMINE WHICH CONTENT AREAS A STUDENT HAS PASSED OR FAILED (SBA, SCIENCE, READING, MATH, SS)***/  
			FROM
			(
				SELECT
					  *
					  ,RSBA + MSBA + RMSBA + SSBA AS 'SBA_FC'
					  ,SS_GOV + SS_NMH + SS_ECON + SS_ECONV1 + SS_ECONV4 + SS_NMHV1 + SS_NMHSV4 + SS_NMHSV01 + SS_NMHSV1 + SS_USGV1 + SS_USGV2 + SS_USGV5 + SS_USHV2 + SS_USHV1 + SS_USHV4 + SS_WHV1 + SS_WHV3  AS 'SS_FC'
					  /*** MATH FINAL DETERMINATION ***/
					  ,MA_AGIVI + MA_AGIV3 + MA_AGIIV2 + MA_AGIIV6 + MA_GEOMV3 + MA_PRECALV4 + MA_FINLITV3 AS 'MA_FC'
					  /**** WRITING FINAL DETERMINATIION ***/
					  ,WR_III + WR_IIIV2 + WR_IIIV6 + WR_IIIV1 + WR_SPV1 + WR_IVV1 + WR_IVV3 AS 'WR_FC'
					  /*** READING FINAL DETERMINATION ***/
					  ,RE_EOC + RE_IIIV1 + RE_IIIV2 + RE_IIIV6 + RE_SPV1 + RE_IVV1 + RE_IVV3 AS 'RE_FC'
					  /*** SCIENCE FINAL DETERMINATION ***/
					  ,SC_BIO + SC_CHE + SC_BIO2  + SC_BIO3 + SC_BIO7 + SC_CHEM2 + SC_CHEM3 +CHEMV1 + CHEM8 + PHY8 + PHYS +ENV AS 'SC_FC'
					  
				/*** DETERMINE WHICH EOC AND SBA TESTS THE STUDENT HAS PASSED***/	  
				FROM
				(
					SELECT 
					  *
					  /**** SBA PASS FAIL DETERMINATION ***/
					  ,CASE WHEN [PASS FAIL_READING] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RSBA'
					  ,CASE WHEN [PASS FAIL_MATH] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MSBA'
					  ,CASE WHEN [PASS FAIL_RM] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RMSBA'
					  ,CASE WHEN [PASS FAIL_SCIENCE] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SSBA'
					  
					  /**** EOC SOCIAL STUDIES PASS FAIL DETERMINATION ***/
					  ,CASE WHEN [PASS FAIL_USGOV] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_GOV'
					  ,CASE WHEN [PASS FAIL_NMHIST] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_NMH'
					  ,CASE WHEN [PASS FAIL_ECON] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_ECON'
					  ,CASE WHEN [Economics 9 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_ECONV1'
					  ,CASE WHEN [Economics 9 12 V004] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_ECONV4'					  --,CASE WHEN [Economics V1] = 'PASS' THEN '1' ELSE '0'
					  --END AS 'ECONV1'
					  ,CASE WHEN [New Mexico History 7 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_NMHV1'
					  ,CASE WHEN [New Mexico 7 12 History V004] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_NMHSV4'
					  ,CASE WHEN [New Mexico 7 12 History V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_NMHSV01'
					  ,CASE WHEN [NM History 7 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_NMHSV1'					  
					  ,CASE WHEN [US Government Comprehensive 9 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USGV1'
					  ,CASE WHEN [US Government Comprehensive 9 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USGV2'
					  ,CASE WHEN [US Government Comprehensive 9 12 V005] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USGV5'					  --,CASE WHEN [US History (Spanish) V1] = 'PASS' THEN '1' ELSE '0'
					  --END AS 'SS_USHSPV1'
					  --,CASE WHEN [US History V1] = 'PASS' THEN '1' ELSE '0'
					  --END AS 'SS_USHV1'
					  ,CASE WHEN [US History 9 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USHV2'
					  ,CASE WHEN [US History 9 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USHV1'
					  ,CASE WHEN [US History 9 12 V007] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_USHV4'
					  ,CASE WHEN [World History And Geography 9 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_WHV1'
					  ,CASE WHEN [World History And Geography 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SS_WHV3'
					  	 
					  /*** EOC MATH PASS FAIL DETERMINATION   ***/
					 /** ,CASE WHEN [Algebra I 7 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS'MA_AGIV1' ***/
					  ,CASE WHEN [Algebra I 7 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_AGIVI'
					  ,CASE WHEN [Algebra I 7 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_AGIV3'
					  ,CASE WHEN [Algebra II 10 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_AGIIV2'
					  ,CASE WHEN [Algebra II 10 12 V006] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_AGIIV6'					  
					  ,CASE WHEN [Geometry 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_GEOMV3'					  
					  ,CASE WHEN [Pre-Calculus 9 12 V004] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_PRECALV4'
					  ,CASE WHEN [Financial Literacy 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'MA_FINLITV3'
					  					  					  
					  /*** EOC WRITING PASS FAIL DETERMINATION ***/
					  ,CASE WHEN [PASS FAIL_WRITING] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_III'
					  ,CASE WHEN [English Language Arts III Writing 11 11 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_IIIV2'
					  ,CASE WHEN [English Language Arts III Writing 11 11 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_IIIV1'
					  ,CASE WHEN [English Language Arts III Writing 11 11 V006] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_IIIV6'
					  ,CASE WHEN [Spanish Language Arts III Writing 11 11 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_SPV1'
					  ,CASE WHEN [English Language Arts IV Writing 12 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_IVV1'
					  ,CASE WHEN [English Language Arts IV Writing 12 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'WR_IVV3'					  
					  
					  /*** EOC READING PASS FAIL DETERMINATION ***/
					  ,CASE WHEN [PASS FAIL_EOC_READING] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_EOC'
					  ,CASE WHEN [English Language Arts III Reading 11 11 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_IIIV1'
					  ,CASE WHEN [English Language Arts III Reading 11 11 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_IIIV2'
					  ,CASE WHEN [English Language Arts III Reading 11 11 V006] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_IIIV6'
					  ,CASE WHEN [Spanish Language Arts III Reading 11 11 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_SPV1'
					  ,CASE WHEN [English Language Arts IV Reading 12 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_IVV1'
					  ,CASE WHEN [English Language Arts IV Reading 11 11 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'RE_IVV3'					  
					  
					  /*** EOC SCIENCE PASS FAIL DETERMINATION ***/
					  ,CASE WHEN [PASS FAIL_BIOLOGY] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_BIO'
					  ,CASE WHEN [PASS FAIL_CHEMISTRY] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_CHE'
					  ,CASE WHEN [Biology 9 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_BIO2'
					  ,CASE WHEN [Biology 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_BIO3'
					   ,CASE WHEN [Biology 9 12 V007] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_BIO7'
					  ,CASE WHEN [Chemistry 9 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_CHEM2'
					  ,CASE WHEN [Chemistry 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'SC_CHEM3'
					  ,CASE WHEN [Chemistry 9 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'CHEMV1'
					  ,CASE WHEN [Chemistry 9 12 V008] = 'PASS' THEN '1' ELSE '0'
					  END AS 'CHEM8'
					  ,CASE WHEN [Physics 9 12 V003] = 'PASS' THEN '1' ELSE '0'
					  END AS 'PHY8'
					  ,CASE WHEN [Anatomy Physiology 11 12 V002] = 'PASS' THEN '1' ELSE '0'
					  END AS 'PHYS'
					  ,CASE WHEN [Environmental Science 10 12 V001] = 'PASS' THEN '1' ELSE '0'
					  END AS 'ENV'
					  --,CASE WHEN [Chemistry (Spanish) V2] = 'PASS' THEN '1' ELSE '0'
					  --END AS 'CHEMSP2'
				  FROM [EOC_AIMS_SBA_AND_EOC]
				) AS PF  
			) AS T1	
			LEFT JOIN
				[SBA_ARRAY] AS SBA
				ON SBA_FC = SBA.SBA_Array
		) AS T2
	)AS T3
	LEFT JOIN
	(
	SELECT
		STUD_ID
		,MATE
		,REAE
		,SCIE
	FROM
		(
		SELECT
		ID_NBR
		,TEST_SUB
		,ID_NBR AS STUD_ID
		FROM
			[EXIT_EXAM_STATUS_SBA_COUNTS]
		)AS TSUB 
		PIVOT
		(
		COUNT(ID_NBR) FOR TEST_SUB IN ([MATE], [REAE], [SCIE])) AS HOPE)I
		ON T3.ID_NBR = STUD_ID
	) AS T4

	LEFT JOIN
	(
	SELECT
		TUD_ID
		,WRITING AS WRIT
		,SS AS SOC_STU
	FROM
		(
		SELECT
		ID_NBR
		,TEST_SUB
		,ID_NBR AS TUD_ID
		FROM
			[dbo].[EOC_COUNTS]
		)AS TSUB 
		PIVOT
		(
		COUNT(ID_NBR) FOR TEST_SUB IN ([WRITING], [SS])) AS HOPE)G
		ON T4.ID_NBR = TUD_ID


	

)AS FINAL	
--WHERE ID_NBR = '103957023'
--WHERE [PASSED ALL REQUIRED TESTS] = 'YES'
ORDER BY [PASSED ALL REQUIRED TESTS]


--ROLLBACK