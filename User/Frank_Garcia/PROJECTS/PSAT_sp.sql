USE [SchoolNet]
GO
/****** Object:  StoredProcedure [dbo].[PSAT_sp]    Script Date: 01/02/2014 08:55:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure  [dbo].[PSAT_sp] AS

/****
 
 * $LastChangedBy: Terri Christiansen
 * $LastChangedDate: 7/18/2013 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * SAT test
 * Tables Referenced:  Experiment with a Standardized test layout.
	In this case, PSAT 
****/
TRUNCATE TABLE test_result_PSAT
--GO
INSERT INTO dbo.test_result_PSAT
/* This requires a pivot, so experiment with syntax */
SELECT
	student_code 
	,school_year
	,school_code
	,test_date_code
	,test_type_code
	,test_type_name
	,
	CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN 'C1'
		WHEN 'MathMScore' THEN 'M1'
		WHEN 'WritingSkillsWScore' THEN 'W1'
	END test_section_code
	,
	CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN 'Critical Reading'
		WHEN 'MathMScore' THEN 'Mathematics' 
		WHEN 'WritingSkillsWScore' THEN 'Writing Skills'
	END test_section_name
	,
	CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN '0'
		WHEN 'MathMScore' THEN '0'
		WHEN 'WritingSkillsWScore' THEN '0'
	END parent_test_section_code
	,low_test_level_code
	,high_test_level_code
	,test_level_name
	,version_code
	,
	
	CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN 
			CASE 
				WHEN proficiency_Level < '50' 
				THEN 'Fail' 
			ELSE 'Pass'  
			END 
		WHEN 'MathMScore' THEN 
		CASE 
			WHEN proficiency_Level < '50' 
			THEN 'Fail' 
		ELSE 'Pass'  
		 END 	
		WHEN 'WritingSkillsWScore' THEN 
			CASE 
				WHEN proficiency_Level < '49' 
				THEN 'Fail' 
			ELSE 'Pass' 
			 END 
		
	END score_group_name
 
	,CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN 
			CASE 
				WHEN proficiency_Level < '50' 
				THEN 'F' 
			ELSE 'P'  
			END 
		WHEN 'MathMScore' THEN 
		CASE 
			WHEN proficiency_Level < '50' 
			THEN 'F' 
		ELSE 'P'  
		 END 	
		WHEN 'WritingSkillsWScore' THEN 
			CASE 
				WHEN proficiency_Level < '49' 
				THEN 'F' 
			ELSE 'P' 
			 END 
		
	END  score_group_code
	,score_group_label
	,last_name
	,first_name
	, DOB
	,raw_score
	/*If the student didn't complete a test, set the scaled score to zero*/
	,scaled_score = proficiency_Level
	,nce_score
	,percentile_score = 
	CASE test_section_name
		WHEN 'CriticalReadingCRScore' THEN CritReadgNatlPercentile
		WHEN 'MathMScore' THEN MathNatlPercentile
		WHEN 'WritingSkillsWScore' THEN WrtgNatlPercentile
	END
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
	,score_raw_name
	,score_scaled_name
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
--INTO SBA_alt
 FROM
	(SELECT
		CAST([APS_ID] AS bigint)  AS student_code
		--APS_ID AS student_code
		,'2012' AS school_year
		,[APS Sch Code] AS school_code
		,'2012-10-01' AS test_date_code
		,'PSAT' AS test_type_code
		,'PSAT' AS test_type_name
		/* Need the Test Section info for the pivot*/
		,[CriticalReadingCRScore]
		,[MathMScore]
		,[WritingSkillsWScore]
		,[CritReadgNatlPercentile]
		,[MathNatlPercentile]
		,[WrtgNatlPercentile]
		,'0' AS parent_test_section_code
		,'10' AS low_test_level_code
		,'12' AS high_test_level_code
		,'12' AS test_level_name
		,'' AS version_code
		,'Performance Level' AS score_group_label
		,LastName AS last_name
		,FirstName AS first_name
		/*concatenate the year, month and day--*/
		,LEFT(STR(DOB,8,4),4)+ '-' +
		SUBSTRING ( STR(DOB,8,4) , 5 , 2 ) + '-' +
		RIGHT (STR(DOB,8,4),2) AS DOB
		--,'' AS DOB
		,'' AS raw_score
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
		,'Scale Score' AS score_scaled_name
		,'' AS score_nce_name
		,'National Percentile' AS score_percentile_name
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

	FROM [SchoolNet].[dbo].[CCR_PSAT] AS SBA_Alt
	--WHERE [APS_ID] In ('000090499','000096667') -- test student
) AS T1
/*proficiency_level is the column name we used in the main select) 
test_section_name will return the original column headers  */
UNPIVOT (proficiency_Level FOR test_section_name IN ([CriticalReadingCRScore]
		,[MathMScore]
		,[WritingSkillsWScore]
		)) AS Unpvt


