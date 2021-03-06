/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  [student_code] AS 'APS ID'
      ,CAST ([school_year] AS VARCHAR (5)) +' - '+ CAST (([SCHOOL_YEAR] + 1)AS VARCHAR (5)) AS 'SCHOOL YEAR'
	  ,score_16 AS 'STATE ID'
      ,SCHOOL_CODE AS 'SCHOOL LOCATION CODE'
      --,[test_date_code]
      --,[test_type_code]
      ,[test_type_name] AS 'TEST NAME'
      --,[test_section_code]
      ,[test_section_name] AS 'CONTENT AREA'
      --,[parent_test_section_code]
      --,[low_test_level_code]
      --,[high_test_level_code]
      --,[test_level_name] AS 'SBA GRADE LEVEL'
	  ,score_15 AS 'GRADE LEVEL'
      --,[version_code]
      ,[score_group_name] AS 'OVERALL PROFICIENCY LEVEL'
      ,[scaled_score] AS 'OVERALL SCALED SCORE'
      --,[score_group_code]
      --,[score_group_label]
      ,[last_name] AS 'LAST NAME'
      ,[first_name] AS 'FIRST NAME'
      --,[dob]
      --,[raw_score]
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
  FROM [180-SMAXODS-01].[SchoolNet].[dbo].[SBA] AS SBA
  --LEFT JOIN
  --[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
  --ON SBA.student_code = STUD.[ALTERNATE STUDENT ID]
  --AND STUD.PERIOD = '2014-06-01'
  WHERE SCHOOL_CODE IN ('418','485','492','515','550','575','580')
  --AND school_year IN ('2011','2012','2013')
  --AND school_year = '2013'
  AND test_section_name = 'WRITING'
  AND score_15 IN ('06','07','08','09','10')
  AND school_year = '2013'
  --AND score_group_name != 'INSUFFICIENT DATA'
  ORDER BY [APS ID]
