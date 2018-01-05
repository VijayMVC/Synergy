SELECT 
		COUNT (STATE_ID)RECORD_COUNT
      ,[School_Year]
      ,[Test_Window]
      ,[Test_Type]
  FROM [db_DRA].[dbo].[DRA_FOR_PASCAL]
  --WHERE SCHOOL_YEAR = 'WINTER'
  GROUP BY
	SCHOOL_YEAR
	,TEST_WINDOW
	,TEST_TYPE
	ORDER BY SCHOOL_YEAR DESC, TEST_TYPE