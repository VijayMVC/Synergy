USE Assessments
GO
SELECT
	[GRDE LEVEL]
	,ID_NBR
	,SCH_NBR
	,SCH_YR
	,SCORE1
	,SCORE2
	,SCORE3
	,TEST_DT
	,TEST_ID
	,TEST_SUB
	,[PROFICIENCY LEVEL]
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [ID_NBR] ORDER BY [TEST_DT]) AS RN
	  ,[GRDE] AS [GRDE LEVEL]
	  ,[ID_NBR] AS ID_NBR
      ,[SCH_NBR] AS SCH_NBR
      ,[SCH_YR] AS SCH_YR
      ,[SCORE1]
      ,'' AS [SCORE2]
      ,'' AS [SCORE3]
      ,[TEST_DT]
      ,[TEST_ID]
      ,[TEST_SUB]
	  ,CASE
		WHEN SCORE1 = 'FSP' THEN 'Fully Spanish Proficent'
		WHEN SCORE1 LIKE 'LSP%' THEN 'Limited Spanish Proficient'
		WHEN SCORE1 = 'NSP' THEN 'Non-Spanish Proficient'
		--WHEN SCORE_1 = '3' THEN 'Intermediate'
		--WHEN SCORE_1 = '4' THEN 'Early Advanced'
		--WHEN SCORE_1 IN ('5', '6') THEN 'Advanced'
	END AS 'PROFICIENCY LEVEL'
  FROM [dbo].[SP_PRE_LAS]
  WHERE School_Year = '2016-2017'
) AS T1
WHERE RN = 1
--AND ID_NBR NOT IN ('970085140','980000369','970082136','980000259','980008161','970085140','980000369')
ORDER BY ID_NBR
GO


