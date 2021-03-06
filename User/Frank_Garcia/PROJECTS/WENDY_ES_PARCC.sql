/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	 '2014-2015' AS 'SCHOOL YEAR'
	 ,PARC.[student_code] AS 'APS STUDENT ID'
	 ,STUD.state_id AS 'STATE STUDENT ID'
	 ,'PARCC' AS 'TEST TYPE NAME'
	 ,CASE WHEN test_section_name = 'ELA' OR test_section_name = 'MATH' THEN test_section_name +' '+ test_level_name
	       ELSE test_section_name
	  END AS 'TEST SECTION NAME'
	  ,score_group_code AS 'SCORE GROUP CODE'
	  ,score_group_name AS 'SCORE GROUP NAME'
	  ,scaled_score AS 'SCALED SCORE'
      --,PARC.[school_year]
      --,PARC.[school_year]
      --,PARC.[school_code]
      --,[test_date_code]
      --,[test_type_code]
      --,[test_type_name]
      --,[test_section_code]
      --,[test_section_name]
      --,[parent_test_section_code]
      --,[low_test_level_code]
      --,[high_test_level_code]
      --,[test_level_name]
      --,[version_code]
      --,[score_group_name]
      --,[score_group_code]
      --,[score_group_label]
      --,PARC.[last_name]
      --,PARC.[first_name]
      --,PARC.[DOB]
      --,[raw_score]
      --,[scaled_score]
      --,[nce_score]
      --,[percentile_score]
      --,[score_1]
      --,[score_2]
      --,[score_3]
      --,[score_4]
      --,[score_5]
      --,[score_6]
      --,[score_7]
      --,[score_8]
      --,[score_9]
      --,[score_10]
      --,[score_11]
      --,[score_12]
      --,[score_13]
      --,[score_14]
      --,[score_15]
      --,[score_16]
      --,[score_17]
      --,[score_18]
      --,[score_19]
      --,[score_20]
      --,[score_21]
      --,[score_raw_name]
      --,[score_scaled_name]
      --,[score_nce_name]
      --,[score_percentile_name]
      --,[score_1_name]
      --,[score_2_name]
      --,[score_3_name]
      --,[score_4_name]
      --,[score_5_name]
      --,[score_6_name]
      --,[score_7_name]
      --,[score_8_name]
      --,[score_9_name]
      --,[score_10_name]
      --,[score_11_name]
      --,[score_12_name]
      --,[score_13_name]
      --,[score_14_name]
      --,[score_15_name]
      --,[score_16_name]
      --,[score_17_name]
      --,[score_18_name]
      --,[score_19_name]
      --,[score_20_name]
      --,[score_21_name]
  FROM [Assessments].[dbo].[test_result_PARCC_ES_MS] AS PARC
  LEFT JOIN
  allstudents_ALL AS STUD
  ON PARC.student_code = STUD.student_code
  AND PARC.school_code = STUD.school_code
  AND STUD.school_year = '2014'