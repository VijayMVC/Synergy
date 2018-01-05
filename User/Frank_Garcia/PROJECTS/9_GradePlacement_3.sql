/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      DISTINCT
      [score_group_code]
      ,[score_group_name]
      ,[test_type_code]
      ,[test_type_code]
      ,TEST_SECTION_NAME
  FROM [AIMS].[dbo].[test_result_9P]
  ORDER BY SCORE_GROUP_CODE