SELECT
	*
	,CASE
	WHEN PAPOSITION.DESCRIPTION LIKE '%:%' THEN
	LTRIM (SUBSTRING(PAPOSITION.DESCRIPTION,1, CHARINDEX(':',PAPOSITION.DESCRIPTION)-1))
	ELSE Paposition.DESCRIPTION
	END
	
	 AS [DOES THIS WORK?]

		

FROM
	PAPOSITION
	
