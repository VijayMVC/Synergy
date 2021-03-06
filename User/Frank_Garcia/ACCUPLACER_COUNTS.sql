
select
	PL_COLLEGE_LEVEL_MATH
	,LOC_NUM
	,count (aps_id) as Totals
from
(
SELECT TOP 1000 [Last Name]
      ,[First Name]
      ,[Birth Date]
      ,[Student ID]
      ,CONVERT(DATE, REPLACE([Test Date],'-',''), 101) AS TEST_DATE
	  ,[TEST DATE]
      ,[Site ID]
      ,[Site Name]
      ,[Reading]
      ,[English]
      ,[Arithmetic]
      ,[Elementary Algebra]
      ,[College Level Math]
      ,[SCH_YR]
      ,[APS_ID]
      ,[LOC_NUM]
	  ,CASE WHEN [College Level Math] >= '50' THEN 'PASS' ELSE 'FAIL'
	  END AS PL_COLLEGE_LEVEL_MATH
	  --BEGIN TRAN
	  --DELETE 
  FROM [Assessments].[dbo].[ACCUPLACER_2015-2016_V2]
  --WHERE [TEST DATE] = ''
  --ROLLBACK

  ) as t2
   WHERE [College Level Math] > 0
  group by
  PL_COLLEGE_LEVEL_MATH, LOC_NUM 

 --ORDER BY [TEST DATE]