SELECT
	*
	,CASE
	WHEN PAPOSITION.DESCRIPTION LIKE '%:%' THEN
	LTRIM (SUBSTRING(PAPOSITION.DESCRIPTION, CHARINDEX(':',PAPOSITION.DESCRIPTION)+1, LEN(PAPOSITION.DESCRIPTION)))
	ELSE Paposition.DESCRIPTION
	END
	
	 AS [DOES THIS WORK?]
FROM
	PAPOSITION
ORDER BY [DOES THIS WORK?]	
	
