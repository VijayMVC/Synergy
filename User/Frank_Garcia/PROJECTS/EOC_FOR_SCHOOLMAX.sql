/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	   [District Number] AS DST_NBR
      ,[ID Number] AS ID_NBR
      ,[Test ID] AS TEST_ID
	  ,CUT.SM_name AS TEST_SUB
      --,[Subtest] AS TEST
      ,[School Year] AS SCH_YR
      ,[test Date] AS TEST_DT
      ,[School] AS SCH_NBR
      ,[Grade] AS GRDE
      ,[Score1] AS SCORE1
      ,[Score2] AS SCORE2
      ,[Score3] AS SCORE3
      --,[DOB]
      --,[last_name]
      --,[first_name]
  FROM [SchoolNet].[dbo].[EOC_] AS EOC
  LEFT JOIN
  EoC_Cut_Scores AS CUT
  ON 
  EOC.Subtest = CUT.STARS_name
  AND EOC.[test Date] = CUT.assessment_test_date
  AND EOC.assessment_id = CUT.assessment_id
  WHERE School IS NOT NULL and School != '998' and Grade != 'KF' and School != '997'
  --where (school  > 200 or school = '048')
  --and [District Number] = '001'
  order by Subtest

