SELECT
      [GRDE]
      ,[ID_NBR]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_1]
      ,[SCORE_2]
      ,[SCORE_3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  ,[PROFICIENCY LEVEL]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [ID_NBR] ORDER BY [TEST_DT] DESC) AS RN 
      ,CASE WHEN [GRDE] IS NULL THEN '' ELSE GRDE
	  END AS GRDE
      ,[ID_NBR]
      ,[SCH_NBR]
      ,[SCH_YR]
      ,[SCORE_1]
      ,'' AS [SCORE_2]
      ,'' AS [SCORE_3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  ,CASE
		WHEN SCORE_1 = 'FSP' THEN 'Fully Spanish Proficent'
		WHEN SCORE_1 LIKE 'LSP%' THEN 'Limited Spanish Proficient'
		WHEN SCORE_1 = 'NSP' THEN 'Non-Spanish Proficient'
		--WHEN SCORE_1 = '3' THEN 'Intermediate'
		--WHEN SCORE_1 = '4' THEN 'Early Advanced'
		--WHEN SCORE_1 IN ('5', '6') THEN 'Advanced'
	END AS 'PROFICIENCY LEVEL'
  FROM [PR].[DBTSIS].[GS055] AS PROF

  WHERE TEST_SUB = 'SP-PRE-LAS'
  AND SCORE_1 NOT IN ('1','2','3')
) AS T1
--where [ID_NBR] = '104287974'
WHERE RN = 1
ORDER BY [PROFICIENCY LEVEL]
