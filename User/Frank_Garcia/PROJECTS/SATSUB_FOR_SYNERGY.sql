/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
	   [DISTRICT CODE]
      ,[TEST DESCRIPTION]
      ,[ASSESSMENT SCHOOL YEAR DATE]
      ,[ITEM DESCRIPTION CODE]
      ,[TEST DATE]
      ,[STUDENT ID]
      ,[LOCATION CODE]
      ,[RAW SCORE]
	  ,
	  ,CASE 
		    WHEN ([ITEM DESCRIPTION CODE] = 'LITERATURE' AND [RAW SCORE] >= 574) THEN 'PASS'
		    WHEN ([ITEM DESCRIPTION CODE] = 'US HISTORY' AND [RAW SCORE] >= 610) THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'WORLD HISTORY' AND [RAW SCORE] >= 589 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'MATH LEVEL 1' AND [RAW SCORE] >= 587 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'MATH LEVEL 2' AND [RAW SCORE] >= 647 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'ECOLOGICAL BIOLOGY' AND [RAW SCORE] >= 593 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'MOLECULAR BIOLOGY' AND [RAW SCORE] >= 624 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'CHEMISTRY' AND [RAW SCORE] >= 642 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'PHYSICS' AND [RAW SCORE] >= 632 THEN 'PASS'
			WHEN [ITEM DESCRIPTION CODE] = 'CHINESE WITH LISTENING' AND [RAW SCORE] >= 0 THEN ''
			WHEN [ITEM DESCRIPTION CODE] = 'SPANISH' AND [RAW SCORE] >= 0 THEN ''
			WHEN [ITEM DESCRIPTION CODE] = 'SPANISH WITH LISTENING' AND [RAW SCORE] >= 0 THEN ''
			ELSE 'FAIL'
	END AS 'PERFROMANCE LEVEL'
  FROM [Assessments].[dbo].[CCR_FOR_STARS]
  WHERE 1 =1
		--AND [ITEM DESCRIPTION CODE] = 'LITERATURE'
		--AND [ITEM DESCRIPTION CODE] = 'US HISTORY'
		--AND [ITEM DESCRIPTION CODE] = 'WORLD HISTORY'
		--AND [ITEM DESCRIPTION CODE] = 'MATH LEVEL 1'
		--AND [ITEM DESCRIPTION CODE] = 'MATH LEVEL 2'
		--AND [ITEM DESCRIPTION CODE] = 'ECOLOGICAL BIOLOGY'
		--AND [ITEM DESCRIPTION CODE] = 'MOLECULAR BIOLOGY'
		--AND [ITEM DESCRIPTION CODE] = 'CHEMISTRY'
		AND [ITEM DESCRIPTION CODE] = 'PHYSICS'
  --ORDER BY [ITEM DESCRIPTION CODE]