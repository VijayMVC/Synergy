BEGIN TRAN

SELECT
	SCH_NBR
	,COUNT(ID_NBR) [Total_Enrollment]
FROM
	DBTSIS.ST010 WITH(NOLOCK) 	
	WHERE SCH_YR =2013
	AND DST_NBR = 1
	AND SCH_NBR NOT IN (533, 333,433, 233)
	AND END_ENR_DT NOT LIKE '%0000'
GROUP BY SCH_NBR
ORDER BY SCH_NBR
ROLLBACK