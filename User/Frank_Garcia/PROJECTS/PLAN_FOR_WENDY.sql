
SELECT 
	STID AS STATE_ID
	,APS_ID
	,school_code AS [APS Sch Code]
	,TEST
	,test_level_name AS TEST_LEVEL
	,ENGLISH
	,CASE	
		WHEN RIGHT ('00'+ENGLISH,2) < '15' THEN 'FAIL' ELSE 'PASS'
	END AS ENGLISH_PL
	,MATH
	,CASE	
		WHEN RIGHT ('00'+MATH,2) < '19' THEN 'FAIL' ELSE 'PASS'
	END AS MATH_PL
	,READING
	,CASE	
		WHEN RIGHT ('00'+READING,2) < '17' THEN 'FAIL' ELSE 'PASS'
	END AS READING_PL
	,SCIENCE
	,CASE	
		WHEN RIGHT ('00'+SCIENCE,2) < '21' THEN 'FAIL' ELSE 'PASS'
	END AS SCIENCE_PL
	,COMPOSITE
	,'NO CUT SCORE' AS COMPOSITE_PL
	,[School Year] AS SCH_YR
	
	
FROM
(
SELECT 
	  [STID]
      ,[FName]
      ,[MI]
      ,[LName]
      ,[DOB]
      ,[SUBTEST]
      ,[TEST]
      ,[SCORE]
      ,[APS_ID]
      ,[test_level_name]
      ,[test_date_code]
      ,[school_code]
      ,[School Year]
      ,[APS_ID_2]
  FROM [SchoolNet].[dbo].[CCR_PLAN]
  WHERE [School Year] = '2012-2013'
) AS T1
  PIVOT (MAX(SCORE) FOR SUBTEST IN ([ENGLISH], [MATH], [READING], [SCIENCE], [COMPOSITE])) AS P1

  WHERE  (ENGLISH != '' OR MATH != '' OR READING != '' OR SCIENCE != '' OR COMPOSITE != '')
  AND APS_ID > '1'
  AND school_code NOT IN ('025','069')
  ORDER BY [APS Sch Code]
