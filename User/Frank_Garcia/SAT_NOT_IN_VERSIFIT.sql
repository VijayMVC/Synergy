/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	  DISTINCT
	   [AI_CODE]
	   ,SAT.[103427589] AS ID
      ,[AI_NAME]
      ,[FILLER_1]
      ,[COHORT_YEAR]
      ,[DISTRICT_NAME]
      ,[NAME_LAST]
      ,[NAME_FIRST]
      ,[NAME_MI]
      ,[SEX]
	  ,BIRTH_DATE
      ,[FILLER_44] AS APS_ID
  FROM [Assessments].[dbo].[CCR_SAT_2015_2016] CCR

LEFT JOIN 
TRASH_SAT_MATH_FROM_VF AS SAT
ON CCR.FILLER_44 = SAT.[103427589]
WHERE [103427589] IS NULL

  ORDER BY FILLER_44