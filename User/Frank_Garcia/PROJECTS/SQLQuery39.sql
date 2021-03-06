USE [Assessments]
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_EES_sp]    Script Date: 10/28/2015 4:31:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].EXECUTE [test_result_EES_sp]    Script Date: 04/17/2014 11:19:12 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
ALTER Procedure [dbo].[test_result_EES_sp] AS
--/****
 
-- * $LastChangedBy: Terri Christiansen
-- * $LastChangedDate: 9/3/2013 $
-- *
-- * Request By: SchoolNet
-- * InitialRequestDate: 
-- * 
-- * Initial Request:
-- * Exit Exam Status test
-- * Tables Referenced:  Experiment with a Standardized test layout.
--	In this case, Exit Exam Status
--****/
TRUNCATE TABLE dbo.test_result_EES
INSERT INTO dbo.test_result_EES
/* This requires a pivot, so experiment with syntax */

--Child Section of Exit Exam Status--has the pivot
SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,LEFT (test_section_name, 4) AS test_section_Code
	--take the underscores out
	,REPLACE(test_section_name, '_', ' ' ) AS test_section_name
	,parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	/* Need the Test Section info for the pivot*/
	,CASE
		WHEN proficiency_Level = '' OR proficiency_Level IS NULL THEN 'Not Yet Tested'
		ELSE
			CASE
			WHEN test_section_name = 'Reading SBA' THEN [PASS FAIL_READING]
			WHEN test_section_name = 'Science SBA' THEN [PASS FAIL_SCIENCE]
			WHEN test_section_name = 'Math SBA' THEN [PASS FAIL_MATH]
			--WHEN test_section_name = 'Writing EOC' THEN [PASS FAIL_WRITING]
			--WHEN test_section_name = 'Chemistry EOC' THEN [PASS FAIL_CHEMISTRY]
			WHEN test_section_name = 'Combo MR SBA' AND proficiency_level != '' THEN [PASS FAIL_RM]
			--WHEN test_section_name = 'NMHIST EOC' THEN [PASS FAIL_NMHIST]
			--WHEN test_section_name = 'USGOV EOC' THEN [PASS FAIL_USGOV]
			--WHEN test_section_name = 'Economics EOC' THEN [PASS FAIL_ECON]
			--WHEN test_section_name = 'Biology EOC' THEN [PASS FAIL_BIOLOGY]
		ELSE 'Not Yet Tested'
		END
	END score_group_name
	,CASE
			WHEN test_section_name = 'Reading SBA' THEN [PASS FAIL_READING]
			WHEN test_section_name = 'Science SBA' THEN [PASS FAIL_SCIENCE]
			WHEN test_section_name = 'Math SBA' THEN [PASS FAIL_MATH]
			--WHEN test_section_name = 'Writing EOC' THEN [PASS FAIL_WRITING]
			--WHEN test_section_name = 'Chemistry EOC' THEN [PASS FAIL_CHEMISTRY]
			WHEN test_section_name = 'Combo MR SBA' AND proficiency_Level != '' THEN [PASS FAIL_RM]
			--WHEN test_section_name = 'NMHIST EOC' THEN [PASS FAIL_NMHIST]
			--WHEN test_section_name = 'USGOV EOC' THEN [PASS FAIL_USGOV]
			--WHEN test_section_name = 'Economics EOC' THEN [PASS FAIL_ECON]
			--WHEN test_section_name = 'Biology EOC' THEN [PASS FAIL_BIOLOGY]
	ELSE 'NYT' 
	END score_group_code
	,score_group_label
	,last_name
	,first_name
	,DOB
	/*if the test is an End of Course, then it's a raw score*/
	,CASE
		WHEN test_section_name IS NULL THEN '' 
		WHEN test_section_name = 'NULL' THEN ''
		ELSE
		CASE
		WHEN RIGHT(test_section_name,3)= 'EOC'  THEN cast(proficiency_Level AS VARCHAR)
		ELSE ''
	 END
	 END raw_score
	/*If the test is an SBA then it's a scale score*/
	,CASE
			WHEN test_section_name IS NULL THEN ''
			WHEN test_section_name = 'NULL'  THEN '' 
			ELSE
			CASE
				WHEN RIGHT(test_section_name,3) = 'SBA' THEN cast(proficiency_Level AS VARCHAR)
		ELSE ''
	 END
	 END scaled_score
	,nce_score
	,percentile_score
	,score_1
	,score_2
	,score_3
	,score_4
	,score_5
	,score_6
	,score_7
	,score_8
	,score_9
	,score_10
	,score_11
	,score_12
	,score_13
	,score_14
	,score_15
	,score_16
	,score_17
	,score_18
	,score_19
	,score_20
	,score_21
	/*if the test is an End of Course, then it's a raw score*/
	,CASE
		WHEN RIGHT(test_section_name,3) = 'EOC' THEN 'Raw Score'
		ELSE ''
	 END score_raw_name
	/*If the test is an SBA then it's a scale score*/
	,CASE
		WHEN RIGHT(test_section_name,3) = 'SBA' THEN 'Scaled Score'
		ELSE ''
	 END score_scaled_name
	,score_nce_name
	,score_percentile_name
	,score_1_name
	,score_2_name
	,score_3_name
	,score_4_name
	,score_5_name
	,score_6_name
	,score_7_name
	,score_8_name
	,score_9_name
	,score_10_name
	,score_11_name
	,score_12_name
	,score_13_name
	,score_14_name
	,score_15_name
	,score_16_name
	,score_17_name
	,score_18_name
	,score_19_name
	,score_20_name
	,score_21_name
 FROM
	(SELECT
		[id_nbr]  AS student_code
		,'2015' AS school_year
		,[School] AS school_code
		,'2015-10-23' AS test_date_code
		,'EES' AS test_type_code
		,'Exit Exam Status' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,[Reading SBA]
		,[Science SBA]
		,[Math SBA]
		,[Combo MR SBA]
		,[SCI_FD]
		--,[Writing EOC]
		--,[Chemistry EOC]
		--,[Biology EOC]
		--,[Economics EOC]
		--,[USGOV EOC]
		--,[NMHIST EOC]
		,'1' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,RIGHT('00'+ CONVERT(VARCHAR,GRADE),2)  AS test_level_name
		,'' AS version_code
		/* Need the Pass Fail info for the score group*/
		,[PASS FAIL_READING]
		,[PASS FAIL_MATH]
		,[PASS FAIL_RM]
		,[PASS FAIL_SCIENCE]
		--,[PASS FAIL_WRITING]
		--,[PASS FAIL_ECON]
		--,[PASS FAIL_USGOV]
		--,[PASS FAIL_NMHIST]
		--,[PASS FAIL_CHEMISTRY]
		--,[PASS FAIL_BIOLOGY]
		,'Performance Level' AS score_group_label
		,[Last_Name] AS last_name
		,[First_name] AS first_name
		,'' AS DOB
		,'' AS raw_score
		,'' AS scaled_score
		,'' AS nce_score
		,'' AS percentile_score
		,'' AS score_1
		,'' AS score_2
		,'' AS score_3
		,'' AS score_4
		,'' AS score_5
		,'' AS score_6
		,'' AS score_7
		,'' AS score_8
		,'' AS score_9
		,'' AS score_10
		,'' AS score_11
		,'' AS score_12
		,'' AS score_13
		,'' AS score_14
		,'' AS score_15
		,'' AS score_16
		,'' AS score_17
		,'' AS score_18
		,'' AS score_19
		,'' AS score_20
		,'' AS score_21
		,'' AS score_raw_name
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name
		,'' AS score_1_name
		,'' AS score_2_name
		,'' AS score_3_name
		,'' AS score_4_name
		,'' AS score_5_name
		,'' AS score_6_name
		,'' AS score_7_name
		,'' AS score_8_name
		,'' AS score_9_name
		,'' AS score_10_name
		,'' AS score_11_name
		,'' AS score_12_name
		,'' AS score_13_name
		,'' AS score_14_name
		,'' AS score_15_name
		,'' AS score_16_name
		,'' AS score_17_name
		,'' AS score_18_name
		,'' AS score_19_name
		,'' AS score_20_name
		,'' AS score_21_name
	FROM [EXIT EXAM STATUS] AS SBA_Alt
	--WHERE [id_nbr] = '103450474' -- test student
) AS T1
/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (proficiency_Level FOR test_section_name IN 
	([Reading SBA]
		,[Math SBA]
		,[Combo MR SBA]
		,[Science SBA]
		--,[Writing EOC]
		--,[Chemistry EOC]
		--,[Biology EOC]
		--,[Economics EOC]
		--,[NMHIST EOC]
		--,[USGOV EOC]
	 )) AS Unpvt
--ORDER BY test_section_name
--WHERE student_code = '103450474'

UNION
--Parent Section of Exit Exam Status--

SELECT
		[id_nbr]  AS student_code
		,'2015' AS school_year
		,[School] AS school_code
		,'2015-10-23' AS test_date_code
		,'EES' AS test_type_code
		,'Exit Exam Status' AS test_type_name
		,'1' AS test_section_Code
		,'Graduation Test Requirements' AS test_section_name
		,'0' AS parent_test_section_code
		,'K' AS low_test_level_code
		,'12' AS high_test_level_code
		,RIGHT('00'+ CONVERT(VARCHAR,GRADE),2)  AS test_level_name
		,'' AS version_code
		,CASE WHEN [READING REQUIREMENT] = 'PASSED' AND [WRITING REQUIREMENT] = 'PASSED' AND [MATH REQUIREMENTS] = 'PASSED' AND [SCIENCE REQUIREMENTS] = 'PASSED' AND [SS REQUIREMENTS] = 'PASSED' THEN 'MET' ELSE 'NOT MET'
		END AS score_group_name
		,CASE WHEN [READING REQUIREMENT] = 'PASSED' AND [WRITING REQUIREMENT] = 'PASSED' AND [MATH REQUIREMENTS] = 'PASSED' AND [SCIENCE REQUIREMENTS] = 'PASSED' AND [SS REQUIREMENTS] = 'PASSED' THEN 'MET' ELSE 'NOT MET'
		END AS score_group_code
		--,CASE WHEN [Passed All Required Tests] = 'YES' THEN 'MET' ELSE 'NOT MET' END AS score_group_name
		--,CASE WHEN [Passed All Required Tests] = 'YES' THEN 'MET' ELSE 'NOT MET' END AS score_group_code
		,'Overall Status' AS score_group_label
		,[Last_Name] AS last_name
		,[First_name] AS first_name
		,'' AS DOB
		,'' AS raw_score
		,'' AS scaled_score
		,'' AS nce_score
		,'' AS percentile_score
		,CASE 
			WHEN Take_EOC != '' THEN Take_EOC 
			ELSE ''
		END  score_1
		,CASE 
			WHEN Take_SBA != 'NULL' THEN Take_SBA
			ELSE ''
		END score_2
		,CASE WHEN [MATH SBA ATTEMPTS] = 'NULL' OR [MATH SBA ATTEMPTS] IS NULL THEN '0' ELSE [MATH SBA ATTEMPTS] END AS score_3
		,CASE WHEN [READING SBA ATTEMPTS] = 'NULL' OR [READING SBA ATTEMPTS] IS NULL THEN '0' ELSE [READING SBA ATTEMPTS] END AS score_4
		,CASE WHEN [SCIENCE SBA ATTEMPTS] = 'NULL' OR [SCIENCE SBA ATTEMPTS] IS NULL THEN '0' ELSE [SCIENCE SBA ATTEMPTS]  END AS score_5
		,CASE WHEN [SCIENCE SBA ATTEMPTS] = 'NULL' OR [SCIENCE SBA ATTEMPTS] IS NULL THEN 'Not Yet Attempted' ELSE [SCI_FD] END AS score_6
		,'' AS score_7
		,CASE WHEN [EOC_SOCIAL_STUDIES_ATTEMPTS] = 'NULL' OR EOC_SOCIAL_STUDIES_ATTEMPTS IS NULL THEN '0' ELSE [EOC_SOCIAL_STUDIES_ATTEMPTS]  END AS score_8
		,CASE WHEN [EOC_WRITING_ATTEMPTS] = 'NULL' OR EOC_WRITING_ATTEMPTS IS NULL THEN '0'  ELSE [EOC_WRITING_ATTEMPTS]  END AS score_9
		,'' AS score_10
		,CASE WHEN [PARCC ELA 11 ATTEMPTS] IS NULL THEN '0' ELSE [PARCC ELA 11 ATTEMPTS] END  AS score_11
		,CASE WHEN [PARCC ALGEBRA 2 ATTEMPTS] IS NULL THEN '0' ELSE [PARCC ALGEBRA 2 ATTEMPTS] END AS score_12
		,CASE WHEN [PARC GEOMETRY ATTEMPTS] IS NULL THEN '0' ELSE [PARC GEOMETRY ATTEMPTS] END AS score_13
		,'' AS score_14
		,[READING REQUIREMENT] AS score_15
		,[WRITING REQUIREMENT] AS score_16
		,[MATH REQUIREMENTS] AS score_17
		,[SCIENCE REQUIREMENTS] AS score_18
		,[SS REQUIREMENTS] AS score_19
		,'' AS score_20
		,'' AS score_21
		,'' AS score_raw_name
		,'' AS score_scaled_name
		,'' AS score_nce_name
		,'' AS score_percentile_name 
		,'Take EOC' AS score_1_name
		,'Take SBA' AS score_2_name
		,'MATH SBA ATTEMPTS' AS score_3_name
		,'READING SBA ATTEMPTS' AS score_4_name
		,'SCIENCE SBA ATTEMPTS' AS score_5_name
		,'SCIENCE FINAL DETERMINATION' AS score_6_name
		,'' AS score_7_name
		,'EOC_SOCIAL_STUDIES_ATTEMPTS' AS score_8_name
		,'EOC_WRITING_ATTEMPTS' AS score_9_name
		,'' AS score_10_name
		,'PARCC ELA 11 ATTEMPTS' AS score_11_name
		,'PARCC ALGEBRA II ATTEMPTS' AS score_12_name
		,'PARCC GEOMETRY ATTEMPTS' AS score_13_name
		,'' AS score_14_name
		,'READING REQUIREMENT' AS score_15_name
		,'WRITING RQUIREMENT' AS score_16_name
		,'MATH REQUIREMENT' AS score_17_name
		,'SCIENCE REQUIREMENT' AS score_18_name
		,'SS REQUIREMENT' AS score_19_name
		,'' AS score_20_name
		,'' AS score_21_name
FROM [EXIT EXAM STATUS] AS EES
--WHERE ID_NBR = '103450474'  -- test student
--WHERE [Passed All Required Tests] = 'YES'
ORDER BY score_3


